import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class BudgetCalculatorPage extends StatefulWidget {
  const BudgetCalculatorPage({Key? key}) : super(key: key);

  @override
  State<BudgetCalculatorPage> createState() => _BudgetCalculatorPageState();
}

class _BudgetCalculatorPageState extends State<BudgetCalculatorPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _chartController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _chartAnimation;

  final TextEditingController _budgetController = TextEditingController();

  double _totalBudget = 0.0;
  bool _showResults = false;

  // Budget allocation percentages
  final Map<String, BudgetCategory> _categories = {
    'Venue': BudgetCategory(
      name: 'Venue & Location',
      percentage: 40.0,
      icon: Icons.location_city,
      color: Colors.pink,
      description: 'Wedding and reception venue costs',
    ),
    'Catering': BudgetCategory(
      name: 'Catering & Food',
      percentage: 30.0,
      icon: Icons.restaurant,
      color: Colors.orange,
      description: 'Food, beverages, and catering services',
    ),
    'Photography': BudgetCategory(
      name: 'Photography & Video',
      percentage: 15.0,
      icon: Icons.camera_alt,
      color: Colors.purple,
      description: 'Professional photography and videography',
    ),
    'Décor': BudgetCategory(
      name: 'Décor & Flowers',
      percentage: 10.0,
      icon: Icons.local_florist,
      color: Colors.green,
      description: 'Decorations, flowers, and styling',
    ),
    'Miscellaneous': BudgetCategory(
      name: 'Miscellaneous',
      percentage: 5.0,
      icon: Icons.more_horiz,
      color: Colors.blue,
      description: 'Other wedding expenses',
    ),
  };

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

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _chartAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartController,
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _chartController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _calculateBudget() {
    final input = _budgetController.text.replaceAll(',', '').replaceAll('₹', '');
    final budget = double.tryParse(input);

    if (budget != null && budget > 0) {
      setState(() {
        _totalBudget = budget;
        _showResults = true;
      });
      _chartController.forward(from: 0);
    } else {
      setState(() {
        _totalBudget = 0;
        _showResults = false;
      });
      _chartController.reset();
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildBudgetInputCard(),
                      const SizedBox(height: 30),
                      if (_showResults) ...[
                        _buildPieChartCard(),
                        const SizedBox(height: 20),
                        _buildAllocationList(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                    'Budget Calculator',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  Text(
                    'Plan your dream wedding budget wisely',
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

  Widget _buildBudgetInputCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(51),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade400, Colors.purple.shade400],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calculate,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Your Wedding Budget',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'We\'ll help you allocate funds wisely',
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
              const SizedBox(height: 20),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) => _calculateBudget(),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.currency_rupee,
                    color: Colors.pink.shade500,
                  ),
                  hintText: 'Enter amount (e.g., 500000)',
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.pink.shade500, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Budget Breakdown',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 5),

            // Total Budget Display - Outside the chart
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade100, Colors.purple.shade100],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.pink.shade200, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Wedding Budget',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(_totalBudget),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Pie Chart - Clean without text overlay
            SizedBox(
              height: 220,
              width: 220,
              child: AnimatedBuilder(
                animation: _chartAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(220, 220),
                    painter: BudgetPieChartPainter(
                      categories: _categories,
                      totalBudget: _totalBudget,
                      animationValue: _chartAnimation.value,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 5),

            // Legend for pie chart
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: _categories.entries.map((entry) {
                final category = entry.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: category.color.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.name.split(' ')[0], // Show first word only for compact legend
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAllocationList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: _categories.entries.map((entry) {
          final category = entry.value;
          final allocation = (_totalBudget * category.percentage / 100);

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
                  color: category.color.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: category.color.shade600,
                  size: 24,
                ),
              ),
              title: Text(
                category.name,
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
                  Text(
                    category.description,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${category.percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: category.color.shade600,
                        ),
                      ),
                      Text(
                        _formatCurrency(allocation),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Budget Category Model
class BudgetCategory {
  final String name;
  final double percentage;
  final IconData icon;
  final MaterialColor color;
  final String description;

  BudgetCategory({
    required this.name,
    required this.percentage,
    required this.icon,
    required this.color,
    required this.description,
  });
}

// Custom Pie Chart Painter
class BudgetPieChartPainter extends CustomPainter {
  final Map<String, BudgetCategory> categories;
  final double totalBudget;
  final double animationValue;

  BudgetPieChartPainter({
    required this.categories,
    required this.totalBudget,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    double startAngle = -math.pi / 2;

    for (final entry in categories.entries) {
      final category = entry.value;
      final sweepAngle = (category.percentage / 100) * 2 * math.pi * animationValue;

      final paint = Paint()
        ..color = category.color.shade400
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Add border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
