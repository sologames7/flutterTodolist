import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoListModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Added FirebaseAuth instance

  void addTask(String task) {
    if (task.isNotEmpty) {
      _firestore.collection('tasks').add({
        'todo': task,
        'isDone': false,
        'userId': _auth.currentUser?.uid ?? '',
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<QuerySnapshot> getTasks() {
    String userId = _auth.currentUser?.uid ?? '';
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> deleteTask(String taskId) {
    return _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<void> toggleTaskDone(String taskId, bool isDone) {
    return _firestore.collection('tasks').doc(taskId).update({'isDone': !isDone});
  }
}
