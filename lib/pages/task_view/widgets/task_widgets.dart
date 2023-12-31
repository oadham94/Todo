import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/network_layer/firestore_utilities.dart';
import 'package:todo/model/task_model.dart';
import 'package:todo/pages/task_view/widgets/edit_task_screen.dart';
import '../../../core/provider/app_provider.dart';

class TaskWidgets extends StatefulWidget {
  final TaskModel task;

  const TaskWidgets({super.key, required this.task});

  @override
  State<TaskWidgets> createState() => _TaskWidgetsState();
}

class _TaskWidgetsState extends State<TaskWidgets> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<AppProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: appProvider.curTheme==ThemeMode.dark? const Color(0xff060E1E):const Color(0xffDFECDB),
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
                  FireStoreUtilities.deleteData(widget.task);
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
                      .pushNamed(EditTask.routeName, arguments: widget.task);
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
                      color: widget.task.isDone
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
                      widget.task.title,
                      style: widget.task.isDone
                          ? theme.textTheme.bodyLarge!
                              .copyWith(color: const Color(0xff61E757))
                          : theme.textTheme.bodyLarge,
                    ),
                    Text(
                      widget.task.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                         Icon(Icons.alarm_rounded,color: (appProvider.curTheme==ThemeMode.light)?Colors.black:Colors.white),
                        const SizedBox(width: 10),
                        Text(
                            "${widget.task.timeOfDay.hour.toString()}:${widget.task.timeOfDay.minute.toString()}"),
                        const SizedBox(width: 105),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    widget.task.isDone = !widget.task.isDone;
                    FireStoreUtilities.clickOnDone(widget.task);
                    setState(() {});
                  },
                  child: Container(
                    decoration: widget.task.isDone
                        ? const BoxDecoration()
                        : BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle),
                    width: 70,
                    height: 35,
                    child: widget.task.isDone
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
