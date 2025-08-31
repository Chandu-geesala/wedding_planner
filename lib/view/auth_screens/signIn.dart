import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';  // Add this import
import '../../viewModel/auth_view_model.dart';
import '../mainScreens/home_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;

  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

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

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

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

    _floatingAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
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
    _floatingController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String value) {
    setState(() {
      _isPhoneValid = value.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D), // Bright pink
                  Color(0xFFFF8E9A), // Pink-orange
                  Color(0xFFFFB347), // Warm orange
                  Color(0xFFFFD93D), // Bright yellow
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      _buildFloatingElements(),
                      const SizedBox(height: 40),
                      _buildWelcomeSection(),
                      const SizedBox(height: 50),
                      _buildSignInCard(authViewModel),
                      const SizedBox(height: 30),
                      _buildFooterText(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        // Floating hearts
        AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_floatingAnimation.value, 0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white.withAlpha(128),
                    size: 30,
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(-_floatingAnimation.value * 1.5, 20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.celebration,
                    color: Colors.white.withAlpha(128),
                    size: 25,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withAlpha(76),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Image.asset(
              'assets/logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to continue planning your dream wedding',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSignInCard(AuthViewModel authViewModel) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPhoneNumberField(),
              // Dynamic spacing based on button visibility
              SizedBox(height: _isPhoneValid ? 24 : 12),
              // Show/Hide Phone Sign In Button with smooth animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: _isPhoneValid
                    ? _buildPhoneSignInButton(authViewModel)
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: _isPhoneValid ? 32 : 24),
              _buildDivider(),
              const SizedBox(height: 32),
              _buildGoogleSignInButton(authViewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPhoneValid ? Colors.green.shade400 : Colors.grey.shade300,
              width: 2,
            ),
            color: Colors.grey.shade50,
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: _validatePhone,
            decoration: InputDecoration(
              prefixIcon: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '+91',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 20,
                      width: 1,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
              suffixIcon: _isPhoneValid
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              hintText: 'Enter your phone number',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneSignInButton(AuthViewModel authViewModel) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (_isPhoneValid && !authViewModel.isPhoneLoading)
            ? _handlePhoneSignIn : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isPhoneValid
              ? (authViewModel.isPhoneLoading ? Colors.grey.shade400 : Colors.pink.shade500)
              : Colors.grey.shade300,
          foregroundColor: Colors.white,
          elevation: _isPhoneValid ? 8 : 0,
          shadowColor: Colors.pink.withAlpha(128),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: authViewModel.isPhoneLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Loading Animation
            SizedBox(
              width: 24,
              height: 24,
              child: Lottie.asset(
                'assets/load.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to CircularProgressIndicator if Lottie fails
                  return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logging In...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              size: 20,
              color: _isPhoneValid ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Text(
              'Continue with Phone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isPhoneValid ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(AuthViewModel authViewModel) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: !authViewModel.isGoogleLoading ? _handleGoogleSignIn : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: authViewModel.isGoogleLoading
              ? Colors.grey.shade200
              : Colors.white,
          foregroundColor: Colors.grey.shade700,
          elevation: 2,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: authViewModel.isGoogleLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Loading Animation
            SizedBox(
              width: 24,
              height: 24,
              child: Lottie.asset(
                'assets/load.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to CircularProgressIndicator if Lottie fails
                  return SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Signing in...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google logo
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://developers.google.com/identity/images/g-logo.png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        'By continuing, you agree to our Terms of Service\nand Privacy Policy',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withAlpha(204),
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _handlePhoneSignIn() async {
    HapticFeedback.lightImpact();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Use the simplified phone sign-in method
    bool success = await authViewModel.signInWithPhoneSimple(_phoneController.text.trim());

    if (success) {
      // Navigate directly to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (authViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }



  void _handleGoogleSignIn() async {
    HapticFeedback.lightImpact();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    bool success = await authViewModel.signInWithGoogle();

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (authViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
