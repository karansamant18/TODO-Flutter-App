import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todo_cubit/cubit/states.dart';
import 'package:todo_cubit/model/todo_model.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(InitialAppState());
  final formKey = GlobalKey<FormState>();

  void resetDate() {
    initialDate = DateTime.now();
  }

  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  setBottomIndex(int index) {
    currentIndex = index;
    emit(SetCurrentIndexAppState());
  }

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  var initialDate = DateTime.now();
  setDate(BuildContext context) {
    showDatePicker(
      context: context,
      currentDate: initialDate,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value != null) {
        initialDate = value;
      }
      emit(SetDateState());
    });
  }

  List<TodoModel>? todosList = [];
  List<int>? keys = [];
  Future<void> getBox() async {
    var box = await Hive.openBox<TodoModel>("todos");
    keys = box.keys.cast<int>().toList();
    todosList = [];
    for (var key in keys!) {
      todosList!.add(box.get(key)!);
    }
    box.close();
    emit(GetBoxState());
  }

  Future<void> addTodo(TodoModel todoModel) async {
    await Hive.openBox<TodoModel>("todos")
        .then((value) => value.add(todoModel));
    await getBox();
    emit(AddToTodosListState());
  }

  Future<void> updateTodo(
      TodoModel oldTodoModel, TodoModel newTodoModel) async {
    await Hive.openBox<TodoModel>("todos").then((value) {
      final Map<dynamic, TodoModel> todoMap = value.toMap();
      dynamic desiredKey;
      todoMap.forEach((key, value) {
        if (value.title == oldTodoModel.title) {
          desiredKey = key;
        }
      });
      return value.put(desiredKey, newTodoModel);
    });
    await getBox();
    emit(AddToTodosListState());
  }

  Future<void> deleteTodo(TodoModel todoModel) async {
    await Hive.openBox<TodoModel>("todos").then((value) {
      final Map<dynamic, TodoModel> todoMap = value.toMap();
      dynamic desiredKey;
      todoMap.forEach((key, value) {
        if (value.title == todoModel.title) {
          desiredKey = key;
        }
      });
      return value.delete(desiredKey); // Delete the todo item from Hive
    });
    await getBox();
    emit(AddToTodosListState());
  }
}
