mixin ValidationMixin {
  //validation for Mobile digit
  String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Mobile Number";
    }
    if (value.length > 10 || value.length < 10) {
      return "Please enter valid number";
    }
    return null;
  }

  String? ageValidation(String? value) {
    if (int.parse(value!) < 18) {
      return "Age must be greater than 18";
    }
    if (int.parse(value) > 100) {
      return "Not Valid Age";
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

  String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Email";
    }

    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Please enter valid Email ID";
    }
    return null;
  }

  String? firstNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter First name";
    }

    return null;
  }

  String? passwordValidation(String? value) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return "Enter Password";
    }

    if (!regExp.hasMatch(value)) {
      return "Password must be 8-16 characters long,\ninclude at least one uppercase letter,one lowercase letter,\none number,and one special character";
    }

    return null;
  }
}
