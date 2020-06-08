class EmailFieldValidator {
  static String validate(String input) {
    if (input.isEmpty) {
      return 'Email can\'t be empty';
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

class PasswordFieldValidator {
  static String validate(String input) {
     if (input.isEmpty) {
       return 'Password can\'t be empty';
       }
     return null;
  }
}