import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../providers/providers.dart';

class TodoDetailsScreen extends ConsumerStatefulWidget {
  final Todo todo;
  final String userName;

  const TodoDetailsScreen({
    required this.todo,
    required this.userName,
    super.key,
  });

  @override
  ConsumerState<TodoDetailsScreen> createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends ConsumerState<TodoDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descController = TextEditingController(text: widget.todo.description);
    _selectedCategory = widget.todo.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref
                  .read(todoListProvider.notifier)
                  .deleteTodo(widget.todo.id, widget.userName);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
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
            Text(
              'Created: ${DateFormat('MMM dd, yyyy - HH:mm').format(widget.todo.createdAt)}',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          ref.read(todoListProvider.notifier).updateTodo(
            Todo(
              id: widget.todo.id,
              title: _titleController.text,
              description: _descController.text,
              createdAt: widget.todo.createdAt,
              isCompleted: widget.todo.isCompleted,
              category: _selectedCategory,
            ),
            widget.userName,
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}