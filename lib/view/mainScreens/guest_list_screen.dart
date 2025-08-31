import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../model/guest_model.dart';


class GuestListPage extends StatefulWidget {
  const GuestListPage({Key? key}) : super(key: key);

  @override
  State<GuestListPage> createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _listController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _listAnimation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  RSVPStatus _selectedStatus = RSVPStatus.pending;

  // **ADD SAMPLE GUEST DATA**
  final List<Guest> _guests = [
    Guest(
      id: '1',
      name: 'Priya Sharma',
      phoneNumber: '+91 98765 43210',
      email: 'priya.sharma@gmail.com',
      status: RSVPStatus.attending,
      addedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Guest(
      id: '2',
      name: 'Rajesh Kumar',
      phoneNumber: '+91 87654 32109',
      email: 'rajesh.kumar@yahoo.com',
      status: RSVPStatus.attending,
      addedDate: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Guest(
      id: '3',
      name: 'Anita Patel',
      phoneNumber: '+91 76543 21098',
      email: 'anita.patel@outlook.com',
      status: RSVPStatus.pending,
      addedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Guest(
      id: '4',
      name: 'Vikram Singh',
      phoneNumber: '+91 65432 10987',
      status: RSVPStatus.attending,
      addedDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Guest(
      id: '5',
      name: 'Meera Gupta',
      email: 'meera.gupta@gmail.com',
      status: RSVPStatus.notAttending,
      addedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Guest(
      id: '6',
      name: 'Suresh Reddy',
      phoneNumber: '+91 54321 09876',
      email: 'suresh.reddy@hotmail.com',
      status: RSVPStatus.pending,
      addedDate: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Guest(
      id: '7',
      name: 'Kavitha Nair',
      phoneNumber: '+91 43210 98765',
      status: RSVPStatus.attending,
      addedDate: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Guest(
      id: '8',
      name: 'Arjun Mehta',
      phoneNumber: '+91 32109 87654',
      email: 'arjun.mehta@gmail.com',
      status: RSVPStatus.pending,
      addedDate: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];


  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
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

    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
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

    _listAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOutBack,
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
    Future.delayed(const Duration(milliseconds: 900), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _listController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addGuest() {
    if (_nameController.text.trim().isEmpty) return;

    setState(() {
      _guests.add(
        Guest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          status: _selectedStatus,
          addedDate: DateTime.now(),
        ),
      );
    });

    _clearForm();
    Navigator.of(context).pop();

    // Trigger list animation
    _listController.forward(from: 0);
  }

  void _updateGuest(int index) {
    if (_nameController.text.trim().isEmpty) return;

    setState(() {
      _guests[index] = Guest(
        id: _guests[index].id,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        status: _selectedStatus,
        addedDate: _guests[index].addedDate,
      );
    });

    _clearForm();
    Navigator.of(context).pop();
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _selectedStatus = RSVPStatus.pending;
  }

  void _showAddGuestDialog() {
    _clearForm();
    showDialog(
      context: context,
      builder: (context) => _buildGuestDialog(isEdit: false),
    );
  }

  void _editGuest(int index) {
    final guest = _guests[index];
    _nameController.text = guest.name;
    _phoneController.text = guest.phoneNumber ?? '';
    _emailController.text = guest.email ?? '';
    _selectedStatus = guest.status;

    showDialog(
      context: context,
      builder: (context) => _buildGuestDialog(isEdit: true, index: index),
    );
  }

  void _removeGuest(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Guest',
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        ),
        content: Text(
          'Are you sure you want to remove ${_guests[index].name} from the guest list?',
          style: const TextStyle(fontFamily: "Poppins"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _guests.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Remove',
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  MaterialColor _getStatusColor(RSVPStatus status) {
    switch (status) {
      case RSVPStatus.attending:
        return Colors.green;
      case RSVPStatus.notAttending:
        return Colors.red;
      case RSVPStatus.pending:
        return Colors.orange;
    }
  }


  IconData _getStatusIcon(RSVPStatus status) {
    switch (status) {
      case RSVPStatus.attending:
        return Icons.check_circle;
      case RSVPStatus.notAttending:
        return Icons.cancel;
      case RSVPStatus.pending:
        return Icons.schedule;
    }
  }

  String _getStatusLabel(RSVPStatus status) {
    switch (status) {
      case RSVPStatus.attending:
        return 'Attending';
      case RSVPStatus.notAttending:
        return 'Not Attending';
      case RSVPStatus.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    int attendingCount = _guests.where((g) => g.status == RSVPStatus.attending).length;
    int notAttendingCount = _guests.where((g) => g.status == RSVPStatus.notAttending).length;
    int pendingCount = _guests.where((g) => g.status == RSVPStatus.pending).length;

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
              _buildStatsCard(attendingCount, notAttendingCount, pendingCount),
              Expanded(child: _buildGuestList()),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

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
                    'Guest List',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  Text(
                    'Manage wedding guests & RSVP status',
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

  Widget _buildStatsCard(int attending, int notAttending, int pending) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
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
            Text(
              'Guest Statistics',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        attending.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Attending',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        pending.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Pending',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        notAttending.toString(),
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Not Coming',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestList() {
    if (_guests.isEmpty) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No guests added yet',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button to add your first guest',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _guests.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildGuestCard(_guests[index], index),
          );
        },
      ),
    );
  }
  Widget _buildGuestCard(Guest guest, int index) {
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
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getStatusColor(guest.status).shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(guest.status),
            color: _getStatusColor(guest.status).shade600,
            size: 24,
          ),
        ),
        title: Text(
          guest.name,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (guest.phoneNumber != null)
              Text(
                guest.phoneNumber!,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            if (guest.email != null)
              Text(
                guest.email!,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(guest.status).shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusLabel(guest.status),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(guest.status).shade700,
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _editGuest(index);
                break;
              case 'delete':
                _removeGuest(index);
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


  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton(
        onPressed: _showAddGuestDialog,
        backgroundColor: Colors.pink.shade500,
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildGuestDialog({required bool isEdit, int? index}) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isEdit ? 'Edit Guest' : 'Add New Guest',
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
              children: [
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Guest Name *',
                    prefixIcon: Icon(Icons.person, color: Colors.pink.shade500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: Colors.pink.shade500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email, color: Colors.pink.shade500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<RSVPStatus>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'RSVP Status',
                    prefixIcon: Icon(Icons.rsvp, color: Colors.pink.shade500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                    ),
                  ),
                  items: RSVPStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(status),
                            color: _getStatusColor(status).shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getStatusLabel(status),
                            style: const TextStyle(fontFamily: "Poppins"),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
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
              onPressed: () {
                if (isEdit && index != null) {
                  _updateGuest(index);
                } else {
                  _addGuest();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isEdit ? 'Update Guest' : 'Add Guest',
                style: const TextStyle(
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
