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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(
          "TO-DO",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
              letterSpacing: 1),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.length == 0) {
                return Center(
                  child: Text(
                    "No Task Found.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                      background: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          dbHelper!.delete(todoId);
                          dataList = dbHelper!.getDataList();
                          snapshot.data!.remove(snapshot.data![index]);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(10),
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  todoTitle,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              subtitle: Text(
                                todoDesc,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Divider(
                              height: 5,
                              color: Colors.black,
                              thickness: 0.2,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 7),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
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
                                  child: Icon(
                                    Icons.edit_note,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.indigo,
          size: 30,
        ),
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
