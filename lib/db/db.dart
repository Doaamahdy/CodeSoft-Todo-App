import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'tasks.db';
        _db = await openDatabase(
          _path,
          version: _version,
          onCreate: (db, version) async {
            print("Creating New One");
            await db.execute(
              "CREATE TABLE $_tableName ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title STRING, description TEXT, date STRING,"
              "startTime STRING, endTime STRING, "
              "remind INTEGER, repeat STRING,"
              "color INTEGER,"
              "isCompleted INTEGER)",
            );
          },
        );
      } catch (err) {
        print(err);
      }
    }
  }

  static Future<int> insert(Task task) async {
    int index = await _db?.insert(_tableName, task.toJson()) ?? 1;
    List<Map<String, dynamic>>? list =
        await _db?.query(_tableName, where: "id=?", whereArgs: [index]);
    return index;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static Future<void> delete(Task task) async {
    await _db!.delete(_tableName, where: "id=?", whereArgs: [task.id]);
  }

  static Future<void> update(int id) async {
    await _db!.rawUpdate('''
    UPDATE tasks 
    SET isCompleted = ?
    WHERE ID = ?   
    ''', [1, id]);
  }

  static Future<void> updateTask(Task task) async {
    await _db!.update(
      _tableName,
      task.toJson(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }
}
