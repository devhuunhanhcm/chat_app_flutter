import 'package:chat_app_flutter/config/routes/routes.dart';
import 'package:chat_app_flutter/firebase/auth_service.dart';
import 'package:chat_app_flutter/utils/style/app_colors.dart';
import 'package:chat_app_flutter/utils/loading/loading_dialog.dart';
import 'package:chat_app_flutter/utils/loading/message_dialog.dart';
import 'package:chat_app_flutter/utils/validator/MyFormValidator.dart';
import 'package:chat_app_flutter/widget/form_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final MyFormValidator formValidator = MyFormValidator();
  final FirebaseAuthService _authService = FirebaseAuthService();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: null,
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo-2.png',
                  width: 200,
                  height: 200,
                ),
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                            child: FormFieldWidget(
                              controller: _email,
                              preIcon:
                                  const Icon(Icons.account_circle_outlined),
                              labelText: "Email",
                              validator: (value) =>
                                  formValidator.checkEmail(value),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: FormFieldWidget(
                              controller: _password,
                              preIcon: const Icon(Icons.lock_clock_outlined),
                              labelText: "Password",
                              validator: (value) =>
                                  formValidator.checkPassword(value),
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
                                "Login now",
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("New user"),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AppRoutes.register);
                                        },
                                        child: const Text(
                                          "Register now.",
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                                const Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onSubmit() async {
    final String email = _email.text.trim();
    final String password = _password.text.trim();
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      Loading.showLoading(context);
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);

      Loading.hideLoading(context);
      if (user != null) {
        Navigator.pushNamed(context, AppRoutes.homePage);
      } else {
        MessageDialog.showMessage(
            context, "Email or password is correct.", "Login failed");
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
