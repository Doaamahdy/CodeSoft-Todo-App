import 'package:get/get.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/db/db.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  @override
  void onReady() {
    super.onReady();
  }

  Future<int>? saveTask({required Task task}) async {
    int val = await DBHelper.insert(task);
    await getTasks();
    return val;
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)));
  }

  Future<void> deleteTask(Task task) async {
    await DBHelper.delete(task);
    await getTasks();
  }

  Future<void> makeTaskCompleted(int id) async {
    await DBHelper.update(id);
    await getTasks();
  }

  Future<void> updateTask({required Task task}) async {
    print("Here you are in the updattttttttt");
    await DBHelper.updateTask(task);
    await getTasks();
  }
}
