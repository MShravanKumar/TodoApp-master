import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String? id;
  final String title;

  Todo({
    this.id,
    required this.title,
  });

  Todo copyWith({
    String? id,
    String? title,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{"id": id, "title": title};

    return result;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
    );
  }
  factory Todo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Todo(
      id: doc.id,
      title: doc['title'],
    );
  }
}
