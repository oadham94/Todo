import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/app_theme.dart';
import 'package:todo/pages/home_layout/home_layout.dart';
import 'package:todo/pages/login/login_view.dart';
import 'package:todo/pages/register/register_view.dart';
import 'package:todo/pages/splash_screen/splash_screen.dart';
import 'package:todo/pages/task_view/widgets/edit_task_screen.dart';
import 'core/provider/app_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  var appProvider= AppProvider();
  await appProvider.loadData();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    EasyLocalization(
        saveLocale: true,
        useFallbackTranslations: true,
        assetLoader: const JsonAssetLoader(),
        useOnlyLangCode: true,
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child:ChangeNotifierProvider(create: (context) =>  appProvider, child: const TodoApp()),
  ));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    return MaterialApp(
      builder: EasyLoading.init(),
      themeMode: appProvider.curTheme,
      theme: AppTheme().lightTheme,
      darkTheme: AppTheme().darkTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        HomeLayout.routeName: (context) => const HomeLayout(),
        LoginView.routeName: (context) => const LoginView(),
        RegisterView.routeName: (context) => const RegisterView(),
        EditTask.routeName: (context) => const EditTask(),
      },
    );
  }
}