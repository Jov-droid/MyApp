import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../widgets/add_todo_form.dart';
import 'todo_details_screen.dart';
import '../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String userName;

  const HomeScreen({required this.userName, super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(todoListProvider.notifier).loadTodos(widget.userName));
  }

  List<Todo> _getFilteredTodos(List<Todo> todos) {
    final filtered = todos.where((todo) {
      final titleMatch = todo.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final descMatch = todo.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      return titleMatch || descMatch;
    }).toList();

    switch (_filter) {
      case 'Completed': return filtered.where((todo) => todo.isCompleted).toList();
      case 'Pending': return filtered.where((todo) => !todo.isCompleted).toList();
      default: return filtered;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoListProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
              themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
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
              itemCount: _getFilteredTodos(todos).length,
              itemBuilder: (context, index) {
                final todo = _getFilteredTodos(todos)[index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => ref
                      .read(todoListProvider.notifier)
                      .deleteTodo(todo.id, widget.userName),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => ref
                            .read(todoListProvider.notifier)
                            .toggleTodo(todo.id, widget.userName),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.isCompleted
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todo.description != null) Text(todo.description!),
                          Chip(
                            label: Text(todo.category),
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodoDetailsScreen(
                                  todo: todo,
                                  userName: widget.userName,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => ref
                                .read(todoListProvider.notifier)
                                .deleteTodo(todo.id, widget.userName),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoDetailsScreen(
                              todo: todo,
                              userName: widget.userName,
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
          builder: (context) => AddTodoForm(userName: widget.userName),
        ),
      ),
    );
  }
}