import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../core/widgets/text_form.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  static const String routeName = "register";

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
 static var formKey = GlobalKey<FormState>();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.background,
          image: const DecorationImage(
              image: AssetImage("assets/images/login_pattern.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 120,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Create Account",
              style: theme.textTheme.titleLarge!.copyWith(color: Colors.white)),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.16,
                    ),
                    const SizedBox(height: 20),
                    TextForm(style:theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                      labelText: "Full Name",
                      textController: name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your Full Name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextForm(style:theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
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
                    TextForm(style:theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                      obscure: isPasswordVisible,
                      icon: GestureDetector(
                          onTap: () {
                            isPasswordVisible = !isPasswordVisible;
                            setState(() {});
                          },
                          child: isPasswordVisible == true
                              ? const Icon(Icons.visibility_rounded)
                              : const Icon(Icons.visibility_off_rounded)),
                      labelText: "Password",
                      textController: password,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a password";
                        }
                        var passwordReg =
                            RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

                        if (!passwordReg.hasMatch(value)) {
                          return "Please enter a valid password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextForm(style:theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                      obscure: isConfirmPasswordVisible,
                      icon: GestureDetector(
                          onTap: () {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                            setState(() {});
                          },
                          child: isConfirmPasswordVisible == true
                              ? const Icon(Icons.visibility_rounded)
                              : const Icon(Icons.visibility_off_rounded)),
                      labelText: "Confirm Password",
                      textController: confirmPassword,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != password.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                        color: theme.primaryColor,
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          register(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Create account",
                                style: theme.textTheme.bodyMedium!
                                    .copyWith(color: Colors.white)),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  register(context) async {
    if (formKey.currentState!.validate()) {
      EasyLoading.show();

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Your account has been created successfully");
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          EasyLoading.dismiss();
          EasyLoading.showError("The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          EasyLoading.dismiss();
          EasyLoading.showError("The account already exists for that email.",
              duration: const Duration(seconds: 3));
          return 'The account already exists for that email.';
        }
      } catch (e) {
        return e;
      }
    }
  }
}
