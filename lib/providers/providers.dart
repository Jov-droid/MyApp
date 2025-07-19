import 'package:flutter/material.dart'; // Add this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import 'dart:convert';

// Theme Provider with persistence
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _prefKey = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_prefKey) ?? ThemeMode.system.index;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, state.index);
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveTheme();
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _saveTheme();
  }
}

// Username Provider
final usernameProvider = StateProvider<String>((ref) => '');

// Todo List Provider
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]);

  Future<void> loadTodos(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'todos_$username';
    final todosJson = prefs.getString(key);

    if (todosJson != null) {
      final todosList = jsonDecode(todosJson) as List<dynamic>;
      state = todosList.map((json) => Todo.fromJson(json)).toList();
    }
  }

  Future<void> _saveTodos(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'todos_$username';
    final todosJson = jsonEncode(state.map((todo) => todo.toJson()).toList());
    await prefs.setString(key, todosJson);
  }

  void addTodo(Todo todo, String username) {
    state = [...state, todo];
    _saveTodos(username);
  }

  void toggleTodo(String id, String username) {
    state = state.map((todo) {
      return todo.id == id
          ? Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        createdAt: todo.createdAt,
        isCompleted: !todo.isCompleted,
        category: todo.category,
      )
          : todo;
    }).toList();
    _saveTodos(username);
  }

  void updateTodo(Todo updatedTodo, String username) {
    state = state.map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo).toList();
    _saveTodos(username);
  }

  void deleteTodo(String id, String username) {
    state = state.where((todo) => todo.id != id).toList();
    _saveTodos(username);
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>((ref) {
  return TodoListNotifier();
});