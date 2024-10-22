import 'package:get/get.dart';
import 'package:lati_project/features/auth/screens/Register/landingpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:lati_project/api/api_service.dart';
import 'dart:convert';
class RegistrationController extends GetxController {
  

  final Logger _logger = Logger();
   final RxString sessionType = ''.obs;
  final RxString gender = ''.obs;
  final RxString therapistPreference = ''.obs;
  final RxString languagePreference = ''.obs;
  final RxList<String> topics = <String>[].obs;

     late Function(Map<String, dynamic>) sendPreferencesCallback;


   Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    sessionType.value = prefs.getString('sessionType') ?? '';
    gender.value = prefs.getString('gender') ?? '';
    therapistPreference.value = prefs.getString('therapistPreference') ?? '';
    topics.value = prefs.getStringList('topics') ?? [];
    languagePreference.value = prefs.getString('languagePreference') ?? '';
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionType', sessionType.value);
    await prefs.setString('gender', gender.value);
    await prefs.setString('therapistPreference', therapistPreference.value);
    await prefs.setStringList('topics', topics);
    await prefs.setString('languagePreference', languagePreference.value);
  }


  void updateTherapistPreference(String preference) {
    therapistPreference.value = preference;
  }

  

  void updateSessionType(String type) {
    sessionType.value = type;
  }

  void updateGender(String selectedGender) {
    gender.value = selectedGender;
  }

  

  void updateLanguagePreference(String language) {
    languagePreference.value = language;
  }

  // Add other update methods as needed

  Future<void> sendClientPreferences() async {
    if (sessionType.isEmpty || gender.isEmpty || therapistPreference.isEmpty || topics.isEmpty || languagePreference.isEmpty) {
       Get.snackbar('Error', 'الرجاء إكمال جميع الحقول المطلوبة');
      return;
    }

    
    try {
       final userPreferences = UserPreferences(
        sessionType: sessionType.value,
        gender: gender.value,
        therapistPreference: therapistPreference.value,
          languagePreference: languagePreference.value,
         topics:topics,
        // ... other fields ...
      );
      
       _logger.i('User preferences created: ${userPreferences.toJson()}');
      
      final token = await getAuthToken();
       _logger.i('Token before sending preferences: $token');

         if (token.isEmpty) {
        Get.snackbar('Error', 'No authentication token found');
        return;
      }

    

       final preferencesMap = userPreferences.toJson();
    preferencesMap['token'] = token;
    

    _logger.i('Preferences map with token: $preferencesMap');

    final result = await sendPreferencesCallback(preferencesMap);

    _logger.i('Result from sendPreferencesCallback: $result');
      
       if (result['success']) {
        Get.snackbar('Success', 'تم تحديث التفضيلات بنجاح');
        // Clear preferences after successful submission
        await savePreferences();
        await setRegistrationComplete();
        // Navigate to the home screen or dashboard
        // Get.offAll(() => HomePage());
      } else {
        _logger.i('Error response: ${result['message']}');
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      _logger.i('Exception in sendClientPreferences: $e');
      Get.snackbar('Error', 'Failed to update preferences');
    }
  }
    Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionType');
    await prefs.remove('gender');
    await prefs.remove('therapistPreference');
    await prefs.remove('topics');
    await prefs.remove('languagePreference');
  
  

   sessionType.value = '';
    gender.value = '';
    therapistPreference.value = '';
    topics.clear();
    languagePreference.value = '';
  }

    Future<void> saveAuthToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
  _logger.i('Saved token: $token');

   final savedToken = prefs.getString('auth_token');
  _logger.i('Verified saved token: $savedToken');
}

  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token') ?? '';
    print('Retrieved token: ${token.isNotEmpty ? "Token present" : "No token"}');
    return token;
  }







  Future<bool> isRegistrationComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('registration_complete') ?? false;
  }

  Future<void> setRegistrationComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('registration_complete', true);
  }


  //--------------------------therapistdetails-------------------

   final Rx<TherapistDetails?> therapistDetails = Rx<TherapistDetails?>(null);

 Future<void> saveTherapistDetails(TherapistDetails details) async {
  final prefs = await SharedPreferences.getInstance();
  final detailsJson = json.encode(details.toJson());
  await prefs.setString('therapist_details', detailsJson);
  therapistDetails.value = details;
  _logger.i('Saved therapist details: $detailsJson');
}

  Future<void> loadTherapistDetails() async {
  final prefs = await SharedPreferences.getInstance();
  final detailsString = prefs.getString('therapist_details');
  if (detailsString != null) {
    try {
      final detailsMap = json.decode(detailsString) as Map<String, dynamic>;
      therapistDetails.value = TherapistDetails.fromJson(detailsMap);
      _logger.i('Loaded therapist details: ${therapistDetails.value?.toJson()}');
    } catch (e) {
      _logger.e('Error parsing therapist details: $e');
    }
  } else {
    _logger.i('No saved therapist details found');
  }
}

  Future<void> clearTherapistDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('therapist_details');
    therapistDetails.value = null;
    _logger.i('Cleared therapist details');
  }

  Future<void> logout() async {
    try {
      await _clearAllData();
      _logger.i('User logged out successfully');
      Get.snackbar('Success', 'Logged out successfully');
      // Navigate to login screen or initial screen
      // Get.offAll(() => LoginScreen());
    } catch (e) {
      _logger.e('Error during logout: $e');
      Get.snackbar('Error', 'Failed to log out. Please try again.');
    }
  }

  Future<void> _clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Clear all SharedPreferences data
    await prefs.clear();

    // Reset all observable variables
    sessionType.value = '';
    gender.value = '';
    therapistPreference.value = '';
    languagePreference.value = '';
    topics.clear();
    therapistDetails.value = null;

    // Clear auth token
    await prefs.remove('auth_token');

    // Clear registration status
    await prefs.remove('registration_complete');

    _logger.i('All user data cleared');

    Get.to(() => LandingPage());
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';
    if (userId.isEmpty) {
      _logger.e('User ID not found');
      throw Exception('User ID not found');
    }
    return userId;
  }


}
