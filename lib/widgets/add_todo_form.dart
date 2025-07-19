import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart'; // ADD THIS IMPORT
import '../providers/providers.dart';

class AddTodoForm extends ConsumerStatefulWidget {
  final String userName;

  const AddTodoForm({required this.userName, super.key});

  @override
  ConsumerState<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends ConsumerState<AddTodoForm> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'Personal';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Description (optional)'),
          ),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: const ['Personal', 'School', 'Urgent'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Add Todo'),
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                ref.read(todoListProvider.notifier).addTodo(
                  Todo( // FIXED: Now recognizes Todo class
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    description: _descController.text.isEmpty
                        ? null : _descController.text,
                    createdAt: DateTime.now(),
                    category: _selectedCategory,
                  ),
                  widget.userName,
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}