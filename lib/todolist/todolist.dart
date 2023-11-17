import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'todolist_model.dart';

class ToDoListPage extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();
  final TodoListModel _model = TodoListModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List Page'),
        automaticallyImplyLeading :false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _model.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Enter a task'),
            ),
          ),
          ElevatedButton(
          onPressed: () {
          _model.addTask(_taskController.text);
          _taskController.clear();
          },
          child: Text('Add Task'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _model.getTasks(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No Tasks Found'));
                }
                var tasks = snapshot.data?.docs ?? [];
                return ListView(
                  children: tasks.map((doc) {
                    return ListTile(
                      title: Text(doc['todo']),
                      leading: Checkbox(
                        value: doc['isDone'],
                        onChanged: (bool? value) {
                          _model.toggleTaskDone(doc.id, doc['isDone']);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _model.deleteTask(doc.id);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}