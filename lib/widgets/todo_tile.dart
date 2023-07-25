import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_cubit/cubit/cubit.dart';

import '../cubit/states.dart';
import '../model/todo_model.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({Key? key, required this.todoModel}) : super(key: key);

  final TodoModel todoModel;

  @override
  Widget build(BuildContext context) {
    final cubit = TodoCubit.get(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shadowColor: todoModel.isDone
            ? Colors.green
            : todoModel.isArchived
                ? Colors.red
                : Colors.black,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  todoModel.title,
                  style: GoogleFonts.notoSans(
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _showEditTodoDialog(context, todoModel);
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.updateTodo(
                      todoModel,
                      TodoModel(
                        title: todoModel.title,
                        description: todoModel.description,
                        date: todoModel.date,
                        isDone: false,
                        isArchived: true,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.archive_outlined,
                    color: todoModel.isArchived ? Colors.black : Colors.grey,
                    size: 30,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.done,
                    color: todoModel.isDone ? Colors.green : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    cubit.updateTodo(
                      todoModel,
                      TodoModel(
                        title: todoModel.title,
                        description: todoModel.description,
                        date: todoModel.date,
                        isDone: true,
                        isArchived: false,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    cubit.deleteTodo(todoModel);
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Colors.black,
                ),
                if (todoModel.isDone) // Show "Completed" if the task is done
                  Text(
                    "Completed",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.green,
                      ),
                    ),
                  )
                else if (todoModel
                    .isArchived) // Show "Pending" if the task is archived
                  Text(
                    "Pending",
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  todoModel.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat.yMMMEd().format(todoModel.date),
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditTodoDialog(BuildContext context, TodoModel todo) {
    final cubit = TodoCubit.get(context);
    cubit.titleController.text = todo.title;
    cubit.descriptionController.text = todo.description;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Todo",
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
              final updatedTodo = TodoModel(
                title: cubit.titleController.text,
                description: cubit.descriptionController.text,
                date: cubit.initialDate,
                isDone: todo.isDone,
                isArchived: todo.isArchived,
              );

              cubit.updateTodo(todo, updatedTodo);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Todo updated"),
                ),
              );

              Navigator.pop(context);
            },
            icon: const Icon(Icons.edit),
            label: Text(
              "Update",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
