import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Loading states
  bool _isLoading = false;
  bool _isPhoneLoading = false;
  bool _isGoogleLoading = false;

  // Error handling
  String? _errorMessage;

  // Current user
  User? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  bool get isPhoneLoading => _isPhoneLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  // Constructor
  AuthViewModel() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // **SIMPLIFIED PHONE NUMBER SIGN-IN (NO OTP)**
  Future<bool> signInWithPhoneSimple(String phoneNumber) async {
    try {
      _isPhoneLoading = true;
      _errorMessage = null;
      notifyListeners();

      String formattedPhoneNumber = '+91$phoneNumber';

      // Check if user already exists in Firestore
      DocumentSnapshot existingUser = await _firestore
          .collection('users')
          .doc(phoneNumber)
          .get();

      if (existingUser.exists) {
        // User exists, sign them in anonymously and link data
        UserCredential result = await _auth.signInAnonymously();

        if (result.user != null) {
          // Update existing user document with new UID
          await _firestore.collection('users').doc(phoneNumber).update({
            'uid': result.user!.uid,
            'updatedAt': FieldValue.serverTimestamp(),
            'isActive': true,
            'lastLoginTime': FieldValue.serverTimestamp(),
          });

          // Save user data locally
          await _savePhoneUserLocally(result.user!, phoneNumber);

          _isPhoneLoading = false;
          notifyListeners();
          return true;
        }
      } else {
        // New user, create account
        UserCredential result = await _auth.signInAnonymously();

        if (result.user != null) {
          // Create new user document
          await _createPhoneUserDocument(result.user!, phoneNumber);

          // Save user data locally
          await _savePhoneUserLocally(result.user!, phoneNumber);

          _isPhoneLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isPhoneLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isPhoneLoading = false;
      _errorMessage = 'Phone sign-in failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // **SAVE PHONE USER DATA LOCALLY**
  Future<void> _savePhoneUserLocally(User user, String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('uid', user.uid);
      await prefs.setString('phoneNumber', '+91$phoneNumber');
      await prefs.setString('authMethod', 'phone');
      await prefs.setString('displayName', 'User ${phoneNumber.substring(6)}');
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('lastLoginTime', DateTime.now().toIso8601String());

      debugPrint('Phone user data saved locally');
    } catch (e) {
      debugPrint('Failed to save phone user data locally: $e');
    }
  }

  // **GET USER DISPLAY NAME**
  Future<String> getUserDisplayName() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // First try to get from SharedPreferences (faster)
      String? localDisplayName = prefs.getString('displayName');
      if (localDisplayName != null && localDisplayName.isNotEmpty) {
        return localDisplayName;
      }

      // If not found locally, try to get from current Firebase user
      if (_currentUser != null && _currentUser!.displayName != null) {
        return _currentUser!.displayName!;
      }

      // If still not found, try to get from Firestore
      DocumentSnapshot? userDoc = await getUserData();
      if (userDoc != null && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['displayName'] ?? 'Beautiful';
      }

      return 'Beautiful'; // Fallback
    } catch (e) {
      debugPrint('Error getting user display name: $e');
      return 'Beautiful'; // Fallback
    }
  }

// **GET USER DATA FROM FIRESTORE**
  Future<DocumentSnapshot?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? authMethod = prefs.getString('authMethod');

      if (authMethod == 'google') {
        String? email = prefs.getString('email');
        if (email != null) {
          return await _firestore.collection('users').doc(email).get();
        }
      } else if (authMethod == 'phone') {
        String? phoneNumber = prefs.getString('phoneNumber');
        if (phoneNumber != null) {
          String docId = phoneNumber.replaceFirst('+91', '');
          return await _firestore.collection('users').doc(docId).get();
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }



  // **CREATE PHONE USER DOCUMENT IN FIRESTORE**
  Future<void> _createPhoneUserDocument(User user, String phoneNumber) async {
    try {
      // Create user document with phone number as document ID
      await _firestore.collection('users').doc(phoneNumber).set({
        'uid': user.uid,
        'phoneNumber': '+91$phoneNumber',
        'authMethod': 'phone',
        'displayName': 'User', // Last 4 digits
        'email': null,
        'photoURL': null,
        'isPhoneVerified': true, // Since we're accepting without OTP
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastLoginTime': FieldValue.serverTimestamp(),
        'isActive': true,
        'profile': {
          'firstName': '',
          'lastName': '',
          'dateOfBirth': null,
          'weddingDate': null,
          'partner': null,
          'location': null,
        },
        'weddingData': {
          'venue': null,
          'budget': null,
          'guestCount': null,
          'checklist': [],
        },
        'settings': {
          'notifications': true,
          'theme': 'light',
          'language': 'en',
        },
      });

      debugPrint('Phone user document created: $phoneNumber');
    } catch (e) {
      debugPrint('Error creating phone user document: $e');
      throw e; // Re-throw to handle in calling method
    }
  }

  // **GOOGLE OAUTH AUTHENTICATION** (unchanged)
  Future<bool> signInWithGoogle() async {
    try {
      _isGoogleLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _isGoogleLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        await _createGoogleUserDocument(result.user!, googleUser);
        await _saveGoogleUserLocally(result.user!);
        _isGoogleLoading = false;
        notifyListeners();
        return true;
      }

      _isGoogleLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isGoogleLoading = false;
      _errorMessage = 'Google sign-in failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // **SAVE GOOGLE USER DATA LOCALLY**
  Future<void> _saveGoogleUserLocally(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('uid', user.uid);
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('authMethod', 'google');
      await prefs.setString('displayName', user.displayName ?? '');
      await prefs.setString('photoURL', user.photoURL ?? '');
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('lastLoginTime', DateTime.now().toIso8601String());

      debugPrint('Google user data saved locally');
    } catch (e) {
      debugPrint('Failed to save Google user data locally: $e');
    }
  }

  // **CREATE GOOGLE USER DOCUMENT IN FIRESTORE**
  Future<void> _createGoogleUserDocument(User user, GoogleSignInAccount googleUser) async {
    try {
      if (user.email == null) return;

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.email!)
          .get();

      if (!userDoc.exists) {
        List<String> nameParts = (user.displayName ?? '').split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        await _firestore.collection('users').doc(user.email!).set({
          'uid': user.uid,
          'email': user.email,
          'authMethod': 'google',
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL,
          'phoneNumber': user.phoneNumber,
          'emailVerified': user.emailVerified,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLoginTime': FieldValue.serverTimestamp(),
          'isActive': true,
          'profile': {
            'firstName': firstName,
            'lastName': lastName,
            'dateOfBirth': null,
            'weddingDate': null,
            'partner': null,
            'location': null,
          },
          'weddingData': {
            'venue': null,
            'budget': null,
            'guestCount': null,
            'checklist': [],
          },
          'googleData': {
            'id': googleUser.id,
            'serverAuthCode': googleUser.serverAuthCode,
          },
          'settings': {
            'notifications': true,
            'theme': 'light',
            'language': 'en',
          },
        });

        debugPrint('Google user document created: ${user.email}');
      } else {
        await _firestore.collection('users').doc(user.email!).update({
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL,
          'emailVerified': user.emailVerified,
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLoginTime': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }
    } catch (e) {
      debugPrint('Error creating Google user document: $e');
      throw e;
    }
  }

  // **CHECK IF USER IS LOGGED IN**
  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final firebaseUser = _auth.currentUser;

      bool hasFirebaseUser = firebaseUser != null;
      bool hasLocalData = prefs.getBool('isLoggedIn') == true &&
          prefs.getString('uid') != null;

      return hasFirebaseUser || hasLocalData;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return false;
    }
  }

  // **SIGN OUT**
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _clearUserLocally();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign out failed: ${e.toString()}';
      notifyListeners();
    }
  }

  // **CLEAR USER DATA FROM SHARED PREFERENCES**
  Future<void> _clearUserLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('uid');
      await prefs.remove('email');
      await prefs.remove('phoneNumber');
      await prefs.remove('displayName');
      await prefs.remove('photoURL');
      await prefs.remove('authMethod');
      await prefs.remove('lastLoginTime');
      await prefs.setBool('isLoggedIn', false);

      debugPrint('User data cleared from SharedPreferences');
    } catch (e) {
      debugPrint('Failed to clear user data locally: $e');
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
