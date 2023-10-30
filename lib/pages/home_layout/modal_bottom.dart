import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/network_layer/firestore_utilities.dart';
import 'package:todo/model/task_model.dart';

import '../../core/provider/app_provider.dart';
import '../../core/widgets/text_form.dart';

class ModalBottom extends StatefulWidget {
  const ModalBottom({super.key});

  @override
  State<ModalBottom> createState() => _ModalBottomState();
}

class _ModalBottomState extends State<ModalBottom> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedDateTime = TimeOfDay.now();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  static var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add new task",
                textAlign: TextAlign.center,
                style:
                    theme.textTheme.bodyLarge!.copyWith(color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white)),
            const SizedBox(
              height: 20,
            ),
            TextForm(style: TextStyle(color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a title";
                  } else {
                    return null;
                  }
                },
                hint: "Task title",
                textController: title),
            const SizedBox(
              height: 20,
            ),
            TextForm(style: TextStyle(color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a description";
                  } else {
                    return null;
                  }
                },
                maxLines: 3,
                hint: "Task description",
                textController: description),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select date",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => showDate(context),
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(selectedDate).toString(),
                    style: theme.textTheme.bodySmall!
                        .copyWith(color:(appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select time",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => showTime(),
                  child: Text(
                    "${selectedDateTime.hour.toString()}:${selectedDateTime.minute.toString()}",
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    var task = TaskModel(
                        title: title.text,
                        description: description.text,
                        isDone: false,
                        dateTime: selectedDate,
                        timeOfDay: selectedDateTime);
                    FireStoreUtilities.addData(task);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Add task"))
          ],
        ),
      ),
    );
  }

  void showDate(BuildContext context) async {
    var dateSelected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (dateSelected == null) return;
    setState(() {
      selectedDate = dateSelected;
    });
  }

  void showTime() async {
    var timeSelected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeSelected != null) {
      selectedDateTime =
          TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

      setState(() {
        selectedDateTime = timeSelected;
      });
    }
  }
}
