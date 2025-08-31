import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../model/checklist_Item.dart';

class WeddingChecklistPage extends StatefulWidget {
  const WeddingChecklistPage({Key? key}) : super(key: key);

  @override
  State<WeddingChecklistPage> createState() => _WeddingChecklistPageState();
}

class _WeddingChecklistPageState extends State<WeddingChecklistPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Add/Edit dialog state variables
  String _selectedCategory = 'Custom';
  Priority _selectedPriority = Priority.medium;

  final List<String> _categories = [
    'Venue', 'Services', 'Food', 'Ceremony', 'Entertainment', 'Travel', 'Custom'
  ];

  // Sample wedding checklist items (same as before)
  List<ChecklistItem> _checklistItems = [
    ChecklistItem(
      id: '1',
      title: 'Venue Booking',
      description: 'Book wedding venue and reception hall',
      isCompleted: false,
      category: 'Venue',
      priority: Priority.high,
    ),
    ChecklistItem(
      id: '2',
      title: 'Photography',
      description: 'Hire professional wedding photographer',
      isCompleted: false,
      category: 'Services',
      priority: Priority.high,
    ),
    ChecklistItem(
      id: '3',
      title: 'Catering',
      description: 'Arrange food and beverages for guests',
      isCompleted: true,
      category: 'Food',
      priority: Priority.medium,
    ),
    ChecklistItem(
      id: '4',
      title: 'Mehendi',
      description: 'Book mehendi artist for bridal party',
      isCompleted: false,
      category: 'Ceremony',
      priority: Priority.medium,
    ),
    ChecklistItem(
      id: '5',
      title: 'Sangeet',
      description: 'Plan music and dance performances',
      isCompleted: false,
      category: 'Entertainment',
      priority: Priority.low,
    ),
    ChecklistItem(
      id: '6',
      title: 'Honeymoon Booking',
      description: 'Book honeymoon destination and travel',
      isCompleted: false,
      category: 'Travel',
      priority: Priority.low,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers (same as before)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations (same as before)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _taskController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // **OPTIMIZED TOGGLE TASK - Faster Response**
  void _toggleTask(int index) {
    // Update state immediately for instant UI response
    _checklistItems[index].isCompleted = !_checklistItems[index].isCompleted;
    setState(() {}); // Trigger rebuild immediately
  }

  // **ENHANCED ADD NEW TASK**
  void _addNewTask() {
    if (_taskController.text.trim().isEmpty) return;

    setState(() {
      _checklistItems.add(
        ChecklistItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _taskController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? 'No description'
              : _descriptionController.text.trim(),
          isCompleted: false,
          category: _selectedCategory,
          priority: _selectedPriority,
        ),
      );
    });

    // Clear form and close dialog
    _clearForm();
    Navigator.of(context).pop();
  }

  // **ENHANCED EDIT TASK**
  void _editTask(int index) {
    // Pre-fill form with existing data
    _taskController.text = _checklistItems[index].title;
    _descriptionController.text = _checklistItems[index].description;
    _selectedCategory = _checklistItems[index].category;
    _selectedPriority = _checklistItems[index].priority;

    showDialog(
      context: context,
      builder: (context) => _buildEditTaskDialog(index),
    );
  }

  void _updateTask(int index) {
    if (_taskController.text.trim().isEmpty) return;

    setState(() {
      _checklistItems[index].title = _taskController.text.trim();
      _checklistItems[index].description = _descriptionController.text.trim().isEmpty
          ? 'No description'
          : _descriptionController.text.trim();
      _checklistItems[index].category = _selectedCategory;
      _checklistItems[index].priority = _selectedPriority;
    });

    _clearForm();
    Navigator.of(context).pop();
  }

  void _clearForm() {
    _taskController.clear();
    _descriptionController.clear();
    _selectedCategory = 'Custom';
    _selectedPriority = Priority.medium;
  }

  void _showAddTaskDialog() {
    _clearForm(); // Reset form
    showDialog(
      context: context,
      builder: (context) => _buildAddTaskDialog(),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _checklistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = _checklistItems.where((item) => item.isCompleted).length;
    double progress = _checklistItems.isNotEmpty
        ? completedTasks / _checklistItems.length
        : 0.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE0E6), // Light pink
              Color(0xFFFFF8DC), // Cream
              Color(0xFFE6F3FF), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressCard(progress, completedTasks),
              Expanded(child: _buildChecklistView()),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Header and Progress Card remain the same as before...
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(128),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.pink.shade700,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wedding Checklist',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  Text(
                    'Track your wedding planning progress',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(double progress, int completedTasks) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade400, Colors.purple.shade400],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withAlpha(76),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '$completedTasks of ${_checklistItems.length} tasks',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withAlpha(76),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 6,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withAlpha(76),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}% Complete',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistView() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _checklistItems.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildChecklistItem(_checklistItems[index], index),
          );
        },
      ),
    );
  }

  // **OPTIMIZED CHECKLIST ITEM WITH FASTER CHECKBOX**
  Widget _buildChecklistItem(ChecklistItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: InkWell( // Changed from GestureDetector to InkWell for better response
          onTap: () => _toggleTask(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: item.isCompleted
                  ? Colors.green.shade400
                  : Colors.transparent,
              border: Border.all(
                color: item.isCompleted
                    ? Colors.green.shade400
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.isCompleted
                ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
                : null,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: item.isCompleted
                ? Colors.grey.shade500
                : Colors.grey.shade800,
            decoration: item.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildCategoryChip(item.category),
                const SizedBox(width: 8),
                _buildPriorityChip(item.priority),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editTask(index);
                break;
              case 'delete':
                _deleteTask(index);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  const Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red.shade600),
                  const SizedBox(width: 8),
                  const Text('Delete'),
                ],
              ),
            ),
          ],
          child: Icon(
            Icons.more_vert,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 12,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(Priority priority) {
    MaterialColor color;
    switch (priority) {
      case Priority.high:
        color = Colors.red;
        break;
      case Priority.medium:
        color = Colors.orange;
        break;
      case Priority.low:
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 12,
          color: color.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.pink.shade500,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  // **ENHANCED ADD TASK DIALOG WITH DESCRIPTION AND TAGS**
  Widget _buildAddTaskDialog() {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Add New Task',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title Field
                TextField(
                  controller: _taskController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Task Title *',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                Text(
                  'Category',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Priority Selection
                Text(
                  'Priority',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: Priority.values.map((priority) {
                    bool isSelected = _selectedPriority == priority;
                    MaterialColor color;
                    switch (priority) {
                      case Priority.high:
                        color = Colors.red;
                        break;
                      case Priority.medium:
                        color = Colors.orange;
                        break;
                      case Priority.low:
                        color = Colors.green;
                        break;
                    }

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            setDialogState(() {
                              _selectedPriority = priority;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? color.shade100 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? color.shade400 : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              priority.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: isSelected ? color.shade700 : Colors.grey.shade600,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addNewTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Add Task',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // **ENHANCED EDIT TASK DIALOG**
  Widget _buildEditTaskDialog(int index) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Edit Task',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title Field
                TextField(
                  controller: _taskController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Task Title *',
                    hintText: 'Enter task title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Field
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                Text(
                  'Category',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Priority Selection
                Text(
                  'Priority',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: Priority.values.map((priority) {
                    bool isSelected = _selectedPriority == priority;
                    MaterialColor color;
                    switch (priority) {
                      case Priority.high:
                        color = Colors.red;
                        break;
                      case Priority.medium:
                        color = Colors.orange;
                        break;
                      case Priority.low:
                        color = Colors.green;
                        break;
                    }

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            setDialogState(() {
                              _selectedPriority = priority;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? color.shade100 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? color.shade400 : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              priority.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: isSelected ? color.shade700 : Colors.grey.shade600,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _updateTask(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
