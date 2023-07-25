import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todo_cubit/cubit/cubit.dart';
import 'package:todo_cubit/cubit/states.dart';
import 'package:todo_cubit/model/todo_model.dart';

import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_tile.dart';

class AllTodosScreen extends StatelessWidget {
  const AllTodosScreen({super.key});

  _showAddTodoDialog(BuildContext context) {
    final cubit = TodoCubit.get(context);

    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(
        context: context,
        cubit: cubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoStates>(
      builder: (context, state) {
        var cubit = TodoCubit.get(context);
        List<TodoModel>? todosList = [];
        for (var item in cubit.todosList!) {
          if (!item.isArchived && !item.isDone) {
            todosList.add(item);
          }
        }
        return todosList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _showAddTodoDialog(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.shade200,
                        radius: 30,
                        child: const Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Press + to add",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return TodoTile(todoModel: todosList[index]);
                },
                itemCount: todosList.length,
                shrinkWrap: true,
              );
      },
    );
  }
}
