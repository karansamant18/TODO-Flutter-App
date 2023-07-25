import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_cubit/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubit/states.dart';
import 'package:todo_cubit/screens/all_todos_screen.dart';
import 'package:todo_cubit/screens/done_screen.dart';

import '../widgets/add_todo_dialog.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<Widget> list = [
    const AllTodosScreen(),
    const SizedBox.shrink(),
    const DoneScreen(),
  ];
  final List<String> title = [
    "Todo List",
    "",
    "Status",
  ];
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
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TodoCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                title[cubit.currentIndex],
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 92, 94, 95),
                    Color.fromARGB(255, 51, 55, 58),
                    Color.fromARGB(255, 51, 55, 58),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: list[cubit.currentIndex],
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    cubit.setBottomIndex(0);
                  },
                  icon: const Icon(Icons.home_outlined),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: const Color.fromARGB(255, 67, 67, 67),
                    child: IconButton(
                      iconSize: 60,
                      onPressed: () {
                        _showAddTodoDialog(context);
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    cubit.setBottomIndex(2);
                  },
                  icon: const Icon(Icons.task_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
