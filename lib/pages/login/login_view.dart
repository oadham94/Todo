import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/widgets/text_form.dart';
import 'package:todo/pages/home_layout/home_layout.dart';
import 'package:todo/pages/register/register_view.dart';

import '../../core/provider/app_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String routeName = "login";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<AppProvider>(context);

    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.background,
          image: const DecorationImage(
              image: AssetImage("assets/images/login_pattern.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 120,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Login",
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.white)),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.16,
                    ),
                    Text("Welcome back!",
                        style: theme.textTheme.bodyLarge!.copyWith(
                            color: (appProvider.curTheme == ThemeMode.light)
                                ? Colors.black
                                : Colors.white,
                            fontSize: 22)),
                    const SizedBox(height: 20),
                    TextForm(
                      style: TextStyle(
                          color: (appProvider.curTheme == ThemeMode.dark)
                              ? Colors.white
                              : Colors.black),
                      labelText: "Email",
                      textController: email,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        var emailReg = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (!emailReg.hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextForm(
                      icon: GestureDetector(
                        onTap: () {
                          isVisible = !isVisible;
                          setState(() {});
                        },
                        child: isVisible == true
                            ? const Icon(Icons.visibility_rounded)
                            : const Icon(Icons.visibility_off_rounded),
                      ),
                      obscure: isVisible,
                      style: TextStyle(
                          color: (appProvider.curTheme == ThemeMode.dark)
                              ? Colors.white
                              : Colors.black),
                      labelText: "Password",
                      textController: password,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text("Forgot password?",
                        style: theme.textTheme.bodySmall!.copyWith(
                            color: (appProvider.curTheme == ThemeMode.light)
                                ? Colors.black
                                : Colors.white)),
                    const SizedBox(height: 20),
                    MaterialButton(
                        color: theme.primaryColor,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          login(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Login",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: Colors.white)),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            )
                          ],
                        )),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterView.routeName);
                      },
                      child: Text("Or Create My Account",
                          style: theme.textTheme.bodySmall!.copyWith(
                              color: (appProvider.curTheme == ThemeMode.light)
                                  ? Colors.black
                                  : Colors.white)),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  login(context) async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        EasyLoading.dismiss();
        EasyLoading.showSuccess("You have successfully logged in.");
        Navigator.pushNamedAndRemoveUntil(
            context, HomeLayout.routeName, (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          EasyLoading.dismiss();
          EasyLoading.showError('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          EasyLoading.dismiss();
          EasyLoading.showError('Wrong password provided for that user.');
        }
      }
    }
  }
}
