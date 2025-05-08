import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';
import '../widgets/add_todo_form.dart';
import 'todo_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({required this.userName, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  String _filter = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'todos_${widget.userName}';
    final todosJson = prefs.getString(key);

    if (todosJson != null) {
      final todosList = jsonDecode(todosJson) as List<dynamic>;
      setState(() {
        _todos = todosList.map((json) => Todo.fromJson(json)).toList();
      });
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'todos_${widget.userName}';
    final todosJson = jsonEncode(_todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(key, todosJson);
  }

  void _addTodo(String title, String? description, String category) {
    setState(() {
      _todos.add(Todo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        category: category,
      ));
    });
    saveTodos();
  }

  void _toggleTodo(String id) {
    setState(() {
      _todos = _todos.map((todo) {
        if (todo.id == id) {
          return Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            createdAt: todo.createdAt,
            isCompleted: !todo.isCompleted,
            category: todo.category,
          );
        }
        return todo;
      }).toList();
    });
    saveTodos();
  }

  void _updateTodo(Todo updatedTodo) {
    setState(() {
      _todos = _todos
          .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
          .toList();
    });
    saveTodos();
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
    saveTodos();
  }

  void _showEditDialog(Todo todo) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description);
    String selectedCategory = todo.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: const ['Personal', 'School', 'Urgent']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (value) => selectedCategory = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateTodo(Todo(
                id: todo.id,
                title: titleController.text,
                description: descController.text,
                createdAt: todo.createdAt,
                isCompleted: todo.isCompleted,
                category: selectedCategory,
              ));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  List<Todo> _getFilteredTodos() {
    final filtered = _todos.where((todo) {
      final titleMatch =
      todo.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final descMatch = todo.description
          ?.toLowerCase()
          .contains(_searchQuery.toLowerCase()) ??
          false;
      return titleMatch || descMatch;
    }).toList();

    switch (_filter) {
      case 'Completed':
        return filtered.where((todo) => todo.isCompleted).toList();
      case 'Pending':
        return filtered.where((todo) => !todo.isCompleted).toList();
      default:
        return filtered;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(child: Text(widget.userName[0])),
          ),
          DropdownButton<String>(
            value: _filter,
            items: ['All', 'Completed', 'Pending']
                .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
                .toList(),
            onChanged: (value) => setState(() => _filter = value!),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Todos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredTodos().length,
              itemBuilder: (context, index) {
                final todo = _getFilteredTodos()[index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => _deleteTodo(todo.id),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => _toggleTodo(todo.id),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todo.description != null)
                            Text(todo.description!),
                          Chip(
                            label: Text(todo.category),
                            backgroundColor: Colors.blue[100],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(todo),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(todo.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoDetailsScreen(
                              todo: todo,
                              onUpdate: _updateTodo,
                              onDelete: _deleteTodo,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => AddTodoForm(_addTodo),
        ),
      ),
    );
  }
}