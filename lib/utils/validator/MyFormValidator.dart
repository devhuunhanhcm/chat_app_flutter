class MyFormValidator{
  dynamic checkPassword(value) {
    if (value.isEmpty) {
      return 'Password is empty.';
    }
    if (value != null && value.length < 6) {
      return "Enter min. 6 character.";
    }
    return null;
  }

  dynamic checkPhoneNumber(value) {
    if (value!.isEmpty) {
      return "Please Enter a Phone Number";
    } else if (!RegExp(
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(value)) {
      return "Please Enter a Valid Phone Number";
    }
    return null;
  }

  dynamic checkEmail(value) {
    if (value!.isEmpty) {
      return "Please Enter a Email";
    } else if (!RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return "Please Enter a Valid email";
    }
    return null;
  }

  dynamic checkUsername(username) {
    if (username.isEmpty) {
      return 'Empty';
    }
    if (username != null && username.length < 6) {
      return "Enter min. 6 character.";
    }
    return null;
  }

  dynamic checkConfirmPass(repassword,password) {
    if (repassword.isEmpty) {
      return 'Empty';
    }
    if (repassword != password.text) {
      return 'Not Match';
    }
    return null;
  }
}