import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:to_do_task_getx/model/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  void openBox() async {
    var box = await Hive.openBox<Task>('todoTasks');
    taskList.addAll(box.values);
  }

  void addTask(Task task) async {
    var box = Hive.box<Task>('todoTasks');
    await box.add(task);
    taskList.add(task);
  }

  void deleteTask(int index) {
    var box = Hive.box<Task>('todoTasks');
    box.deleteAt(index);
    taskList.removeAt(index);
  }

  void editTask(int index, Task newTask) {
    var box = Hive.box<Task>('todoTasks');
    box.putAt(index, newTask);
    taskList[index] = newTask;
  }

  void toggleTaskCompletion(int index) {
    taskList[index].isCompleted = !taskList[index].isCompleted;
    taskList.refresh();
  }
}
