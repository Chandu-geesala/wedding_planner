# Wedding Planner App 💍✨

## 📱 Demo Video

[![Demo Video](https://img.shields.io/badge/▶-Play%20Demo-brightgreen?style=for-the-badge)](https://drive.google.com/file/d/1KOJDXyPk-tIP8XuVo43Ax3NsSWCyNLOp/view?usp=sharing)


*Click above to watch the 2-3 minute demo video showcasing all features*

---

A beautiful Flutter mobile application designed to help users plan their dream wedding with intuitive features, smooth animations, and modern UI design.

## 📱 Features Implemented

### 🔐 1. User Authentication
- **Phone-based sign-in** without OTP for simplicity
- **Google OAuth integration** with Firebase Authentication
- **Persistent login** with SharedPreferences caching
- **User data storage** in Firebase Firestore

### 🎨 2. Onboarding Flow
- **Animated intro screens** with wedding-themed content
- **Skip intro after completion** stored in SharedPreferences
- **Smooth page transitions** with animated dots and buttons
- **Wedding app branding** with custom animations

### ✅ 3. Wedding Checklist Module
- **Pre-loaded checklist** with common wedding tasks
- **Add, edit, delete tasks** with descriptions and categories
- **Mark tasks as completed** with fast, responsive checkboxes
- **Progress tracking** with circular and linear progress bars
- **Priority levels** (High, Medium, Low) with color-coded chips
- **Task categories** for better organization

### 🏛️ 4. Venue Finder
- **8+ dummy wedding venues** with realistic details and images
- **Smart filtering** by budget and guest capacity using range sliders
- **Venue cards** with gradient designs and professional layout
- **Reset filters** option and results counter
- **Venue selection** with user feedback

### 💰 5. Budget Calculator
- **Interactive budget input** with real-time calculation
- **Animated pie chart** showing budget breakdown
- **5 categories**: Venue (40%), Catering (30%), Photography (15%), Décor (10%), Miscellaneous (5%)
- **Smart currency formatting** (₹2.5L instead of ₹250000)
- **Professional budget display** outside the chart for clarity

### 👥 6. Guest List Management
- **Add guests** with name, phone, email, and RSVP status
- **RSVP tracking**: Attending, Not Attending, Pending
- **Color-coded status badges** and icons
- **Edit and delete guests** with confirmation dialogs
- **Guest statistics** showing counts for each RSVP status
- **Sample guest data** pre-loaded for demonstration

### 🚀 7. Enhanced User Experience
- **Custom splash screen** with wedding branding
- **Navigation logic**: Intro → Auth → Home flow
- **Gradient backgrounds** with wedding theme colors
- **Smooth animations** throughout all pages
- **Responsive design** for different screen sizes
- **Debug banner hidden** for professional appearance

## 🛠️ Technical Implementation

### **Architecture & State Management**
- **Provider pattern** for state management
- **MVVM architecture** with ViewModels
- **Modular code structure** organized by features

### **Firebase Integration**
- **Firebase Authentication** for user management
- **Cloud Firestore** for data storage
- **Real-time data synchronization**
- **Offline support** with local caching

### **UI & Animations**
- **Custom animations** with AnimationController
- **Staggered entrance animations** for smooth loading
- **Interactive elements** with immediate feedback
- **Material Design** with wedding color scheme
- **Lottie animations** for engaging onboarding

## 📦 Dependencies

dependencies:

flutter:

sdk: flutter

provider: ^6.0.5

firebase_auth: ^4.15.3

cloud_firestore: ^4.13.6

google_sign_in: ^6.1.6

shared_preferences: ^2.2.2

lottie: ^2.7.0

url_launcher: ^6.2.1

text

## 🚀 Installation & Setup

1. **Clone the repository**
git clone [your-repo-url]
cd wedding-planner-app

text

2. **Install dependencies**
flutter pub get

text

3. **Add assets**
- Place Lottie animation files in `assets/`
- Add venue images: `ryl.png`, `snst.png`, `hrt.png`
- Add app logo: `logo.png`

4. **Configure Firebase**
- Create Firebase project
- Add `google-services.json` (Android)
- Add `GoogleService-Info.plist` (iOS)
- Enable Authentication and Firestore

5. **Run the app**
flutter run

text

## 📱 App Flow

Splash Screen (3 seconds)

↓

Check: Intro completed?

↓ ↓

No Yes

↓ ↓

Onboarding Check Auth

↓ ↓

Sign In Logged In?

↓ ↓ ↓

Home Screen Yes No

↓ ↓

Home Sign In

text

## 🎯 Assignment Requirements ✅

- ✅ **User Registration/Login** - Phone & Google authentication
- ✅ **Wedding Checklist Module** - Add, edit, mark completed tasks
- ✅ **Hotel/Venue Listing** - 8+ venues with budget & capacity filters
- ✅ **UI & Creativity** - Wedding-themed design with animations
- ✅ **Budget Calculator** (Bonus) - Interactive pie chart with % allocation
- ✅ **Guest List Management** (Bonus) - RSVP tracking system

## 👨‍💻 Developer

**Chandu Geesala**  
Passionate Flutter developer committed to creating beautiful, functional mobile applications.

**Contact:** +91 7731888943

---

*This project demonstrates modern Flutter development practices with a focus on user experience, clean code, and professional design. All assignment requirements have been successfully implemented with additional bonus features.*
