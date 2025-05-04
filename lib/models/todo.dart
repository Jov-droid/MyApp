class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final String category;

  const Todo({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.isCompleted = false,
    required this.category,
  });
}