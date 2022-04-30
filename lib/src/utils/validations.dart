class Validation {
  static String? blankValidation(String? value) {
    if (value != null) {
      value = value.trim();
    }
    
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  static String? usernameValidation(String? value) {
    if (value != null) {
      value = value.trim();
    }

    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    } else if (value.length < 6) {
      return 'Username must have at least 6 characters';
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value != null) {
      value = value.trim();
    }

    final regexp = RegExp(r'^([A-Za-z]+[0-9|]|[0-9]+[A-Za-z])[A-Za-z0-9]*$');

    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    } else if (value.length < 6 || !regexp.hasMatch(value)) {
      return 'Password must have at least 6 characters which contains at least 1 number and 1 character';
    }
    return null;
  }

  static String? phoneValidation(String? value) {
    if (value != null) {
      value = value.trim();
      final regexp = RegExp(r"^\d{10}$");

    if (value.isNotEmpty && regexp.hasMatch(value)) {
      return 'Phone number must have 10 digits';
    }
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (value != null) {
      value = value.trim();
    }
    
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }
}
