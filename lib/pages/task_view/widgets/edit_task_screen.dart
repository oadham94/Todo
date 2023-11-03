import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo/model/task_model.dart';

import '../../../core/network_layer/firestore_utilities.dart';
import '../../../core/widgets/text_form.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key});

  static const String routeName = "edit";

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedDateTime = TimeOfDay.now();
  late TextEditingController title;
  late TextEditingController description;
  static var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as TaskModel;
    title = TextEditingController(text: args.title);
    description = TextEditingController(text: args.description);
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.primaryColor,
          title: Text(
            "todolist".tr(),
          )),
      body: Stack(alignment: const Alignment(0, -1), children: [
        Container(
          padding: const EdgeInsets.only(left: 45, bottom: 15),
          width: double.infinity,
          height: 187,
          color: theme.primaryColor,
        ),
        Container(margin: const EdgeInsets.only(top: 50),
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Text(
                  "edit task",
                  style:
                      theme.textTheme.titleLarge!.copyWith(color: Colors.black),
                ),
                TextForm(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a title";
                      } else {
                        return null;
                      }
                    },
                    hint: "Task title",
                    textController: title),
                TextForm(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select date",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => showDate(context),
                      child: Text(
                        DateFormat.yMMMMEEEEd().format(selectedDate).toString(),
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select time",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => showTime(),
                      child: Text(
                        "${selectedDateTime.hour.toString()}:${selectedDateTime.minute.toString()}",
                        style: theme.textTheme.bodySmall!
                            .copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        var task = TaskModel(
                            id: args.id,
                            title: title.text,
                            description: description.text,
                            isDone: false,
                            dateTime: selectedDate,
                            timeOfDay: selectedDateTime);
                        FireStoreUtilities.updateData(task);
                        //FireStoreUtilities.deleteData(args);
                        //FireStoreUtilities.addData(task);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Save changes"))
              ]),
            ),
          ),
          // ))
        )
      ]),
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
