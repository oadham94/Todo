import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/login/login_view.dart';
import '../../core/provider/app_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Image.asset(
        height: size.height,(appProvider.curTheme==ThemeMode.light)?
        "assets/images/splash_screen.png":"assets/images/splash_screen_dark.png",
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
