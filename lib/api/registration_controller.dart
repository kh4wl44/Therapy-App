import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:lati_project/api/api_service.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    _logger.i('Retrieved token: ${token.isNotEmpty ? token : "No token found"}');
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
}

