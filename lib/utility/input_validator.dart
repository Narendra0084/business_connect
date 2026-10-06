class InputValidator {
  static String? validateRequired(String? value, {required String fieldLabel, int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldLabel is required';
    }

    if (value.trim().length < minLength) {
      return '$fieldLabel must be at least $minLength characters';
    }

    return null;
  }
}
