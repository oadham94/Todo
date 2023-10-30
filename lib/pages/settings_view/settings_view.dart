import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/provider/app_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

const List<String> lang = ["English", "Arabic"];
const List<String> themeList = ["Light", "Dark"];

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    String? themeValue = (appProvider.curTheme==ThemeMode.light)? 'Light':'Dark';
    String? language = (context.locale ==const Locale('ar') )?"Arabic":"English";

    var theme = Theme.of(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 45, bottom: 15),
          width: double.infinity,
          height: 187,
          color: theme.primaryColor,
          child: Text(
            "settings".tr(),
            style: theme.textTheme.titleLarge,
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
              color: (appProvider.curTheme==ThemeMode.light)?Colors.white:const Color(0xff141922), borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(15),
              padding: const EdgeInsets.all(10),
              isExpanded: true,
              iconSize: 30,
              items: lang
                  .map((e) => DropdownMenuItem(
                        onTap: () {
                          context.setLocale(
                              Locale((e == 'English') ? 'en' : 'ar'));
                        },
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              value: language,
              autofocus: false,
              onChanged: (String? value) {
                setState(() {
                  language = value;
                });
              }),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
              color: (appProvider.curTheme==ThemeMode.light)?Colors.white:const Color(0xff141922), borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(15),
              padding: const EdgeInsets.all(10),
              isExpanded: true,
              iconSize: 30,
              items: themeList
                  .map((e) => DropdownMenuItem(
                onTap: () {
                  (e=='Light')?appProvider.changeTheme(ThemeMode.light):appProvider.changeTheme(ThemeMode.dark);
                },
                value: e,
                child: Text(e),
              ))
                  .toList(),
              value: themeValue,
              onChanged: (String? value) {
                setState(() {
                  themeValue = value;
                });
              }),
        ),

      ],
    );
  }
}
