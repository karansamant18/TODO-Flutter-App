import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_cubit/cubit/cubit.dart';
import 'package:todo_cubit/cubit/states.dart';
import 'package:todo_cubit/model/todo_model.dart';

import '../widgets/todo_tile.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TodoCubit.get(context);
        List<TodoModel>? todosList = [];
        for (var item in cubit.todosList!) {
          if (item.isDone || item.isArchived) {
            todosList.add(item);
          }
        }
        return todosList.isEmpty
            ? Center(
                child: Text(
                  "Done is empty",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
