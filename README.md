# VisaAI – Visa Document Checker AI
### Enterprise Flutter Web + FastAPI Demo

> A high-conversion sales demo for immigration consultants and law firms.  
> **Not a real AI system** — designed to impress with polished UX and simulated AI behaviour.

---

## 📁 Project Structure

```
visa_ai/
├── pubspec.yaml                    # Flutter dependencies
├── backend/
│   ├── main.py                     # FastAPI demo backend
│   └── requirements.txt
└── lib/
    ├── main.dart                   # App entry point + GetX init
    ├── theme/
    │   └── app_colors.dart         # Color palette & text styles
    ├── controllers/
    │   └── upload_controller.dart  # GetxController (GetBuilder state)
    ├── views/
    │   ├── dashboard_view.dart     # Root layout: sidebar + main
    │   ├── sidebar.dart            # Dark sidebar navigation
    │   ├── analytics_cards.dart    # 4 top-row stat cards
    │   ├── upload_section.dart     # Drag & drop upload card
    │   └── result_section.dart     # AI result + checklist
    └── widgets/
        ├── custom_card.dart        # Hoverable card component
        └── checklist_item.dart     # Animated checklist row
```

---

## 🚀 Quick Start

### 1 — Flutter Web Frontend

```bash
# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Build for production
flutter build web --release
```

**Requirements:**
- Flutter SDK ≥ 3.0.0
- Chrome browser (for web)

---

### 2 — FastAPI Backend (optional)

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

API docs at: `http://localhost:8000/docs`

**Test endpoint:**
```bash
curl -X POST "http://localhost:8000/analyze?visa_type=Student" \
  -F "file=@passport.jpg"
```

---

## 🧠 Architecture: GetBuilder Pattern

The app uses **GetX with `GetBuilder`** for all state management — mirroring Flutter's reactive controller pattern.

```dart
// Controller (GetxController)
class UploadController extends GetxController {
  UploadState state = UploadState.idle;
  String?     fileName;
  AnalysisResult? result;

  Future<void> uploadFile() async {
    state = UploadState.loading;
    update(); // triggers GetBuilder rebuild

    await Future.delayed(const Duration(milliseconds: 1800));

    result = AnalysisResult(...);  // hardcoded mock
    state  = UploadState.result;
    update();
  }
}

// View — GetBuilder<UploadController>
GetBuilder<UploadController>(
  builder: (ctrl) => ctrl.state == UploadState.result
    ? ResultCard(result: ctrl.result!)
    : UploadCard(),
)
```

**State flow:**
```
idle → [user uploads file] → loading → [1.8s delay] → result
result → [user taps "New Check"] → idle
```

---

## 🎨 Design System

| Token           | Value                        |
|-----------------|------------------------------|
| Background      | `#F0F4F8`                    |
| Surface (card)  | `#FFFFFF`                    |
| Sidebar bg      | `#0F172A`                    |
| Primary accent  | `#2563EB` → `#7C3AED` grad   |
| Green status    | `#16A34A`                    |
| Red status      | `#DC2626`                    |
| Heading font    | DM Serif Display             |
| Body font       | DM Sans                      |
| Mono font       | JetBrains Mono               |
| Card radius     | 20px                         |

---

## 📊 Mock AI Response

```json
{
  "name": "John Doe",
  "visa_type": "Student Visa",
  "expiry_date": "12 Sep 2026",
  "nationality": "Indian",
  "document_number": "P7842953K",
  "checklist": [
    { "document": "Passport",             "icon": "🛂", "status": true  },
    { "document": "CAS Letter",           "icon": "🎓", "status": false },
    { "document": "Bank Statement",       "icon": "🏦", "status": false },
    { "document": "Accommodation Letter", "icon": "🏠", "status": true  },
    { "document": "TB Test Certificate",  "icon": "🩺", "status": false }
  ]
}
```

---

## ✨ Features

- **Sidebar navigation** — 5 items, active state, hover effects, user avatar
- **Analytics cards** — 4 animated stat cards (docs processed, accuracy, errors, speed)
- **Drag & drop upload** — hover state, file type chips, dual file slots (Passport + BRP)
- **AI loading animation** — spinner + cycling messages + linear progress bar
- **Result panel** — extracted data grid + colour-coded checklist
- **Activity feed** — 5 recent client checks with live status dots
- **Hover effects** — all cards and buttons have smooth hover micro-interactions
- **Fully responsive** — desktop (sidebar), tablet (no sidebar), mobile (stacked)
- **GetBuilder state** — clean separation of controller and view

---

## 📱 Responsiveness

| Breakpoint | Layout               |
|------------|----------------------|
| > 1100px   | Sidebar + 2-col grid |
| 700–1100px | No sidebar + stacked |
| < 700px    | Mobile stacked       |

---

## 🏗 Dependencies

```yaml
get: ^4.6.6              # GetX state management
file_picker: ^8.0.0+1    # File picker for web
flutter_animate: ^4.5.0  # Smooth animations
google_fonts: ^6.2.1     # DM Sans, DM Serif, JetBrains Mono
```

---

> **Sales Demo Notice:** This application contains no real OCR, ML, or document processing.  
> All results are hardcoded mock data designed to demonstrate UI/UX quality.



git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com
git push -f origin main
