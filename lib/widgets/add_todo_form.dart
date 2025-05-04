import 'package:flutter/material.dart';

class AddTodoForm extends StatefulWidget {
  final Function(String, String?, String) onSubmit;

  const AddTodoForm(this.onSubmit, {super.key});

  @override
  _AddTodoFormState createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
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
                widget.onSubmit(
                  _titleController.text,
                  _descController.text.isEmpty ? null : _descController.text,
                  _selectedCategory,
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