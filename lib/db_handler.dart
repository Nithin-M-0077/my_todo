import 'dart:io' as io;

import 'package:my_todo/model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    // Check if the table does not exist before creating it
    await db.execute("CREATE TABLE IF NOT EXISTS mytodo("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title TEXT NOT NULL, "
        "desc TEXT NOT NULL)");
  }

  // inserting data
  Future<TodoModel> insert(TodoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert("mytodo", todoModel.toMap());
    return todoModel;
  }

  Future<List<TodoModel>> getDataList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> QueryResult =
    await dbClient!.rawQuery("SELECT * FROM mytodo");
    return QueryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete("mytodo", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TodoModel todoModel) async {
    var dbClient = await db;
    return await dbClient!.update("mytodo", todoModel.toMap(),
        where: 'id = ?', whereArgs: [todoModel.id]);
  }
}
//
// class DBHelper {
//   static Database? _db;
//
//   Future<Database?> get db async {
//     if (_db != null) {
//       return _db;
//     }
//     _db = await initDatabase();
//     return null;
//   }
//
//   initDatabase() async {
//     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path, 'Todo.db');
//     var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
//     return db;
//   }
//
//   _createDatabase(Database db, int version) async {
//     //creating table in the database
//     await db.execute(
//       "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL)",
//     );
//   }
//
// // insering data
//
//   Future<TodoModel> insert(TodoModel todoModel) async {
//     var dbClient = await db;
//     await dbClient?.insert("mytodo", todoModel.toMap());
//     return todoModel;
//   }
//
//   Future<List<TodoModel>> getDataList() async {
//     await db;
//     final List<Map<String, Object?>> QueryResult =
//         await _db!.rawQuery("SELECT * FROM mytodo");
//     return QueryResult.map((e) => TodoModel.fromMap(e)).toList();
//   }
//
//   Future<int> delete(int id) async {
//     var dbClient = await db;
//     return await dbClient!.delete("mytodo", where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future<int> update(TodoModel todoModel) async {
//     var dbClient = await db;
//     return await dbClient!.update("mytodo", todoModel.toMap(),
//         where: 'id = ?', whereArgs: [todoModel.id]);
//   }
// }