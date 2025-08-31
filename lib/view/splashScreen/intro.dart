import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_screens/signIn.dart';
import '../mainScreens/home_screen.dart';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Updated demoData with Lottie file paths & short, punchy text
  final List<Map<String, dynamic>> demoData = [
    {
      "lottie": "assets/manage.json", // Your existing Lottie file
      "title": "Plan Your Dream Wedding 💍✨",
      "text": "From checklists to venues - we've got everything covered for your perfect day"
    },
    {
      "lottie": "assets/budget.json", // Reuse or add wedding-specific animations
      "title": "Smart Budget Management 💰📊",
      "text": "Calculate and allocate your wedding budget across venues, catering, décor and more"
    },
    {
      "lottie": "assets/guest.json",
      "title": "Guest List & RSVP Tracking 👥💌",
      "text": "Manage your guest list effortlessly and track RSVP responses in real-time"
    },

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFF0F8FF),
                  Color(0xFFE6F3FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Decorative Circles
          Positioned(
            top: -100,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.lightBlue.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                SizedBox(
                  height: 520,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: demoData.length,
                    onPageChanged: (value) =>
                        setState(() => _selectedIndex = value),
                    itemBuilder: (context, index) {
                      return OnboardContent(
                        lottie: demoData[index]['lottie'],
                        title: demoData[index]['title'],
                        text: demoData[index]['text'],
                        index: index,
                        currentIndex: _selectedIndex,
                      );
                    },
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    demoData.length,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: AnimatedDot(isActive: _selectedIndex == index),
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: child,
                  ),
                  child: ElevatedButton(
                    key: ValueKey(_selectedIndex),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      elevation: 10,
                      shadowColor: Colors.blueAccent,
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (_selectedIndex == demoData.length - 1) {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        await prefs.setBool('isIntroComplete', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            FirebaseAuth.instance.currentUser == null
                                ? const SignInPage()
                                : HomePage(),
                          ),
                        );
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutQuart,
                        );
                      }
                    },
                    child: Text(
                      _selectedIndex == demoData.length - 1
                          ? "🚀 Let's Go"
                          : "Next →",
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String lottie, title, text;
  final int index, currentIndex;

  const OnboardContent({
    super.key,
    required this.lottie,
    required this.title,
    required this.text,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = index == currentIndex;
    return AnimatedOpacity(
      opacity: isCurrent ? 1 : 0.55,
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 35,
                offset: const Offset(0, 18),
              ),
            ],
            border: Border.all(color: const Color(0xFFE3F2FD), width: 2.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie Animation
              SizedBox(
                height: 250,
                width: 350,
                child: Lottie.asset(lottie, fit: BoxFit.contain),
              ),
              const SizedBox(height: 26),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A365D),
                  letterSpacing: 0.7,
                  fontSize: 23,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4A5568),
                    fontSize: 16.3,
                    fontWeight: FontWeight.w500,
                    height: 1.48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedDot extends StatelessWidget {
  final bool isActive;
  const AnimatedDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 10,
      width: isActive ? 34 : 11,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2563EB) : Colors.grey[300],
        borderRadius: BorderRadius.circular(14),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.40),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
    );
  }
}
