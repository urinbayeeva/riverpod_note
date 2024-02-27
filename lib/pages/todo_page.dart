// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_todo/services/net_service.dart';

import '../models/todo_model.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descController = TextEditingController();
late ToDo todo;

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late List<ToDo> productList;

  Future<void> getAllToDo() async {
    String result =
        await NetworkService.getData(NetworkService.apiGetAllProducts);
    productList = toDoFromJson(result);
    setState(() {});
  }

  @override
  void initState() {
    getAllToDo();
    super.initState();
  }

  Future<void> deleteToDo(int index) async {
    String? result =
        await NetworkService.deleteData(NetworkService.apiDeleteProduct, index);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$index ID to do was deleted!")));
      await getAllToDo();
      setState(() {});
    } else {
      log("Null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text("To Do with RiverPod"),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          var item = productList[index];
          return SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Note Details"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID: ${item.id}"),
                            Text("Title: ${item.title}"),
                            Text("Description: ${item.description}"),
                          ],
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(CupertinoIcons.delete),
                            onPressed: () async {
                              await deleteToDo(int.parse(item.id));
                              Navigator.of(context).pop();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Text("ID: ${item.id}"),
                    title: Text(
                      "Title: ${item.title}",
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.clip,
                    ),
                    subtitle: Text(
                      "Description: ${item.description}",
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: productList.length,
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.teal.shade200,
        backgroundColor: Colors.teal,
        hoverColor: Colors.teal.shade100,
        foregroundColor: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(hintText: "Title"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: descController,
                        decoration:
                            const InputDecoration(hintText: "Description"),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    TextButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            descController.text.isNotEmpty) {
                          Navigator.pop(context);
                          ToDo(
                              title: titleController.text,
                              description: descController.text,
                              id: "id");
                          await NetworkService.postData(
                              NetworkService.apiGetAllProducts, todo.toJson());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all gaps"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        await getAllToDo();
                        setState(() {});
                      },
                      child: const Text("Save"),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
