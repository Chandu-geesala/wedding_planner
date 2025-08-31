import 'package:bauer/view/mainScreens/venue_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../viewModel/auth_view_model.dart';
import 'budget_calculator.dart';
import 'checklist.dart';
import 'guest_list_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

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

    _rotateController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

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

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotateController);

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), // Smooth scrolling
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Important: prevents overflow
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildWelcomeCard(),
                  const SizedBox(height: 30),
                  _buildQuickActions(),
                  const SizedBox(height: 30),
                  _buildFeaturedVenues(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Get display name from SharedPreferences synchronously
        String displayName = 'User'; // Default

        // Simple check from current user
        if (authViewModel.currentUser?.displayName != null &&
            authViewModel.currentUser!.displayName!.isNotEmpty) {
          displayName = authViewModel.currentUser!.displayName!;
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello, $displayName!',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Let\'s plan your dream wedding ✨',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }



  Widget _buildWelcomeCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
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
            mainAxisSize: MainAxisSize.min, // Prevent overflow
            children: [

              const Text(
                'Your Perfect Wedding Awaits',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily:'Poppins',fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Handle text overflow
              ),
              const SizedBox(height: 8),
              const Text(
                'From checklists to venues, we\'ve got you covered!',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily:"Poppins",fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Limit lines to prevent overflow
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Prevent overflow
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontFamily:"Poppins",fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
            builder: (context, constraints) {
              // Calculate card size based on available width
              double cardWidth = (constraints.maxWidth - 15) / 2;
              double cardHeight = cardWidth * 0.9; // Adjust aspect ratio

              return GridView.count(
                shrinkWrap: true, // Important: prevents infinite height
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: cardWidth / cardHeight, // Dynamic aspect ratio
                children: [

                  _buildActionCard(
                    'Wedding\nChecklist',
                    Icons.checklist_rounded,
                    Colors.green.shade400,
                        () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const WeddingChecklistPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),


                  _buildActionCard(
                    'Find\nVenues',
                    Icons.location_city,
                    Colors.blue.shade400,
                        () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const VenueListingPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    'Budget\nCalculator',
                    Icons.calculate_rounded,
                    Colors.orange.shade400,
                        () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const BudgetCalculatorPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    'Guest\nList',
                    Icons.people_rounded,
                    Colors.purple.shade400,
                        () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const GuestListPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            }
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(12), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(51),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Prevent overflow
              children: [
                Flexible( // Allow flexible sizing
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(12), // Reduced padding
                    decoration: BoxDecoration(
                      color: color.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28, // Slightly smaller icon
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Reduced spacing
                Flexible( // Allow flexible sizing
                  flex: 1,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily:"Poppins",fontSize: 14, // Slightly smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2, // Limit lines
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildFeaturedVenues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Featured Venues',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _featuredVenues.length,
            itemBuilder: (context, index) {
              return _buildVenueCard(_featuredVenues[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVenueCard(Map<String, String> venue, int index) {
    // Define the asset paths for each venue
    List<String> venueImages = [
      'assets/ryl.jpg',   // Royal Palace Gardens
      'assets/snt.jpg',  // Sunset Beach Resort
      'assets/hrt.png',   // Heritage Mansion
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container with asset image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  child: Image.asset(
                    venueImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to gradient background if image fails to load
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.pink.shade300,
                              Colors.purple.shade300,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.photo_camera_back,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        venue['name']!,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        venue['location']!,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              venue['price']!,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              venue['capacity']!,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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

  // Sample venue data
  final List<Map<String, String>> _featuredVenues = [
    {
      'name': 'Royal Palace Gardens',
      'location': 'Mumbai, Maharashtra',
      'price': '₹2,50,000',
      'capacity': '200-300 guests',
    },
    {
      'name': 'Sunset Beach Resort',
      'location': 'Goa',
      'price': '₹3,00,000',
      'capacity': '150-250 guests',
    },
    {
      'name': 'Heritage Mansion',
      'location': 'Jaipur, Rajasthan',
      'price': '₹4,50,000',
      'capacity': '300-500 guests',
    },
  ];
}
