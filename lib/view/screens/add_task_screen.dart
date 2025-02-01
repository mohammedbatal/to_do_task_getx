import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_task_getx/controller/task_controller.dart';
import 'package:to_do_task_getx/model/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddTaskScreen({super.key, this.task, this.index});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? SelectedDate;

  //!
  final TaskController taskController = Get.put(TaskController());
  //!

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      SelectedDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(widget.task != null ? 'Edit Task' : "Add New Task",
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Tile',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Task Title'),
            ),
            SizedBox(height: 20),
            Text(
              'Task Description',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Enter Task Description'),
            ),
            SizedBox(height: 20),
            Text(
              'Due Date',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextButton.icon(
              label: Text(SelectedDate == null
                  ? "Pick a Due Date"
                  : "${SelectedDate!.toLocal()}".split(' ')[0]),
              icon:
                  Icon(Icons.calendar_month_rounded, color: Colors.deepPurple),
              onPressed: () async {
                SelectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100),
                );
                setState(() {});
              },
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF493AD5),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(widget.task != null ? "Updata Task" : 'Add Task'),
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      SelectedDate == null) {
                    Get.snackbar('Error', 'Please fill in all fields',
                        backgroundColor: Colors.red, colorText: Colors.white);

                    return;
                  }
                  if (widget.task != null) {
                    var updatedTask = Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        dueDate: SelectedDate!,
                        isCompleted: widget.task!.isCompleted);
                    taskController.editTask(widget.index!, updatedTask);
                    Get.back();
                    Get.snackbar('Success', 'Task Updated Successfully',
                        backgroundColor: Colors.green, colorText: Colors.white);
                  } else {
                    var newTask = Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        dueDate: SelectedDate!);
                    taskController.addTask(newTask);
                    Get.back();
                    Get.snackbar('Success', 'Task Added Successfully',
                        backgroundColor: Colors.green, colorText: Colors.white);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
