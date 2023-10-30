import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/home_layout/modal_bottom.dart';
import 'package:todo/pages/settings_view/settings_view.dart';
import 'package:todo/pages/task_view/task_view.dart';

import '../../core/provider/app_provider.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  static const String routeName = "home";

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  int selectedIndex = 0;
  List<Widget> screens = [
    const TaskView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.background,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomAppBar(color: (appProvider.curTheme==ThemeMode.light)?Colors.white:const Color(0xff141922),
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: selectedIndex,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/images/task_icon.png")),
                  label: ""),
              BottomNavigationBarItem(
                  icon:
                      ImageIcon(AssetImage("assets/images/settings_icon.png")),
                  label: "")
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModal(appProvider);
        },
        elevation: 0,
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, size: 25),
      ),
    );
  }

  void showModal(appProvider) {
    showModalBottomSheet(backgroundColor: (appProvider.curTheme==ThemeMode.light)?Colors.white:const Color(0xff141922),
        isScrollControlled: true,
        transitionAnimationController: AnimationController(
          reverseDuration: const Duration(milliseconds: 450),
          animationBehavior: AnimationBehavior.preserve,
          duration: const Duration(seconds: 1),
          vsync: this,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(25), right: Radius.circular(25))),
        context: context,
        builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const ModalBottom()));
  }
}
