import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/provider/provider.dart';

class DialogComponent extends StatelessWidget {
  const DialogComponent({
    super.key,
    required this.controller,
    this.id,
  });

  final TextEditingController controller;

  final String? id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter todo title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        Consumer(builder: (context, ref, _) {
          return TextButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                if (id != null) {
                  ref.read(serviceProvider).update(id!, title);
                } else {
                  String id = randomAlphaNumeric(10);
                  Todo newItem = Todo(id: id, title: title);
                  ref.read(serviceProvider).addPersonalTask(newItem, id);
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          );
        }),
      ],
    );
  }
}
