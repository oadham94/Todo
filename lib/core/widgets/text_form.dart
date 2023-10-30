import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_provider.dart';

class TextForm extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final String? hint;
  final TextEditingController textController;
  final int maxLines;
  final String? labelText;
  final bool obscure;
  final Widget? icon;
  final TextStyle? style;

  const TextForm({
    super.key,
    this.validator,
    this.hint,
    required this.textController,
    this.maxLines = 1,
    this.labelText,
    this.obscure = false,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        obscureText: obscure,
        style:
            style ?? theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
        controller: textController,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelStyle: style ?? const TextStyle(color: Colors.black),
            border: OutlineInputBorder(borderRadius:BorderRadius.circular(15),),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white)),
            suffixIcon: icon,suffixIconColor:(appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white,
            labelText: labelText,
            hintText: hint,
            hintStyle:style??
                theme.textTheme.bodyMedium!.copyWith(color: Colors.black)),
        validator: validator,
      ),
    );
  }
}
