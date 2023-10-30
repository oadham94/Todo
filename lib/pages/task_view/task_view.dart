import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/network_layer/firestore_utilities.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/pages/task_view/widgets/task_widgets.dart';
import '../../core/provider/app_provider.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  DateTime dateSelected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);

    var theme = Theme.of(context);
    return Column(children: [
      Stack(
        alignment: const Alignment(0, 2.8),
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 45, bottom: 15),
            width: double.infinity,
            height: 187,
            color: theme.primaryColor,
            child: Text(
              "todolist".tr(),
              style: theme.textTheme.titleLarge,
            ),
          ),
          CalendarTimeline(
            locale: EasyLocalization.of(context)?.locale.toString(),
            initialDate: dateSelected,
            firstDate: DateTime.now().subtract(const Duration(days: 60)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (p0) {
              if (dateSelected != p0) {
                dateSelected = p0;
                setState(() {
                  dateSelected = p0;
                });
              }
            },
            monthColor: Colors.black,
            dayColor: appProvider.curTheme==ThemeMode.dark? Colors.white: Colors.black,
            activeDayColor: theme.primaryColor,
            activeBackgroundDayColor:appProvider.curTheme==ThemeMode.dark? Colors.black: Colors.white,
            dotsColor: theme.primaryColor,
          )
        ],
      ),
      const SizedBox(height: 37),
      Expanded(
        child: StreamBuilder<QuerySnapshot<TaskModel>>(
          stream: FireStoreUtilities.getDataRealTime(dateSelected),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.error.toString(),
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(
                      height: 40,
                    ),
                    const Icon(
                      Icons.refresh_rounded,
                      size: 30,
                    )
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: theme.primaryColor,
                    )
                  ]);
            }
            var taskList = snapshot.data!.docs.map((e) => e.data()).toList();
            return ListView.builder(
              padding: const EdgeInsets.only(top: 0, bottom: 80),
              itemBuilder: (context, index) =>
                  TaskWidgets(task: taskList[index]),
              itemCount: taskList.length,
            );
          },
        ),
      ),
    ]);
  }
}
