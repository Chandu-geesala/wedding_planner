
// Data Models
class ChecklistItem {
  String id;
  String title;
  String description;
  bool isCompleted;
  String category;
  Priority priority;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
    required this.priority,
  });
}

enum Priority { high, medium, low }
