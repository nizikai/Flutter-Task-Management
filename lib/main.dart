import 'package:flutter/material.dart';
import 'screens/task-list-screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      debugShowCheckedModeBanner: false, 
      home: TaskListScreen(),
    );
  }
}


