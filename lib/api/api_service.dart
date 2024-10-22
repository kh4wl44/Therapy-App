import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lati_project/api/registration_controller.dart';
import 'package:lati_project/features/auth/screens/Register/common.dart';
import 'package:lati_project/features/auth/screens/Therapist/TherapistHome.dart';
import 'package:lati_project/features/auth/screens/home_page.dart';
import 'package:lati_project/models/conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:lati_project/features/auth/screens/Register/chooseTopicsToShare.dart';
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:dio/src/multipart_file.dart' as MultipartFile;
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

class UserSignInRequest {
  final String username;
  final String password;

  UserSignInRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
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

  Future<Map<String, dynamic>> login(UserSignInRequest userSignInRequest) async {
      final url = '$baseUrl/login';

      final response = await _dio.post(
        url,
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
        data: userSignInRequest.toJson(),
      );

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        await _registrationController.saveAuthToken(token);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        await saveUserInfo(decodedToken['name'], decodedToken['email'],
            decodedToken['isTherapist'] ?? false);
        // await checkSavedInfo();

        Get.snackbar("Success", "Login successful");
        return {'success': true, 'message': 'Signup successful!', 'isTherapist': decodedToken['isTherapist']};
        // Get.to(() =>
        //     decodedToken['isTherapist'] ?? false ? TherapistHome() : HomePage);
        // Navigate to another screen or perform other actions
      } else {
        Get.snackbar("Error", "Invalid credentials");
        return {
          'success': false,
          'message': 'Invalid credentials',
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
     DioFormData.FormData formData =DioFormData.FormData.fromMap({
        "therapistDetails": details.toJson().toString(), // Convert to string as the server expects
        "certificate": await MultipartFile.MultipartFile.fromFile(
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
      _logger.i('Retrieved token: ${token.isNotEmpty ? "Token present" : "No token"}');

      if (token.isEmpty) {
        _logger.e('No authentication token found');
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
      _logger.e('Unexpected error in startConversation: $error');
      throw Exception('Unexpected error: $error');
    }
  }

   Future<List<Conversation>> getConversations() async {
    try {
      String token = await _registrationController.getAuthToken();
      String userId = await _registrationController.getAuthToken();
      
      if (token.isEmpty || userId.isEmpty) {
        _logger.e('No authentication token or user ID found');
        throw Exception('Authentication information missing');
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

      if (response.statusCode == 200) {
        List<dynamic> conversationsJson = response.data;
        _logger.i('Number of conversations received: ${conversationsJson.length}');
        // return conversationsJson.map((json) => Conversation.fromJson(json)).toList();
        return [];
      } else if (response.statusCode == 404) {
        _logger.i('No conversations found for user');
        return []; // Return an empty list if no conversations are found
      } else {
        _logger.e('Failed to fetch conversations. Status: ${response.statusCode}, Data: ${response.data}');
        throw Exception('Failed to fetch conversations: ${response.data}');
      }
    } catch (e) {
      _logger.e('Error in getConversations: $e');
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
  String name;
  Details details;

  TherapistDetails({ required this.name, required this.details});

  static TherapistDetails fromJson(Map<String, dynamic> json) =>
  TherapistDetails(  name : json['name'],
    details :
         Details.fromJson(json['details']) );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;

      data['details'] = details.toJson();

    return data;
  }
}

class Details {
  String? sId;
  String? qualifications;
  num? experience;
  String? specialty;
  List<String>? clientTypes;
  List<String>? issuesTreated;
  List<String>? treatmentApproaches;
  num? cost;
  List<Availability>? availability;
  String? gender;

  Details(
      {this.sId,
      this.qualifications,
      this.experience,
      this.specialty,
      this.clientTypes,
      this.issuesTreated,
      this.treatmentApproaches,
      this.cost,
      this.availability,
      this.gender});

  Details.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    qualifications = json['qualifications'];
    experience = json['experience'];
    specialty = json['specialty'];
    clientTypes = json['clientTypes'].cast<String>();
    issuesTreated = json['issuesTreated'].cast<String>();
    treatmentApproaches = json['treatmentApproaches'].cast<String>();
    cost = json['cost'];
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(new Availability.fromJson(v));
      });
    }
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['qualifications'] = this.qualifications;
    data['experience'] = this.experience;
    data['specialty'] = this.specialty;
    data['clientTypes'] = this.clientTypes;
    data['issuesTreated'] = this.issuesTreated;
    data['treatmentApproaches'] = this.treatmentApproaches;
    data['cost'] = this.cost;
    if (this.availability != null) {
      data['availability'] = this.availability!.map((v) => v.toJson()).toList();
    }
    data['gender'] = this.gender;
    return data;
  }
}






class SearchFilters {
  final String? name;
  final List<String>? specialties;
  final num? cost;
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
