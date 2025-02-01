import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:to_do_task_getx/controller/task_controller.dart';
import 'package:to_do_task_getx/model/task_model.dart';
import 'package:to_do_task_getx/view/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("My Tasks",
                style: TextStyle(fontWeight: FontWeight.bold))),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Obx(() {
            return taskController.taskList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_rounded,
                          color: Colors.deepPurple,
                          size: 100,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No Task Yet!",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: taskController.taskList.length,
                    itemBuilder: (context, index) {
                      var task = taskController.taskList[index];
                      return Slidable(
                        key: ValueKey(index),
                        startActionPane: ActionPane(
                          motion: DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              borderRadius: BorderRadius.circular(15),
                              autoClose: true,
                              onPressed: (context) => Get.to(() =>
                                  AddTaskScreen(task: task, index: index)),
                              // onPressed: (v) {},
                              backgroundColor: Color(0xFF493AD5),
                              foregroundColor: Colors.white,

                              icon: Icons.edit,
                              label: "Edit",
                            )
                          ],
                        ),
                        endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(15),
                                autoClose: true,
                                onPressed: (context) =>
                                    taskController.deleteTask(index),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: "Delete",
                              )
                            ]),
                        child: taskCard(task, index),
                      ).animate().fade().slide(duration: 300.ms);
                    },
                  );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF493AD5),
          foregroundColor: Colors.white,
          onPressed: () {
            Get.to(() => AddTaskScreen());
          },
          child: Icon(Icons.add),
        ));
  }

  Widget taskCard(Task task, int index) {
    return Card(
      elevation: 10,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Icon(Icons.task_alt,
            color: task.isCompleted ? Colors.green : Colors.grey),
        title: Text(task.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              task.description,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null),
            ),
            Divider(),
            Text(
              '${task.dueDate.toLocal()}'.split(' ')[0],
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null),
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: () => taskController.toggleTaskCompletion(index),
            icon: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: task.isCompleted ? Colors.green : Colors.grey,
            )),
      ),
    );
  }
}
