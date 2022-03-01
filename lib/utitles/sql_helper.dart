import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:student_app/models/studentmodel.dart';

class sql_helper {
  static sql_helper dbHelper;
  static Database _dataBase;

  sql_helper._createInstance();

  factory sql_helper() {
    if (dbHelper == null) {
      dbHelper = sql_helper._createInstance();
    }
    return dbHelper;
  }

  String tablename = "Students";
  String _id = 'id';
  String _name = 'name';
  String _describion = 'describion';
  String _pass = 'pass';
  String _date = 'date';

  Future<Database> get dataBase async {
    if (_dataBase == null) {
      _dataBase = await intializedDatabase();
    }
    return _dataBase;
  }


  Future<Database> intializedDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "studentmodel.db";
    var studentdb = await openDatabase(path, version: 1, onCreate: createDatabase);
    return studentdb;
  }


  void createDatabase(Database db, int version) {
    db.execute("CREATE TABLE $tablename ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT,$_describion TEXT, $_pass INTEGER , $_date TEXT)");
  }


    Future<List<Map<String, dynamic>>> getStudentMapList() async {
    Database db = await this.dataBase;
    //var result1 = await db.rawQuery("SELECT * FROM $tablename ORDER BY $_id ASC");
    var result = await db.query(tablename, orderBy: "$_id ASC");
    return result;
  }

  Future<int> insertStudent(studentmodel student) async {
    Database db = await this.dataBase;
    var result = await db.insert(tablename, student.toMap());
    return result;
  }

  Future<int> updateStudent(studentmodel student) async {
    Database db = await this.dataBase;
    var result = await db.update(tablename, student.toMap(), where: "$_id = ?", whereArgs: [student.id]);
    return result;
  }

  Future<int> updateSStudent(String name,String desc,int pass,int id) async {
    Database db = await this.dataBase;
    var result = await db.rawUpdate("UPDATE $tablename SET $_name = ?,$_describion = ?,$_pass = ? WHERE $_id = ?",[name,desc,pass,id]);
    return result;
  }


  Future<int> deleteStudent(int id) async {
    Database db = await this.dataBase;
    var result = await db.rawDelete("DELETE FROM $tablename WHERE $_id = $id");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.dataBase;
    List<Map<String, dynamic>> all = await db.rawQuery( "SELECT COUNT (*) FROM $tablename");
    int result = Sqflite.firstIntValue(all);
    return result;
  }

  Future<List<studentmodel>> getStudentList() async {
    var studentMapList = await getStudentMapList();
    int count = studentMapList.length;
    List<studentmodel> students = new List<studentmodel>();
    for (int i = 0; i <  count; i++) {
      students.add(studentmodel.getMap(studentMapList[i]));
    }
    return students;
  }

}
