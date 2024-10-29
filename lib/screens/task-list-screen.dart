import 'package:flutter/material.dart';
import '../database/database-helper.dart';
import '../model/tasks.dart';
import 'task-creation-screen.dart';
import 'task-update-screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final taskList = await dbHelper.getTasks();

    setState(() {
      tasks = taskList;
    });
  }

  void _addTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskCreationScreen()),
    );
    if (result != null) {
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tasks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.purple.shade900,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Checkbox(
                            value: task.isDone,
                            onChanged: (value) async {
                              Task updatedTask = Task(
                                id: task.id,
                                title: task.title,
                                description: task.description,
                                isDone: value!,
                              );
                              await dbHelper.updateTask(updatedTask);
                              _loadTasks(); // Refresh the list after updating
                            },
                          ),
                          Expanded(
                            child: Opacity(
                              opacity: task.isDone ? 0.5 : 1.0, // Reduce opacity if done
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TaskUpdateScreen(task: task)),
                                  );

                                  if (result == 'updated') {
                                    _loadTasks(); // Refresh the task list after returning from update screen
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        decoration: task.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      task.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        decoration: task.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await dbHelper.deleteTask(task.id!);
                              _loadTasks(); // Refresh the list after deleting
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(), // Subtle line between tasks
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}