import 'package:flutter/material.dart';
import '../database/database-helper.dart';
import '../model/tasks.dart';

class TaskUpdateScreen extends StatefulWidget {
  final Task task;

  TaskUpdateScreen({required this.task});

  @override
  _TaskUpdateScreenState createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.task.title;
    description = widget.task.description;
  }

  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task updatedTask = Task(
        id: widget.task.id,
        title: title,
        description: description,
        isDone: widget.task.isDone,
      );

      DatabaseHelper().updateTask(updatedTask);
      Navigator.pop(context, 'updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Task Details', 
        style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.purple.shade900,
          ),),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value!;
                },
              ),

              SizedBox(height: 32),

              ElevatedButton(
                onPressed: _updateTask,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade900,
                    foregroundColor: Colors.white,
                  ),
                child: Text('Save Changes', 
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}