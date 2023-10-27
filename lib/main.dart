import 'package:flutter/material.dart';
import 'package:project_1/todo_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color.fromARGB(255, 2, 160, 55),
          brightness: Brightness.dark),
      // darkTheme: ThemeData.dark(),
      home: const TodoListScreen(),
    );
  }
}
