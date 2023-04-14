///Contains random functions used around the app
class UtilFunctions {
  static final _emailRegExPattern = RegExp('[a-z0-9]+@[a-z]+.[a-z]{2,3}');

  ///ensures the text is an email
  static String? validateEmail(String email) {
    if (_emailRegExPattern.hasMatch(email)) {
      return null;
    }
    return 'Please enter an email address';
  }

  ///ensures the password length is up to 7
  static String? checkPasswordLength(String v) {
    if (v.length < 7) {
      return 'Password is too short';
    }
    return null;
  }

  ///ensures that password and confirm password are the same
  static String? confirmPasswordsAreTheSame({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword != password) {
      return 'Please confirm both passwords are the same';
    }
    return null;
  }
}
