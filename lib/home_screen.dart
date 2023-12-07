import 'package:flutter/material.dart';
import 'package:my_todo/add_update_screen.dart';
import 'package:my_todo/db_handler.dart';
import 'package:my_todo/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          "TO-DO",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 40, color: Colors.white,
              letterSpacing: 1
          ),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.teal,),
                    );
                  } else if (snapshot.data!.length == 0) {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "No Tasks.",
                        style: TextStyle(
                          letterSpacing: 0.5,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        int todoId = snapshot.data![index].id!.toInt();
                        String todoTitle = snapshot.data![index].title.toString();
                        String todoDesc = snapshot.data![index].desc.toString();
                        return Dismissible(
                          key: ValueKey<int>(todoId),
                          direction: DismissDirection.endToStart,
                          background: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 35,
                          ),
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              dbHelper!.delete(todoId);
                              dataList = dbHelper!.getDataList();
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.withOpacity(0.1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 0.7,
                                  spreadRadius: 0.7,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(20),
                                  title: Text(
                                    todoTitle,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                    todoDesc,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddUpdateTask(
                                            todoId: todoId,
                                            todoTitle: todoTitle,
                                            todoDesc: todoDesc,
                                            update: true,
                                          ),
                                        ),
                                      );

                                    },
                                    child: const Icon(
                                      Icons.edit_note,
                                      color: Colors.green,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white, size: 30,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUpdateTask(),
            ),
          );
        },
      ),
    );
  }
}
