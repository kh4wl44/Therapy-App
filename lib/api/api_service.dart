import 'dart:io';

import 'package:lati_project/api/registration_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:lati_project/features/auth/screens/Register/chooseTopicsToShare.dart';
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// Define your data classes
class UserSignUpRequest {
  final String name;
  final String username;
  final String email;
  final String password;
  //final String confirmPassword;
  final bool isTherapist;

  UserSignUpRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    // required this.confirmPassword,
    required this.isTherapist,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'isTherapist': isTherapist,
    };
  }
}

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final Dio _dio = Dio();
  final Logger _logger = Logger();
   final RegistrationController _registrationController;
   
   ApiService(this._registrationController);

  Future<Map<String, dynamic>> signupUser(UserSignUpRequest userRequest) async {
    const String url = '$baseUrl/signup';

    try {
      _logger.i('Sending request to: $url');
      _logger.i('Request data: ${userRequest.toJson()}');

      final response = await _dio.post(
        url,
        data: userRequest.toJson(),
        options: Options(validateStatus: (status) => status! < 500),
      );

      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');
      _logger.i('Full response: $response');

      if (response.statusCode == 201) {
        String token = response.data['token'];
        _logger.i('Token received from server: $token');
        await _registrationController.saveAuthToken(token);
        return {'success': true, 'message': 'Signup successful!'};
      } else {
        return {
          'success': false,
          'message': 'Signup failed: ${response.data}',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      _logger.e('DioException: ${e.toString()}');
      _logger.e('DioException response: ${e.response}');
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Server error: ${e.response?.data}',
          'statusCode': e.response?.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${e.message}',
        };
      }
    } catch (error) {
      _logger.e('Unexpected error: $error');
      return {
        'success': false,
        'message': 'Unexpected error: $error',
      };
    }
  }

  
  

  Future<Map<String, dynamic>> sendClientPreferences(
      Map<String, dynamic> preferencesMap) async {
    const String url = '$baseUrl/clientPreferences';

    try {
      String token = preferencesMap['token'] as String;
       _logger.i('Token retrieved for sending preferences:  ${token.isNotEmpty ? "Token present" : "No token"}');
      if (token.isEmpty) {
        
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

          final dataToSend = Map<String, dynamic>.from(preferencesMap)..remove('token');

      _logger.i('Sending client preferences to: $url');
      _logger.i('Request data: ${dataToSend}');
      _logger.i('Authorization token: ${token.isNotEmpty ? "Present" : "Missing"}');

      final response = await _dio.post(
        url,
        data: dataToSend,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );
      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');
      _logger.i('Full response: $response');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User preferences saved successfully'
        };
      } else {
        _logger.e('Failed to save preferences. Status: ${response.statusCode}, Data: ${response.data}');
        return {
          'success': false,
          'message': 'Failed to save preferences: ${response.data}',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      _logger.e('DioException: ${e.toString()}');
      _logger.e('DioException response: ${e.response}');
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Server error: ${e.response?.data}',
          'statusCode': e.response?.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${e.message}',
        };
      }
    } catch (error) {
      _logger.e('Unexpected error: $error');
      return {
        'success': false,
        'message': 'Unexpected error: $error',
      };
    }
  }

  Future<Map<String, dynamic>> sendTherapistDetails(TherapistDetails details, File certificateFile) async {
    const String url = '$baseUrl/therapistDetails';

    try {
       String token = await _registrationController.getAuthToken(); // Implement this method to retrieve the stored token
      if (token.isEmpty) {
        return {
          'success': false,
          'message': 'No authentication token found',
        };
      }

      // Create form data
      FormData formData = FormData.fromMap({
        "therapistDetails": details.toJson().toString(), // Convert to string as the server expects
        "certificate": await MultipartFile.fromFile(
          certificateFile.path,
          filename: 'certificate.jpg', // Adjust filename as needed
          contentType: MediaType('image', 'jpeg'), // Adjust content type as needed
        ),
      });

      _logger.i('Sending therapist details to: $url');
      _logger.i('Therapist details: ${details.toJson()}');
      _logger.i('Certificate file: ${certificateFile.path}');

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Therapist details saved successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to save therapist details: ${response.data}',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      _logger.e('DioException: ${e.toString()}');
      _logger.e('DioException response: ${e.response}');
      if (e.response != null) {
        return {
          'success': false,
          'message': 'Server error: ${e.response?.data}',
          'statusCode': e.response?.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${e.message}',
        };
      }
    } catch (error) {
      _logger.e('Unexpected error: $error');
      return {
        'success': false,
        'message': 'Unexpected error: $error',
      };
    }
  }


  Future<List<TherapistDetails>> searchTherapists(SearchFilters filters) async {
    const String url = '$baseUrl/search/therapists';

    try {
      String token = await _registrationController.getAuthToken();
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      _logger.i('Sending search request to: $url');
      _logger.i('Search filters: ${filters.toJson()}');

      final response = await _dio.post(
        url,
        data: filters.toJson(),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');

      if (response.statusCode == 200) {
        List<dynamic> therapistsJson = response.data;
        return therapistsJson.map((json) => TherapistDetails.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // Return an empty list if no therapists are found
      } else {
        throw Exception('Failed to search therapists: ${response.data}');
      }
    } on DioException catch (e) {
      _logger.e('DioException in searchTherapists: ${e.toString()}');
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (error) {
      _logger.e('Unexpected error in searchTherapists: $error');
      throw Exception('Unexpected error: $error');
    }
  }


  Future<String?> startConversation(String therapistId) async {
    const String url = '$baseUrl/start-conversation';

    try {
      String token = await _registrationController.getAuthToken();
      if (token.isEmpty) {
        throw Exception('No authentication token found');
      }

      final request = StartConversationRequest(therapistId: therapistId);

      _logger.i('Sending start conversation request to: $url');
      _logger.i('Request data: ${request.toJson()}');

      final response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');

      if (response.statusCode == 201) {
        return response.data['conversationId'] as String?;
      } else {
        throw Exception('Failed to start conversation: ${response.data}');
      }
    } on DioException catch (e) {
      _logger.e('DioException in startConversation: ${e.toString()}');
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (error) {
      _logger.e('Unexpected error in startConversation: $error');
      throw Exception('Unexpected error: $error');
    }
  }

   Future<List<Conversation>> getConversations() async {
    try {
      String token = await _registrationController.getAuthToken();
      if (token.isEmpty) {
        _logger.e('No authentication token found');
        throw Exception('No authentication token found');
      }

      // Decode the JWT token to get the user ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken['userId']; // Adjust this key based on your JWT structure

      if (userId.isEmpty) {
        _logger.e('User ID not found in token');
        throw Exception('User ID not found in token');
      }

      final String url = '$baseUrl/conversations/$userId';

      _logger.i('Sending GET request to: $url');
      _logger.i('Authorization token: Present');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => status! < 500,
        ),
      );

      _logger.i('Response status code: ${response.statusCode}');
      _logger.i('Response data: ${response.data}');

      if (response.statusCode == 200) {
        List<dynamic> conversationsJson = response.data;
        _logger.i('Number of conversations received: ${conversationsJson.length}');
        return conversationsJson.map((json) => Conversation.fromJson(json)).toList();
      } else {
        _logger.e('Failed to fetch conversations. Status: ${response.statusCode}, Data: ${response.data}');
        throw Exception('Failed to fetch conversations: ${response.data}');
      }
    } on DioException catch (e) {
      _logger.e('DioException in getConversations: ${e.toString()}');
      _logger.e('DioException response: ${e.response}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      _logger.e('Unexpected error in getConversations: $e');
      throw Exception('Error fetching conversations: $e');
    }
  }
}



class UserPreferences {
  final String userId;
  final String sessionType;
  final String gender;
  final String therapistPreference;
  final List<String> topics;
  final String languagePreference;

  UserPreferences({
     this.userId = '',
    required this.sessionType,
    required this.gender,
    required this.therapistPreference,
    required this.topics,
    required this.languagePreference,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionType': sessionType,
      'gender': gender,
      'therapistPreference': therapistPreference,
      'topics': topics,
      'languagePreference': languagePreference,
    };
  }
}


class Certificate {
  final String path;
  final String uploadDate;

  Certificate({required this.path, required this.uploadDate});

  Map<String, dynamic> toJson() => {
    'path': path,
    'uploadDate': uploadDate,
  };

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    path: json['path'],
    uploadDate: json['uploadDate'],
  );
}

class Availability {
  final int dayOfWeek;
  final String startTime;
  final String endTime;

  Availability({required this.dayOfWeek, required this.startTime, required this.endTime});

  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'startTime': startTime,
    'endTime': endTime,
  };

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    dayOfWeek: json['dayOfWeek'],
    startTime: json['startTime'],
    endTime: json['endTime'],
  );
}

class TherapistDetails {
  final String userId;
  final Certificate? certificate;
  final String? qualifications;
  final int? experience;
  final String specialty;
  final List<String> clientTypes;
  final List<String> issuesTreated;
  final List<String> treatmentApproaches;
  final double cost;
  final List<Availability> availability;
  final String gender;

  TherapistDetails({
    required this.userId,
    this.certificate,
    this.qualifications,
    this.experience,
    required this.specialty,
    required this.clientTypes,
    required this.issuesTreated,
    required this.treatmentApproaches,
    required this.cost,
    required this.availability,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'certificate': certificate?.toJson(),
    'qualifications': qualifications,
    'experience': experience,
    'specialty': specialty,
    'clientTypes': clientTypes,
    'issuesTreated': issuesTreated,
    'treatmentApproaches': treatmentApproaches,
    'cost': cost,
    'availability': availability.map((a) => a.toJson()).toList(),
    'gender': gender,
  };

  factory TherapistDetails.fromJson(Map<String, dynamic> json) => TherapistDetails(
    userId: json['userId'],
    certificate: json['certificate'] != null ? Certificate.fromJson(json['certificate']) : null,
    qualifications: json['qualifications'],
    experience: json['experience'],
    specialty: json['specialty'],
    clientTypes: List<String>.from(json['clientTypes']),
    issuesTreated: List<String>.from(json['issuesTreated']),
    treatmentApproaches: List<String>.from(json['treatmentApproaches']),
    cost: json['cost'],
    availability: (json['availability'] as List).map((a) => Availability.fromJson(a)).toList(),
    gender: json['gender'],
  );
}




class SearchFilters {
  final String? name;
  final List<String>? specialties;
  final double? cost;
  final String? availability;
  final String? gender;

  SearchFilters({
    this.name,
    this.specialties,
    this.cost,
    this.availability,
    this.gender,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (specialties != null) 'specialties': specialties,
    if (cost != null) 'cost': cost,
    if (availability != null) 'availability': availability,
    if (gender != null) 'gender': gender,
  };
}

class StartConversationRequest {
  final String therapistId;

  StartConversationRequest({required this.therapistId});

  Map<String, dynamic> toJson() => {
    'therapistId': therapistId,
  };
}

// Add these classes after your existing classes

class ChatMessage {
  final String messageId;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final int timestamp;
  final bool isFromTherapist;
  final bool isRead;

  ChatMessage({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isFromTherapist,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: json['messageId'],
    conversationId: json['conversationId'],
    senderId: json['senderId'],
    receiverId: json['receiverId'],
    content: json['content'],
    timestamp: json['timestamp'],
    isFromTherapist: json['isFromTherapist'],
    isRead: json['isRead'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'conversationId': conversationId,
    'senderId': senderId,
    'receiverId': receiverId,
    'content': content,
    'timestamp': timestamp,
    'isFromTherapist': isFromTherapist,
    'isRead': isRead,
  };
}

class Conversation {
  final String conversationId;
  final String userId;
  final String therapistId;
  final List<ChatMessage> messages;
  final bool isActive;

  Conversation({
    required this.conversationId,
    required this.userId,
    required this.therapistId,
    this.messages = const [],
    this.isActive = true,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    conversationId: json['conversationId'],
    userId: json['userId'],
    therapistId: json['therapistId'],
    messages: (json['messages'] as List?)
        ?.map((m) => ChatMessage.fromJson(m))
        .toList() ?? [],
    isActive: json['isActive'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'userId': userId,
    'therapistId': therapistId,
    'messages': messages.map((m) => m.toJson()).toList(),
    'isActive': isActive,
  };
}

