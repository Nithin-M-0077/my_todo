import 'package:flutter/material.dart';
import 'package:my_todo/db_handler.dart';
import 'package:my_todo/home_screen.dart';
import 'package:my_todo/model.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  bool? update;

  AddUpdateTask(
      {Key? key, this.todoId, this.todoTitle, this.todoDesc, this.update})
      : super(key: key);

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);

    String appTitle;

    if (widget.update == true) {
      appTitle = 'Update Task';
    } else {
      appTitle = "Add Task";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        toolbarHeight: 150,
        centerTitle: true,
        title: Text(
          appTitle,
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 1
          ),
        ),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style:const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: 1
                        ),
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        decoration: InputDecoration(
                          hintStyle:  TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.grey.withOpacity(0.4),
                              letterSpacing: 0.30

                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0,),),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.green), // Set focused border color here
                          ),
                          hintText: "Title",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter title of your task";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 55,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing: 1
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: descController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.grey.withOpacity(0.4),
                              letterSpacing: 0.30
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), // Set border radius here
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.green), // Set focused border color here
                          ),
                          hintText: "Description",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter description about your task";
                          }
                          return null;
                        },
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          if (widget.update == true) {
                            dbHelper!.update(
                              TodoModel(
                                  id: widget.todoId,
                                  title: titleController.text,
                                  desc: descController.text),
                            );
                          } else {
                            dbHelper!.insert(
                              TodoModel(
                                  title: titleController.text,
                                  desc: descController.text),
                            );
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                          titleController.clear;
                          descController.clear();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        width: 80,
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          titleController.clear();
                          descController.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        width: 80,
                        child: const Text(
                          "Clear All",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }
}
