mixin ValidationMixin {
  String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Mobile Number";
    }
    if (value.length > 10 || value.length < 10) {
      return "Please enter valid number";
    }
    return null;
  }

  String? otpValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter ";
    }
    if (value.length > 10 || value.length < 10) {
      return "Please enter valid number";
    }
    return null;
  }
}
