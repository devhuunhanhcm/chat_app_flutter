import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/utils/loading/loading_dialog.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/toast/toast.dart';
import 'package:chat_app_flutter/utils/validator/MyFormValidator.dart';
import 'package:chat_app_flutter/widget/form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final MyFormValidator formValidator = MyFormValidator();

  final formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Sign up"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Form(
              key: formKey,
              child: Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                    child: FormFieldWidget(
                      controller: _username,
                      preIcon: const Icon(Icons.account_circle_outlined),
                      labelText: "Username",
                      validator: (value) => formValidator.checkUsername(value),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                    child: FormFieldWidget(
                      controller: _fullName,
                      preIcon: const Icon(Icons.account_circle_outlined),
                      labelText: "Full Name",
                      validator: (value) => formValidator.checkUsername(value),
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FormFieldWidget(
                      controller: _email,
                      preIcon: const Icon(Icons.email_outlined),
                      labelText: "Email",
                      validator: (value) => formValidator.checkEmail(value),
                      isPasswordField: false,
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FormFieldWidget(
                      controller: _phone,
                      preIcon: const Icon(Icons.phone_outlined),
                      labelText: "Phone",
                      validator: (value) =>
                          formValidator.checkPhoneNumber(value),
                      isPasswordField: false,
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FormFieldWidget(
                      controller: _password,
                      preIcon: const Icon(Icons.lock_clock_outlined),
                      labelText: "Password",
                      validator: (value) => formValidator.checkPassword(value),
                      isPasswordField: true,
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: FormFieldWidget(
                      controller: _repassword,
                      preIcon: const Icon(Icons.lock_clock_outlined),
                      labelText: "Confirm password",
                      validator: (value) =>
                          formValidator.checkConfirmPass(value, _password),
                      isPasswordField: true,
                    )),
                SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      child: const Text(
                        "Sign up now",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: const Text(
                            "Login now.",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ));
  }

  void onSubmit() {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      signUp();
    }
  }

  Future signUp() async {
    String username = _username.text.trim();
    String password = _password.text.trim();
    String email = _email.text.trim();
    String phone = _phone.text.trim();
    String fullName = _fullName.text;

    Loading.showLoading(context);

    User? user =
        await _auth.signUp(username, fullName, email, password, phone, context);
    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _repassword.dispose();
    _phone.dispose();
    super.dispose();
  }
}
