import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/network_layer/firestore_utilities.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/pages/task_view/widgets/edit_task_screen.dart';

import '../../../core/provider/app_provider.dart';

class TaskWidgets extends StatelessWidget {
  final TaskModel task;

  const TaskWidgets({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<AppProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Slidable(
        direction: Axis.horizontal,
        startActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                padding: EdgeInsets.zero,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(15)),
                onPressed: (context) {
                  FireStoreUtilities.deleteData(task);
                },
                backgroundColor: const Color(0xffEC4B4B),
                icon: Icons.delete_rounded,
                foregroundColor: Colors.white,
                label: "Delete",
              ),
            ]),
        endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(15)),
                padding: EdgeInsets.zero,
                onPressed: (context) {
                  Navigator.of(context)
                      .pushNamed(EditTask.routeName, arguments: task);
                },
                backgroundColor: const Color(0xff195cb7),
                foregroundColor: Colors.white,
                icon: Icons.edit_rounded,
                label: "Edit",
              ),
            ]),
        child: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color:  (appProvider.curTheme==ThemeMode.dark)?Colors.black.withOpacity(0.9):Colors.white,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: task.isDone
                          ? const Color(0xff61E757)
                          : theme.primaryColor,
                    ),
                    height: 60,
                    width: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: task.isDone
                          ? theme.textTheme.bodyLarge!
                              .copyWith(color: const Color(0xff61E757))
                          : theme.textTheme.bodyLarge,
                    ),
                    Text(
                      task.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                         Icon(Icons.alarm_rounded,color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
                        const SizedBox(width: 10),
                        Text(
                            "${task.timeOfDay.hour.toString()}:${task.timeOfDay.minute.toString()}"),
                        const SizedBox(width: 105),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    task.isDone = !task.isDone;
                    FireStoreUtilities.clickOnDone(task);
                  },
                  child: Container(
                    decoration: task.isDone
                        ? const BoxDecoration()
                        : BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle),
                    width: 70,
                    height: 35,
                    child: task.isDone
                        ? Text("Done!",
                            style: theme.textTheme.bodyLarge!
                                .copyWith(color: const Color(0xff61E757)))
                        : const Icon(Icons.check_rounded,
                            size: 30, color: Colors.white),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
