import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../model/venue_Item.dart';


class VenueListingPage extends StatefulWidget {
  const VenueListingPage({Key? key}) : super(key: key);

  @override
  State<VenueListingPage> createState() => _VenueListingPageState();
}

class _VenueListingPageState extends State<VenueListingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Filter values
  RangeValues _priceRange = const RangeValues(100000, 500000);
  RangeValues _capacityRange = const RangeValues(100, 500);
  bool _showFilters = false;

  // Sample venue data
  final List<Venue> _allVenues = [
    Venue(
      id: '1',
      name: 'Royal Palace Gardens',
      location: 'Mumbai, Maharashtra',
      price: 250000,
      minCapacity: 200,
      maxCapacity: 300,
      imageAsset: 'assets/ryl.jpg',
      rating: 4.8,
      amenities: ['Parking', 'AC', 'Catering', 'Photography'],
    ),
    Venue(
      id: '2',
      name: 'Sunset Beach Resort',
      location: 'Goa',
      price: 300000,
      minCapacity: 150,
      maxCapacity: 250,
      imageAsset: 'assets/snt.jpg',
      rating: 4.6,
      amenities: ['Beach View', 'Bar', 'DJ', 'Rooms'],
    ),
    Venue(
      id: '3',
      name: 'Heritage Mansion',
      location: 'Jaipur, Rajasthan',
      price: 450000,
      minCapacity: 300,
      maxCapacity: 500,
      imageAsset: 'assets/hrt.png',
      rating: 4.9,
      amenities: ['Heritage Property', 'Garden', 'Palace Theme'],
    ),
    Venue(
      id: '4',
      name: 'Grand Oak Hall',
      location: 'Delhi NCR',
      price: 150000,
      minCapacity: 100,
      maxCapacity: 200,
      imageAsset: 'assets/2.png',
      rating: 4.3,
      amenities: ['Metro Connectivity', 'Parking', 'AC'],
    ),
    Venue(
      id: '5',
      name: 'Euphoria Palace',
      location: 'Bangalore, Karnataka',
      price: 350000,
      minCapacity: 250,
      maxCapacity: 350,
      imageAsset: 'assets/snt.jpg',
      rating: 4.7,
      amenities: ['IT City Location', 'Modern Amenities', 'Valet'],
    ),
    Venue(
      id: '6',
      name: 'Celestial Gardens',
      location: 'Hyderabad, Telangana',
      price: 200000,
      minCapacity: 150,
      maxCapacity: 300,
      imageAsset: 'assets/hrt.png',
      rating: 4.5,
      amenities: ['Garden Wedding', 'Open Sky', 'Traditional'],
    ),
    Venue(
      id: '7',
      name: 'Blossom Resort',
      location: 'Chennai, Tamil Nadu',
      price: 275000,
      minCapacity: 200,
      maxCapacity: 300,
      imageAsset: 'assets/ryl.jpg',
      rating: 4.4,
      amenities: ['Resort Style', 'Pool Area', 'South Indian'],
    ),
    Venue(
      id: '8',
      name: 'Seaside Pavilion',
      location: 'Goa Beach',
      price: 325000,
      minCapacity: 180,
      maxCapacity: 280,
      imageAsset: 'assets/snt.jpg',
      rating: 4.8,
      amenities: ['Ocean View', 'Sunset Wedding', 'Beach Party'],
    ),
  ];

  List<Venue> _filteredVenues = [];

  @override
  void initState() {
    super.initState();

    _filteredVenues = List.from(_allVenues);

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
    super.dispose();
  }

  void _filterVenues() {
    setState(() {
      _filteredVenues = _allVenues.where((venue) {
        bool priceMatch = venue.price >= _priceRange.start && venue.price <= _priceRange.end;
        bool capacityMatch = venue.maxCapacity >= _capacityRange.start && venue.minCapacity <= _capacityRange.end;
        return priceMatch && capacityMatch;
      }).toList();
    });
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
              if (_showFilters) _buildFilterSection(),
              _buildResultsHeader(),
              Expanded(child: _buildVenuesList()),
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
                    'Find Venues',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  Text(
                    'Perfect venues for your dream wedding',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _showFilters
                      ? Colors.pink.shade500
                      : Colors.white.withAlpha(128),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tune,
                  color: _showFilters
                      ? Colors.white
                      : Colors.pink.shade700,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
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
            Text(
              'Filter by Budget',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
            ),
            const SizedBox(height: 12),
            RangeSlider(
              values: _priceRange,
              min: 100000,
              max: 500000,
              divisions: 8,
              labels: RangeLabels(
                '₹${(_priceRange.start / 1000).toInt()}K',
                '₹${(_priceRange.end / 1000).toInt()}K',
              ),
              activeColor: Colors.pink.shade500,
              inactiveColor: Colors.pink.shade100,
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
                _filterVenues();
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Filter by Capacity (Guests)',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade700,
              ),
            ),
            const SizedBox(height: 12),
            RangeSlider(
              values: _capacityRange,
              min: 100,
              max: 500,
              divisions: 8,
              labels: RangeLabels(
                '${_capacityRange.start.toInt()}',
                '${_capacityRange.end.toInt()}',
              ),
              activeColor: Colors.pink.shade500,
              inactiveColor: Colors.pink.shade100,
              onChanged: (values) {
                setState(() {
                  _capacityRange = values;
                });
                _filterVenues();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_filteredVenues.length} venues found',
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            if (_filteredVenues.isEmpty)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(100000, 500000);
                    _capacityRange = const RangeValues(100, 500);
                    _filteredVenues = List.from(_allVenues);
                  });
                },
                icon: Icon(Icons.refresh, size: 16, color: Colors.pink.shade500),
                label: Text(
                  'Reset Filters',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.pink.shade500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenuesList() {
    if (_filteredVenues.isEmpty) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No venues found',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filteredVenues.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _slideAnimation,
            child: _buildVenueCard(_filteredVenues[index], index),
          );
        },
      ),
    );
  }

  Widget _buildVenueCard(Venue venue, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Venue Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                venue.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade300, Colors.purple.shade300],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Venue Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        venue.name,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          venue.rating.toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        venue.location,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          '₹${(venue.price / 1000).toInt()}K',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Capacity',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          '${venue.minCapacity}-${venue.maxCapacity} guests',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Amenities',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: venue.amenities.map((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.pink.shade200),
                      ),
                      child: Text(
                        amenity,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          color: Colors.pink.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle venue selection
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected ${venue.name}'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Select This Venue',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
