import 'dart:developer';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_todo/models/todo_model.dart';

import 'net_service.dart';

class TodoProvider extends StateNotifier<List<ToDo>> {
  TodoProvider() : super([]);

  Future<void> getAllToDo() async {
    String result =
        await NetworkService.getData(NetworkService.apiGetAllProducts);
    state = toDoFromJson(result);
  }

  Future<void> deleteToDo(int index) async {
    String? result =
        await NetworkService.deleteData(NetworkService.apiDeleteProduct, index);
    if (result != null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("$index ID to do was deleted!")));
      await getAllToDo();
    } else {
      log("Null");
    }
  }
}
