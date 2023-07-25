import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../model/todo_model.dart';

class AddTodoDialog extends StatelessWidget {
  const AddTodoDialog({
    super.key,
    required this.context,
    required this.cubit,
  });

  final BuildContext context;
  final TodoCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit.titleController.clear();
    cubit.descriptionController.clear();
    cubit.resetDate();

    return AlertDialog(
      title: Text(
        "Todo Details",
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: BlocBuilder<TodoCubit, TodoStates>(
        builder: (context, state) {
          return Form(
            key: cubit.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: GoogleFonts.montserrat(),
                  controller: cubit.titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Title",
                    hintText: "Enter Title",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please write title";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                TextFormField(
                  style: GoogleFonts.montserrat(),
                  controller: cubit.descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Description",
                    hintText: "Enter Description",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please write description";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {
                    cubit.setDate(context);
                  },
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    DateFormat.yMMMEd().format(
                      cubit.initialDate,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          onPressed: () {
            cubit.addTodo(
              TodoModel(
                title: cubit.titleController.text,
                description: cubit.descriptionController.text,
                date: cubit.initialDate,
                isDone: false,
                isArchived: false,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${cubit.titleController.text} added"),
              ),
            );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.add),
          label: Text(
            "Add",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
