import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger _logger = Logger();

Future<void> saveUserInfo(String name, String email, bool isTherapist) async {
  try {
    final prefs = await SharedPreferences.getInstance();


    bool nameSaved = await prefs.setString('user_name', name);
    _logger.i('user_name saved: $nameSaved');

    bool emailSaved = await prefs.setString('user_email', email);
    _logger.i('user_email saved: $emailSaved');

    bool loggedInSaved = await prefs.setBool('is_logged_in', true);
    _logger.i('is_logged_in saved: $loggedInSaved');

    bool therapistSaved = await prefs.setBool('is_therapist', isTherapist);
    _logger.i('is_therapist saved: $therapistSaved');

    // Check if all saves were successful
    if (nameSaved && emailSaved && loggedInSaved && therapistSaved) {
      _logger.i('All user info saved successfully');
    } else {
      _logger.i('Some user info failed to save');
    }
  } catch (e) {
    _logger.i('Error saving user info: $e');
  }
}
