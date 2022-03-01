import 'package:flutter/material.dart';
import 'students.dart';
import 'dart:async';
import 'package:student_app/models/studentmodel.dart';
import 'package:student_app/students.dart';
import 'utitles/sql_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/rendering.dart';
import 'package:student_app/utitles/sql_helper.dart';
import 'students_2.dart';

class StudentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentList();
  }
}

class _StudentList extends State<StudentList> {
  sql_helper helper = new sql_helper();
  List<studentmodel> studentList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (studentList == null) {
      studentList = new List<studentmodel>();
    }
    UpdateListView();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Students"),
      ),
      body: getStudentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextPage(studentmodel('','',1,''));
          UpdateListView();
        },
        tooltip: "Add Student",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getStudentList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context,int p) {
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isPassed(this.studentList[p].pass),
                  child: getIcon(this.studentList[p].pass),
                ),
                title: Text(this.studentList[p].name),
                subtitle: Text(this.studentList[p].describion + " | " +
                    this.studentList[p].date),
                trailing:
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.grey),
                  onTap: () {
                    _delete(context, this.studentList[p]);
                    UpdateListView();
                  },
                ),
            onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return StudentDetail2(studentmodel.newConst(this.studentList[p].id,this.studentList[p].name, this.studentList[p].describion,
                      this.studentList[p].pass,this.studentList[p].date)
                  );
                    }
                  )
                  );}
                  ),
          );
        });
  }

  Color isPassed(int value) {
    switch (value) {
      case 1:
        return Colors.amber;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.amber;
    }
  }

  Icon getIcon(int value) {
    switch (value) {
      case 1:
        return Icon(Icons.check);
        break;
      case 2:
        return Icon(Icons.close);
        break;
      default:
        return Icon(Icons.check);
    }
  }

  void _delete(BuildContext context, studentmodel student) async {
    int result = await helper.deleteStudent(student.id);
    if (result != 0) {
      _showSencBar(context, "Has Been Deleted!");
    }
  }

  void UpdateListView() {
    final Future<Database> db = helper.intializedDatabase();
    db.then((database) {
      Future<List<studentmodel>> students = helper.getStudentList();
      students.then((theList) {
        setState(() {
          this.studentList = theList;
          this.count = theList.length;
        });
      });
    });
  }


  void _showSencBar(BuildContext context, String mag) {
    final sencBar = SnackBar(content: Text(mag),);
    Scaffold.of(context).showSnackBar(sencBar);
  }

  void nextPage(studentmodel student) {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StudentDetail(student);
      }));
    });
  }
}
