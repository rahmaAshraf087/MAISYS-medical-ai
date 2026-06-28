<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=00B4D8&height=200&section=header&text=MAISYS&fontSize=80&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Medical%20AI%20System%20for%20Trusted%20Health%20Guidance&descAlignY=55&descSize=18" width="100%"/>

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)](https://mongodb.com)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)

[![License](https://img.shields.io/badge/License-MIT-00B4D8?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-00B4D8?style=flat-square)](https://flutter.dev)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-00B4D8?style=flat-square)](#)
[![Grade](https://img.shields.io/badge/Graduation%20Grade-A%2B-gold?style=flat-square)](#)

<br/>

> **AI-powered medical platform** featuring a medical chatbot, drug interaction checker, lab test analyzer, research paper assistant, and intelligent healthcare tools — built with **Flutter** for iOS & Android.

<br/>

[![Demo Video](https://img.shields.io/badge/▶%20Watch%20Full%20Demo-Google%20Drive-00B4D8?style=for-the-badge&logo=googledrive&logoColor=white)](https://drive.google.com/drive/folders/1c9OPs6rCOVtZjDE9kkt9Dui43MN-W1DK?usp=sharing)
[![Screenshots](https://img.shields.io/badge/📸%20View%20Screenshots-Google%20Drive-34A853?style=for-the-badge&logo=googledrive&logoColor=white)](https://drive.google.com/drive/folders/1c9OPs6rCOVtZjDE9kkt9Dui43MN-W1DK?usp=sharing)
[![LinkedIn](https://img.shields.io/badge/Rahma%20Ashraf-LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rahma-ashraf-28b219279/)

</div>

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Features](#-features)
- [AI Tools](#-ai-tools)
- [Screens & Demo](#-screens--demo)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [My Role](#-my-role)
- [Contact](#-contact)

---

## 🧠 Overview

**MAISYS** (Medical AI System for Trusted Health Guidance) is a graduation project built at **Benha University — Faculty of Computer and Artificial Intelligence**, Department of Scientific Computing.

The platform provides **five AI-powered medical tools** accessible through a cross-platform mobile application that supports both **Arabic and English**, with full RTL layout, dark/light theming, and accessibility features.

> ⚠️ MAISYS is designed for **educational purposes only** and does not replace professional medical advice.

---

## ⚙️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Mobile App** | Flutter 3.x / Dart |
| **State Management** | BLoC / Cubit Pattern |
| **Backend API** | Node.js + Express.js |
| **Database** | MongoDB + Mongoose |
| **AI Engine** | Groq API — Llama 3.3 70B |
| **Authentication** | JWT + bcrypt |
| **Email Service** | Nodemailer + Gmail SMTP |
| **File Handling** | Multer + base64 |
| **Distribution** | Firebase App Distribution |
| **Local Storage** | SharedPreferences |
| **HTTP Client** | Dart `http` package |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                    │
│  ┌──────────┐  ┌──────────┐  ┌────────────────────────┐ │
│  │ThemeCubit│  │LangCubit │  │AccessibilityCubit      │ │
│  └──────────┘  └──────────┘  └────────────────────────┘ │
│              BLoC State Management                       │
│              ApiService (Centralized HTTP)               │
└───────────────────────┬─────────────────────────────────┘
                        │ REST API (JWT Auth)
┌───────────────────────▼─────────────────────────────────┐
│                  Node.js Backend                         │
│   Auth │ Chats │ Drug │ Lab │ Research │ Activities      │
│              groqService.js                              │
└───────────────────────┬─────────────────────────────────┘
                        │
          ┌─────────────┴─────────────┐
          ▼                           ▼
┌─────────────────┐       ┌───────────────────┐
│   Groq API      │       │   MongoDB Atlas   │
│ Llama 3.3 70B   │       │  Users │ Chats    │
│                 │       │  Research │ Acts  │
└─────────────────┘       └───────────────────┘
```

---

## ✨ Features

### 🔐 Authentication & Security
- JWT-based signup / login with 7-day token expiry
- bcrypt password hashing (salt rounds: 10)
- **Forgot Password via Email OTP** — Gmail SMTP with 10-minute expiry
- User data isolation — each user only accesses their own data

### 👤 User Profile
- Personal info: name, phone with **country code picker** (full global list), age, gender, blood type
- Medical info: medications, allergies, medical conditions (tag-based input)
- Profile picture — pick from gallery, take photo, or remove
- All data persisted to MongoDB

### 🎨 UI/UX
- **Dark & Light Mode** with persistence
- **Arabic & English** full localization with RTL layout support
- Font switching: Outfit (EN) / IBM Plex Sans Arabic (AR)
- **Adjustable text size** via accessibility slider
- Unified **App Drawer** (right-side) with avatar, name, and navigation
- Consistent **App Header** across all screens

### 💬 Medical AI Chatbot
- Create and manage multiple chat sessions
- **File upload** — attach images, PDFs, or documents to queries
- Persistent chat history with title and first-message preview
- Chat options: **Rename**, **Pin**, **Share** (deep link), **Delete**
- Flexible multi-line text input (expands like ChatGPT)
- Typing indicator during AI processing

### 💊 Drug Interaction Checker
- Check interactions between **up to 5 medications**
- Severity classification: **Low / Moderate / High / Severe**
- Clinical recommendations per interaction
- Overall summary and warnings
- **Language toggle** — response in English or Arabic

### 🧪 Lab Test Analyzer
- Upload lab result image (JPEG, PNG)
- Identifies and interprets individual markers
- Status per marker: **Normal / High / Low / Critical**
- Reference ranges in plain language
- Overall urgency: **Routine / Follow-up / Urgent**
- **Language toggle** — English or Arabic response

### 📄 Research Paper Assistant
- Upload PDF or image (title, authors, journal are **optional**)
- **Summarize** — structured: Background, Methods, Findings, Conclusions
- **Q&A Generation** — 5 key questions and answers from the paper
- **Translation** — full paper content translated (EN ↔ AR)
- **OCR Text Extraction** — view extracted raw text
- **Chat about the paper** — ask any question in context
- Papers history — previously analyzed papers accessible anytime
- **Language toggle** for all AI outputs

### 🩺 Symptom Checker
- Guided multi-question flow
- Preliminary health guidance based on symptoms

### 📊 Activity History
- Tracks all tool usage with timestamps
- Color-coded icons per tool type

---

## 🤖 AI Tools

| Function | Input | Output |
|----------|-------|--------|
| `getMedicalChatResponse` | Conversation + optional file | Medical response |
| `checkDrugInteractions` | Medications list + language | JSON: severity, description, recommendations |
| `analyzeLabResults` | Lab text/image + language | JSON: markers, status, urgency |
| `summarizeResearchPaper` | Paper text + language | JSON: background, methods, findings |
| `generateResearchQA` | Paper text + language | Array of Q&A pairs |
| `translateResearchPaper` | Full paper + target language | Translated text |
| `getResearchChatResponse` | Paper context + question | Contextual AI answer |

---

## 📱 Screens & Demo

<div align="center">

[![Watch Demo](https://img.shields.io/badge/▶%20Watch%20Full%20App%20Demo-Click%20Here-00B4D8?style=for-the-badge)](https://drive.google.com/drive/folders/1c9OPs6rCOVtZjDE9kkt9Dui43MN-W1DK?usp=sharing)

[![View Screenshots](https://img.shields.io/badge/📸%20All%20Screenshots-Google%20Drive-34A853?style=for-the-badge)](https://drive.google.com/drive/folders/1c9OPs6rCOVtZjDE9kkt9Dui43MN-W1DK?usp=sharing)

</div>

| Screen | Description |
|--------|-------------|
| Splash + Onboarding | 4-page feature introduction |
| Login / Sign Up | JWT auth with full validation |
| Home Dashboard | Tab navigation — Tools & Activity |
| Medical AI Chatbot | Multi-session chat with file upload |
| Drug Interaction | Medication input + severity results |
| Lab Test Analyzer | Image upload + marker breakdown |
| Research Assistant | Upload → Summarize / Q&A / Translate / Chat |
| User Profile | Full medical profile with picture |
| Settings | Theme toggle + text size slider |
| App Drawer | User avatar, name, navigation |

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry + MultiBlocProvider
├── cubit/
│   ├── theme_cubit/                   # Dark/Light mode
│   ├── language_cubit/                # EN/AR switching
│   └── accessibility_cubit/           # Text scale
├── screens/
│   ├── login.dart
│   ├── sign_up.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   ├── forgot_password_screen.dart
│   └── reset_password_screen.dart
├── overviews/
│   ├── overviewscreen.dart
│   ├── medicaltoolsscreen.dart
│   └── activityscreen.dart
├── medical_tools/
│   ├── chatscreen/                    # Chatbot
│   ├── drug_interaction/              # Drug checker
│   ├── lab_test/                      # Lab analyzer
│   ├── research_assistant/            # Research tools
│   └── symptom_checker/               # Symptom flow
├── services/
│   └── api_service.dart               # Centralized HTTP client
├── widgets/
│   ├── app_drawer.dart                # Global drawer
│   └── app_header.dart                # Global header
└── theme/
    ├── color_manager.dart
    ├── style_helper.dart
    └── app_theme.dart
```

---

## 🚀 Getting Started

### Prerequisites

```bash
Flutter SDK >= 3.0.0
Dart >= 3.0.0
Node.js >= 18.x
MongoDB
```

### Installation

```bash
# Clone the repository
git clone https://github.com/rahmaAshraf087/MAISYS-medical-ai.git
cd MAISYS-medical-ai

# Install Flutter dependencies
flutter pub get

# Configure API endpoint
# In lib/services/api_service.dart:
# static const String baseUrl = 'http://YOUR_IP:5000/api';

# Run the app
flutter run
```

### Backend Setup

```bash
cd maisys-backend
npm install

# Create .env file
cp .env.example .env
# Fill in: MONGODB_URI, JWT_SECRET, GROQ_API_KEY, EMAIL_USER, EMAIL_PASS

npm run dev
```

### Environment Variables

```env
MONGODB_URI=mongodb://localhost:27017/maisys_db
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d
GROQ_API_KEY=your-groq-api-key
EMAIL_USER=your-gmail@gmail.com
EMAIL_PASS=your-app-password
```

---

## 👩‍💻 My Role

I was the **sole Mobile Application Developer** on the MAISYS team, responsible for:

- ✅ Designed and built the complete Flutter app architecture using **BLoC pattern**
- ✅ Implemented **30+ screens** with dark/light theming and Arabic RTL support
- ✅ Integrated all **5 AI-powered medical tools** with the Node.js backend
- ✅ Built the complete **JWT authentication flow** including OTP password reset
- ✅ Developed the **centralized ApiService** handling all HTTP communication
- ✅ Implemented full **bilingual localization** (EN/AR) with font switching
- ✅ Designed unified **AppDrawer + AppHeader** components used across all screens
- ✅ Managed **Firebase App Distribution** for team testing and deployment

---

## 📬 Contact

<div align="center">

[![LinkedIn](https://img.shields.io/badge/Rahma%20Ashraf%20Fadl-LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rahma-ashraf-28b219279/)
[![GitHub](https://img.shields.io/badge/rahmaAshraf087-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rahmaAshraf087)

</div>

---

<div align="center">

**Benha University · Faculty of Computer & Artificial Intelligence · Scientific Computing · 2025/2026**

Supervised by **Dr. Doaa Lotfy**

<img src="https://capsule-render.vercel.app/api?type=waving&color=00B4D8&height=100&section=footer" width="100%"/>

</div>
