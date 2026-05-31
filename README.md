# 🏥 MAISYS - Medical AI System for Trusted Health Guidance

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.19.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.1.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android Studio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)
![Bloc](https://img.shields.io/badge/BLoC-State_Management-blueviolet?style=for-the-badge)

**An intelligent medical mobile application powered by AI and LLM models**  
*Graduation Project - Faculty of Computers and Artificial Intelligence, Benha University*

[📱 Features](#-features) • [🛠️ Installation](#️-installation-guide) • [▶️ Run Project](#️-how-to-run) • [📂 Structure](#-project-structure) • [👥 Team](#-team)

</div>

---

## 📖 About The Project

**MAISYS** (Medical AI System) is a comprehensive medical assistance application designed to revolutionize patient care through artificial intelligence. The app provides trusted health guidance through AI-powered tools including symptom checking, drug interaction analysis, lab result interpretation, and research paper assistance.

This project represents our graduation project for the academic year **2025/2026**, combining modern mobile development practices with AI-powered healthcare solutions to create an accessible and user-friendly medical assistant that works seamlessly with a web platform.

### 🎯 Project Vision
- Democratize access to medical information
- Empower patients to monitor their health conditions
- Provide instant, AI-powered medical guidance (powered by Groq AI - Llama 3.3)
- Create a seamless healthcare experience across mobile and web platforms
- Support bilingual users (English & Arabic) with proper localization

---

## ✨ Features

### 🔐 Authentication System
- **Sign Up**: Complete user registration with email and password
- **Login**: Secure JWT-based authentication
- **Auto-Login**: Automatic session restoration on app restart
- **Secure Token Management**: JWT tokens stored locally with SharedPreferences

### 🩺 Medical AI Tools

#### 1. Medical Chatbot
- AI-powered conversational medical assistant
- Ask questions about symptoms, conditions, and treatments
- Responses include citations from verified medical sources
- Chat history with search and filter capabilities
- Long-press context menu (Rename, Archive, Delete)

#### 2. Symptom Checker
- Multi-step questionnaire (6 questions)
    - Primary symptom selection
    - Duration assessment
    - Severity rating (1-10 scale)
    - Additional symptoms
    - Medical history
    - Demographics
- **Emergency Detection**: Redirects to Emergency Screen for critical symptoms
- **Insufficient Info Handling**: Clear messaging when AI cannot provide safe response

#### 3. Drug Interaction Checker
- Analyze interactions between medications (up to 5 drugs)
- Severity ratings: LOW, MODERATE, HIGH, SEVERE
- Detailed interaction mechanisms
- Evidence-based recommendations
- Important warnings section

#### 4. Lab Test Explainer
- **Upload Options**:
    - PDF reports
    - Photo gallery images
    - Camera scan (real-time)
- **AI Analysis**:
    - Marker extraction (name, value, unit, status)
    - Normal range comparison
    - Urgency assessment (ROUTINE/FOLLOW-UP/URGENT)
    - Plain language explanations
- **Test Categories**: Complete Blood Count (CBC), Metabolic Panel, etc.

#### 5. Research Assistant
- **Paper Management**:
    - Upload medical papers (PDF/DOCX)
    - Search papers by topic or keywords
    - Recent papers history
- **AI-Powered Analysis**:
    - **Summarization**: Structured summaries (Background, Methods, Key Findings, Conclusions)
    - **Translation**: English ↔ Arabic full paper translation
    - **OCR**: Text extraction from scanned pages/images
    - **Q&A Generation**: Auto-generated questions and answers about the paper
    - **Chat**: Ask specific questions about the paper content
- **Download Options**: Download summaries and Q&A sets

### 🏠 Dashboard & Overview
- Quick Actions: Medical Chatbot, Drug Checker, Lab Test Explainer
- Recent Activity tracking with Resume buttons
- Tab navigation: Overview, Medical Tools, Activity
- Medical disclaimer and footer on all screens

### 🌍 User Experience Features

#### Bilingual Support (English & Arabic)
- **Languages**: Full English and Arabic support
- **Fonts**:
    - English: Outfit (Regular, SemiBold, Bold)
    - Arabic: IBM Plex Sans Arabic (Regular, SemiBold, Bold)
- **RTL Support**: Proper right-to-left layout for Arabic
- **Language Toggle**: Easy switching between languages
- **Persistent Settings**: Language preference saved locally

#### Theme Modes
- **Dark Mode** (Default):
    - Background: `#0A1628`
    - Container: `#1A2332`
    - Primary Blue: `#00B4D8`
- **Light Mode**:
    - Background: `#F5F8FA`
    - Container: `#FFFFFF`
    - Primary Blue: `#0096C7`
    - Text: `#1A2332` (primary), `#64748B` (secondary)
- **Theme Toggle**: Switch themes from Login/Signup or Settings
- **Persistent Settings**: Theme preference saved locally

#### Accessibility Features
- **High Contrast Mode**:
    - Black/White color scheme
    - Enhanced border visibility
    - Cyan primary color for better visibility
- **Large Text**:
    - 1.3x text scaling factor
    - Applies to all text throughout the app
- **Reduce Motion**:
    - Disables animations for users sensitive to motion
    - Configurable per user preference
- **All accessibility settings persist across app restarts**

### ⚙️ Settings & Profile

#### Settings Screen
- Language selection (English/Arabic)
- Theme mode (Light/Dark)
- Notifications (Coming Soon)
- Accessibility options (High Contrast, Large Text, Reduce Motion)
- About MAISYS (Version, Description)

#### Profile Screen
- **Personal Information**:
    - Full Name
    - Age
    - Gender (Male/Female/Other)
    - Blood Type (A+, A-, B+, B-, AB+, AB-, O+, O-)
- **Medical Information**:
    - Chronic Conditions (Diabetes, Hypertension, Asthma, Heart Disease, Pregnancy)
    - Current Medications (chip-based input)
    - Allergies
- **Privacy Controls**:
    - Local data storage only
    - Delete all stored data option
    - No third-party sharing
- **Save Changes**: Update profile with backend sync

### 📜 Legal & Safety

#### Terms & Policy Screen
- **Medical Disclaimer**: Educational purposes only, not for diagnosis
- **Privacy Policy**: How user data is handled
- **AI Limitations**: Understanding AI capabilities and boundaries
- **Data Sources**: Transparency about medical information sources
- **User Responsibilities**: Guidelines for safe app usage

#### Emergency Screen
- Triggered by Symptom Checker for critical symptoms
- **Call Emergency Services** button (opens phone dialer)
- While waiting tips:
    - Stay calm
    - Have someone with you
    - Gather medical information
    - Unlock door for help
- Clear disclaimer about app limitations

#### Insufficient Info Screen
- Shown when AI lacks reliable information
- Reasons why (specialized expertise needed, complex interactions, etc.)
- What you can do (consult professional, rephrase question, etc.)
- Options to ask another question or return to dashboard

---

## 🏗️ Architecture & Tech Stack

### Frontend Framework
- **Flutter**: `>=3.19.0` - Cross-platform mobile development
- **Dart**: `>=3.1.0 <4.0.0` - Programming language

### State Management
- **flutter_bloc**: `^8.1.3` - BLoC/Cubit pattern for state management
- **equatable**: `^2.0.5` - Value equality for state comparison

### Backend Integration
- **http**: `^1.1.0` - HTTP client for REST API calls
- **Backend**: Node.js with Groq AI (Llama 3.3 70B)
- **Authentication**: JWT token-based
- **Base URL**: `http://<YOUR_LOCAL_IP>:5000/api`

### Local Storage & Persistence
- **shared_preferences**: `^2.2.2` - Local key-value storage
    - JWT tokens
    - User preferences (theme, language, accessibility)
    - User info cache

### File & Media Handling
- **image_picker**: `^1.0.4` - Camera and gallery image selection
- **file_picker**: `^6.1.1` - PDF and document selection

### Utilities
- **url_launcher**: `^6.2.1` - Open URLs and phone dialer
- **cupertino_icons**: `^1.0.2` - iOS-style icons

### Development Tools
- **Android Studio** - Primary IDE
- **VS Code** - Alternative lightweight editor
- **flutter_lints**: `^2.0.0` - Dart linting rules
- **Android Emulator** - Testing and debugging

### Custom Architecture
```
lib/
├── cubit/                    # State Management
│   ├── theme_cubit/         # Dark/Light mode state
│   ├── language_cubit/      # English/Arabic state
│   └── accessibility_cubit/ # Accessibility settings state
├── services/                 # Backend integration
│   └── api_service.dart     # All API endpoints
├── screens/                  # All UI screens (30+ screens)
├── widgets/                  # Reusable components
│   ├── footer_widget.dart
│   ├── medical_disclaimer_widget.dart
│   ├── theme_toggle_widget.dart
│   ├── language_toggle_widget.dart
│   └── ... (more reusable widgets)
├── theme/                    # App theming
│   ├── app_theme.dart       # Light/Dark theme definitions
│   ├── color_manager.dart   # Color constants
│   └── style_helper.dart    # Text styles
└── customs/                  # Custom form fields
```

---

## 📋 Prerequisites

### Required Software

1. **Flutter SDK** (3.19.0 or higher)
    - 📹 [Installation Guide for Flutter SDK](https://youtu.be/VOfsxFSb3Fs?si=6TDDrrPf7RQ5qS7K)
    - Verify: `flutter --version`

2. **Android Studio** (Latest stable)
    - 📹 [Installation Guide for Android Studio](https://youtu.be/wYVWrlxcnNU?si=1XjKryImyy6l_FXd)
    - Required for Android development and emulator
    - Install Flutter and Dart plugins

3. **Git** (for version control)
    - Download: https://git-scm.com/downloads

4. **Visual Studio Code** (Optional)
    - 📹 [Installation Guide for VS Code](https://youtu.be/nSL0jTyJ-_k?si=OQgunP6XTnXOw1Zr)
    - Lightweight alternative to Android Studio
    - Install Flutter and Dart extensions

5. **Java Development Kit (JDK)** - JDK 11 or higher
    - Usually comes with Android Studio
    - Download: https://www.oracle.com/java/technologies/downloads/

### System Requirements

#### Windows
- Windows 10 or later (64-bit)
- Disk Space: 3 GB minimum (10 GB recommended)
- RAM: 8 GB minimum (16 GB recommended)
- Processor: Intel i5 or equivalent (i7 recommended)

#### macOS
- macOS 10.14 (Mojave) or later
- Disk Space: 3 GB minimum
- RAM: 8 GB minimum (16 GB recommended)
- Apple Silicon (M1/M2) or Intel processor

#### Linux
- 64-bit Ubuntu 20.04 LTS or later
- Disk Space: 3 GB minimum
- RAM: 8 GB minimum (16 GB recommended)

### Network Requirements
- Stable internet connection for:
    - Downloading dependencies
    - Backend API communication
    - AI model requests

---

## 🚀 Installation Guide

### Step 1: Install Required Software

Follow the video tutorials linked above to install:
1. ✅ Flutter SDK
2. ✅ Android Studio
3. ✅ VS Code (optional)
4. ✅ Git

### Step 2: Verify Flutter Installation

Open terminal/command prompt and run:
```bash
flutter doctor
```

Expected output should show:
- ✅ Flutter (Channel stable, 3.19.0 or higher)
- ✅ Android toolchain - develop for Android devices
- ✅ Android Studio
- ✅ Connected device or emulator

Fix any issues indicated by ❌ or ⚠️ before proceeding.

### Step 3: Set Up Android Emulator

**In Android Studio:**
1. Go to `Tools` → `Device Manager`
2. Click `Create Device`
3. Select a device (e.g., Pixel 6 or Pixel 7)
4. Select a system image (API 33 or 34 recommended)
5. Click `Finish`
6. Start the emulator

**Verify emulator:**
```bash
flutter devices
# Should show your emulator in the list
```

### Step 4: Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/maisys-mobile.git
cd maisys-mobile
```

### Step 5: Install Dependencies
```bash
flutter pub get
```

This downloads all packages from `pubspec.yaml`.

### Step 6: Add Required Assets

Ensure these assets are in place:

**Fonts:** (Download and place in `assets/fonts/`)
- Outfit: Regular, SemiBold, Bold
- IBM Plex Sans Arabic: Regular, SemiBold, Bold

**Logo:**
- `assets/svgs/appbar_logo/WhiteLogo.png`

### Step 7: Configure Backend

Open `lib/services/api_service.dart` and update:
```dart
static const String baseUrl = 'http://YOUR_BACKEND_IP:5000/api';
```

Replace `YOUR_BACKEND_IP` with your actual backend server IP address.

For local development:
- Android Emulator: Use `10.0.2.2` (points to host machine's localhost)
- Physical Device: Use your computer's local IP (e.g., `192.168.1.100`)

---

## ▶️ How to Run

### Option 1: Using Command Line
```bash
# Check available devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d <device_id>

# Run in release mode (optimized)
flutter run --release
```

### Option 2: Using Android Studio

1. Open project in Android Studio
2. Wait for Gradle sync to complete
3. Select device/emulator from dropdown (top toolbar)
4. Click **Run** button (▶️) or press `Shift + F10`
5. App will build and launch

### Option 3: Using VS Code

1. Open project in VS Code
2. Open `main.dart`
3. Press `F5` or go to `Run` → `Start Debugging`
4. Select target device from popup
5. App will build and launch

### Hot Reload & Hot Restart

During development:
- **Hot Reload**: Press `r` in terminal or click ⚡ in IDE (fast UI updates)
- **Hot Restart**: Press `R` in terminal or click 🔄 in IDE (full restart)

### Troubleshooting

**Build issues:**
```bash
flutter clean
flutter pub get
flutter run
```

**Gradle issues:**
```bash
cd android
./gradlew clean
cd ..
flutter run
```

**Detailed logs:**
```bash
flutter run -v
```

---

## 📂 Project Structure
```
maisys-mobile/
│
├── lib/                          # Main application code
│   ├── main.dart                 # App entry point with BLoC providers
│   │
│   ├── cubit/                    # State Management (BLoC/Cubit)
│   │   ├── theme_cubit/         # Dark/Light mode state
│   │   │   ├── theme_cubit.dart
│   │   │   └── theme_state.dart
│   │   ├── language_cubit/      # Language switching state
│   │   │   ├── language_cubit.dart
│   │   │   └── language_state.dart
│   │   └── accessibility_cubit/ # Accessibility settings
│   │       ├── accessibility_cubit.dart
│   │       └── accessibility_state.dart
│   │
│   ├── screens/                  # All application screens (30+)
│   │   ├── splash_screen.dart         # Splash with auto-login
│   │   ├── welcome_screens/           # Onboarding (4 screens)
│   │   ├── login.dart                 # Login screen
│   │   ├── sign_up.dart               # Signup screen
│   │   ├── overview_screen.dart       # Main dashboard
│   │   ├── medical_tools_screen.dart  # Tools grid
│   │   ├── activity_screen.dart       # Activity history
│   │   ├── pre_chat_screen.dart       # Chat history
│   │   ├── chat_screen.dart           # AI chat interface
│   │   │
│   │   ├── symptom_checker_question1_screen.dart  # Symptom Q1
│   │   ├── symptom_checker_question2_screen.dart  # Symptom Q2
│   │   ├── symptom_checker_question3_screen.dart  # Symptom Q3
│   │   │
│   │   ├── drug_interaction_screen.dart           # Drug input
│   │   ├── drug_interaction_result_screen.dart    # Drug results
│   │   │
│   │   ├── lab_test_upload_screen.dart            # Lab upload
│   │   ├── lab_test_processing_screen.dart        # Lab processing
│   │   ├── lab_test_result_screen.dart            # Lab results
│   │   │
│   │   ├── research_assistant_upload_screen.dart  # Paper upload
│   │   ├── research_assistant_tools_screen.dart   # Paper tools
│   │   ├── research_assistant_chat_screen.dart    # Paper chat
│   │   ├── research_assistant_summary_screen.dart # Summarization
│   │   ├── research_assistant_translation_screen.dart # Translation
│   │   ├── research_assistant_ocr_screen.dart     # OCR
│   │   ├── research_assistant_qna_screen.dart     # Q&A
│   │   │
│   │   ├── settings_screen.dart       # Settings
│   │   ├── profile_screen.dart        # User profile
│   │   ├── terms_policy_screen.dart   # Legal info
│   │   ├── emergency_screen.dart      # Emergency alert
│   │   └── insufficient_info_screen.dart # AI limitation
│   │
│   ├── services/                 # Backend API integration
│   │   └── api_service.dart     # All API endpoints
│   │
│   ├── widgets/                  # Reusable UI components
│   │   ├── footer_widget.dart
│   │   ├── medical_disclaimer_widget.dart
│   │   ├── medication_chip.dart
│   │   ├── research_paper_header_widget.dart
│   │   ├── research_paper_card_widget.dart
│   │   ├── theme_toggle_widget.dart
│   │   └── language_toggle_widget.dart
│   │
│   ├── theme/                    # App theming
│   │   ├── app_theme.dart       # Theme definitions
│   │   ├── color_manager.dart   # Color constants
│   │   ├── style_helper.dart    # Text styles
│   │   └── font_weight_manager.dart
│   │
│   └── customs/                  # Custom form widgets
│       └── customtextformfield.dart
│
├── android/                      # Android-specific files
├── ios/                          # iOS-specific files
├── assets/                       # Images, fonts, assets
│   ├── fonts/                   # Outfit & IBM Plex fonts
│   ├── svgs/appbar_logo/        # App logo
│   └── images/                  # Other images
│
├── test/                         # Unit & widget tests
├── pubspec.yaml                  # Dependencies & metadata
├── pubspec.lock                  # Locked dependency versions
├── README.md                     # This file
└── .gitignore                    # Git ignore rules
```

---

## 🔌 Backend API Integration

### API Base URL
```
http://<YOUR_IP>:5000/api
```

### Authentication Endpoints

| Endpoint | Method | Description | Body |
|----------|--------|-------------|------|
| `/auth/login` | POST | User login | `{email, password}` |
| `/auth/signup` | POST | User registration | `{firstName, email, password}` |
| `/auth/me` | GET | Get user profile | Token required |
| `/auth/profile` | PUT | Update profile | `{phone?, medical?}` |
| `/auth/forgot-password` | POST | Request password reset | `{email}` |
| `/auth/verify-code` | POST | Verify OTP | `{email, code}` |
| `/auth/reset-password` | POST | Reset password | `{email, resetToken, newPassword}` |

### Medical Tools Endpoints

| Endpoint | Method | Description | Body |
|----------|--------|-------------|------|
| `/tools/symptom-check` | POST | Analyze symptoms | `{symptoms, duration, severity}` |
| `/tools/drug-check` | POST | Check drug interactions | `{medications: []}` |
| `/tools/lab-explain` | POST | Explain lab results | `{labText}` |

### Research Assistant Endpoints

| Endpoint | Method | Description | Body |
|----------|--------|-------------|------|
| `/tools/research/upload` | POST | Upload paper | Multipart: `file` |
| `/tools/research/search` | POST | Search papers | `{query}` |
| `/tools/research/summarize/:id` | POST | Summarize paper | - |
| `/tools/research/translate/:id` | POST | Translate paper | `{targetLang}` |
| `/tools/research/qa/:id` | POST | Generate Q&A | - |
| `/research-chat/analyze-image` | POST | OCR extraction | Multipart: `file` |

### Dashboard
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/tools/dashboard-stats` | GET | Get user stats |
| `/health` | GET | Server health check |

### Error Responses
All endpoints return consistent error format:
```json
{
  "success": false,
  "message": "Error description"
}
```

### Authentication
Protected endpoints require JWT token in header:
```
Authorization: Bearer <YOUR_JWT_TOKEN>
```

---

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific test file
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

### Testing Checklist
- [ ] Unit tests for Cubits
- [ ] Unit tests for API service
- [ ] Widget tests for screens
- [ ] Widget tests for reusable components
- [ ] Integration tests for user flows
- [ ] Manual testing on physical devices
- [ ] Manual testing on different screen sizes

---

## 📸 Screenshots

*(Screenshots will be added as features are completed)*

### Authentication Flow
- Splash Screen
- Welcome/Onboarding (4 screens)
- Login Screen
- Signup Screen


### Main Features
- Overview Dashboard
- Medical Tools Grid
- Activity History
- Chat Interface

### Medical Tools
- Symptom Checker (3 questions)
- Drug Interaction Checker
- Lab Test Explainer
- Research Assistant

### Settings & Profile
- Settings Screen (Theme, Language, Accessibility)
- Profile Screen (Personal & Medical Info)
- Terms & Policy Screen

### Special Screens
- Emergency Alert
- Insufficient Information

---

### Future Enhancements 🔮 (Post-Graduation)
- [ ] Push notifications
- [ ] Medication reminders
- [ ] Health tracking dashboard
- [ ] Wearable device integration
- [ ] Telemedicine features
- [ ] Multi-language support expansion
- [ ] Forget password flow

---

## 🤝 Contributing

This is an academic graduation project. Contributions are welcome!

### How to Contribute
1. Fork the repository
2. Create feature branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Open Pull Request

### Contribution Guidelines
- Follow Flutter best practices
- Maintain BLoC architecture pattern
- Add tests for new features
- Update documentation
- Follow existing code style

---

## 👥 Team

### Development Team
| Role | Name | Email | GitHub |
|------|------|-------|--------|
| **Mobile Developer** | Rahma Fadl | rahmafadl087@gmail.com | [@RahmaFadl](https://github.com/RahmaFadl) |
| **Project Lead & Backend** | Abdelhady Ali | - | [@Abdelhady-22](https://github.com/Abdelhady-22) |
| **Team Member** | Omar Ahmed | - | - |
| **Team Member** | Ahmed Antar | - | - |
| **Team Member** | Samir Mahmoud | - | - |

### Academic Information
- **Institution**: Faculty of Computers and Artificial Intelligence
- **University**: Benha University
- **Academic Year**: 2025/2026
- **Project Supervisor**: Dr. Doaa Lotfy
- **Project Type**: Graduation Project (Mobile + Web + AI)

---

## 📞 Contact & Support

### Project Links
- **GitHub Repository (Mobile)**: [maisys-mobile](https://github.com/YOUR_USERNAME/maisys-mobile)
- **GitHub Repository (Web)**: [Coming Soon]
- **Backend Repository**: [Coming Soon]
- **Project Email**: rahmafadl087@gmail.com

### Support Channels
For questions, suggestions, or bug reports:
1. Open an issue on GitHub
2. Email: rahmafadl087@gmail.com
3. Submit a pull request with improvements

---

## 📄 License

This project is developed for academic purposes as part of graduation requirements.

**Copyright © 2026 MAISYS Team**  
Faculty of Computers and Artificial Intelligence, Benha University

All rights reserved. This project is intended for educational and portfolio purposes.

---

## ⚠️ Medical Disclaimer

**IMPORTANT: MAISYS provides medical information for educational purposes only.**

### What MAISYS IS:
- ✅ Educational medical information tool
- ✅ Health guidance assistant
- ✅ Medical research helper
- ✅ Symptom awareness tool

### What MAISYS IS NOT:
- ❌ NOT a replacement for professional medical advice
- ❌ NOT for medical diagnoses or treatment recommendations
- ❌ NOT for medical emergencies
- ❌ NOT a licensed medical professional

### Important Guidelines:
- Always consult qualified healthcare professionals for medical decisions
- Do NOT use for medical emergencies - call emergency services immediately
- Information provided may not be complete or applicable to your specific situation
- Drug interaction checks are for reference only
- AI responses are based on training data and may contain errors
- The app cannot perform physical examinations or diagnostic tests

**By using MAISYS, you acknowledge these limitations and agree to use the app responsibly.**

---

## 🙏 Acknowledgments

### Technology & Tools
- **Flutter Team** - Excellent framework and documentation
- **Groq AI** - Llama 3.3 70B model for medical AI
- **Anthropic** - Claude for development assistance
- **Open Source Community** - All package contributors

### Academic Support
- **Dr. Doaa Lotfy** - Project supervisor and guidance
- **Faculty of Computers and AI** - Resources and support
- **Benha University** - Academic institution

### Special Thanks
- Beta testers and early users
- Medical professionals who reviewed content
- Family and friends for support

### Data Sources
- **Peer-reviewed medical journals** - Research and clinical data
- **WHO & CDC Guidelines** - Public health information
- **Medical Databases** - Drug interactions and references
- **Clinical Practice Guidelines** - Medical associations

---

## 📌 Important Notes

### Current Status
- This README reflects the **current state** of the project as of **February 2026**
- All core features are implemented with UI
- Backend integration is in progress
- Real AI responses will replace placeholder data soon

### Known Limitations
- Backend must be running locally for full functionality
- Some features use placeholder data (will be replaced with real AI)
- File uploads not yet connected to backend processing
- Push notifications not yet implemented

### Future Updates
- API configuration will be updated once backend is deployed
- Screenshots will be added as features are finalized
- Performance optimizations ongoing
- Additional documentation will be added

---

<div align="center">

**⭐ If you find this project helpful, please consider giving it a star!**

**Made with ❤️ by MAISYS Team**

*Empowering health through AI*

---

**Project Statistics:**
- 📱 **30+ Screens** | 🎨 **2 Themes** | 🌍 **2 Languages** | ♿ **3 Accessibility Features**
- 🤖 **5 AI Tools** | 🔐 **JWT Auth** | 📊 **BLoC Architecture** | 🎯 **Academic Excellence**

</div>