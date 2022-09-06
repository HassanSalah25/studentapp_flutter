import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:student_app/models/studentmodel.dart';
import 'package:student_app/student_list.dart';
import 'package:student_app/utitles/sql_helper.dart';

class StudentDetail extends StatefulWidget {
  studentmodel student;

  StudentDetail(this.student);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentDetail(this.student);
  }
}

class _StudentDetail extends State<StudentDetail> {
  studentmodel student;

  _StudentDetail(this.student);

  sql_helper helper = new sql_helper();
  static var _status = ["successed", "faild"];
  TextEditingController studentName = new TextEditingController();
  TextEditingController studentDetail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle ts = Theme.of(context).textTheme.title;
    studentName.text = student.name;
    studentDetail.text = student.describion;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Student"),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _status.map((String dropDownItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownItem,
                      child: Text(dropDownItem),
                    );
                  }).toList(),
                  style: ts,
                  value: getPassing(student.pass),
                  onChanged: (selectedItem) {
                    setState(() {
                      setPassing(selectedItem);
                    });
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                      controller: studentName,
                      style: ts,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: ts,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      onChanged: (value) {
                        student.name = value;
                      })),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: studentDetail,
                  style: ts,
                  onChanged: (value) {
                    student.describion = value;
                  },
                  decoration: InputDecoration(
                      labelText: "Descrption",
                      labelStyle: ts,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                              "Save",
                              textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        save();
                      },
                    )),
                    Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Delete",
                            textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState() {
                          _delete();
                        }
                      },
                    ))
                  ],
                ),
              )
            ]
            )
        )
    );
  }

  void setPassing(String value) {
    switch (value) {
      case "successed":
        student.pass = 1;
        break;
      case "faild":
        student.pass = 2;
        break;
    }

  }

  String getPassing(int value) {
    String pass;
    switch (value) {
      case 1:
        pass = _status[0];
        break;
      case 2:
        pass = _status[1];
        break;
    }
    return pass;
  }

  void save() async {
    goBack();
    student.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (student.id == null) {
      result = await helper.insertStudent(student);
    } else {
      result = await helper.updateStudent(student);
    }
    if (result == 0) {
      showAlertDialog("Sorry", "Student not Saved");
    } else {
      showAlertDialog("Congratulation", "student has been saved");
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(msg));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    if (student.id == null) {
      showAlertDialog("Ok Delete", "No Student was deleted");
      return;
    }
    int result = await helper.deleteStudent(student.id);
    if (result == 0) {
      showAlertDialog("Ok Delete", "No Student was deleted");
    } else {
      showAlertDialog("Ok Delete", "Student has been deleted");
    }
  }

  void goBack() {
    Navigator.pop(context, MaterialPageRoute(builder: (context) {
      return StudentList();
    }));
  }
}
