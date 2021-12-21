class Validation {
  static String? loginValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  static String? usernameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    } else if (value.length < 6) {
      return 'Username must have at least 6 characters';
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    } else if (value.length < 6) {
      return 'Password must have at least 6 characters';
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  static String? codeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }
}
