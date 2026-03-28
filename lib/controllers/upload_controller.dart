import 'package:get/get.dart';

// ─── Data model for a single checklist item ───────────────────────────────────
class ChecklistItem {
  final String label;
  final String icon;   // emoji icon
  final bool   passed;
  const ChecklistItem({
    required this.label,
    required this.icon,
    required this.passed,
  });
}

// ─── Mock result returned by "AI" ─────────────────────────────────────────────
class AnalysisResult {
  final String name;
  final String visaType;
  final String expiryDate;
  final String nationality;
  final String documentNumber;
  final List<ChecklistItem> checklist;

  const AnalysisResult({
    required this.name,
    required this.visaType,
    required this.expiryDate,
    required this.nationality,
    required this.documentNumber,
    required this.checklist,
  });
}

// ─── View state enum ──────────────────────────────────────────────────────────
enum UploadState { idle, loading, result }

// ─── UploadController (GetxController — used via GetBuilder) ─────────────────
class UploadController extends GetxController {
  // ── Observable state ──
  UploadState state     = UploadState.idle;
  String?     fileName;
  String?     brpFileName;
  AnalysisResult? result;

  // ── Analytics counters (fake live data) ──
  int docsProcessed = 1247;
  int errorsDetected = 156;
  int accuracyRate  = 92;

  // ── Active sidebar index ──
  int activeNavIndex = 0;

  // ── Loading message cycle ──
  final List<String> _loadingMessages = [
    'Analyzing document with AI…',
    'Extracting visa metadata…',
    'Cross-referencing expiry fields…',
    'Validating biometric markers…',
    'Building compliance checklist…',
  ];
  int _msgIndex = 0;
  String get loadingMessage => _loadingMessages[_msgIndex % _loadingMessages.length];

  // ── Hover state for upload card ──
  bool isDragHovering = false;

  // ─── Public Methods ───────────────────────────────────────────────────────

  /// Called when user picks a passport/ID file
  void setPassportFile(String name) {
    fileName = name;
    update(); // GetBuilder rebuild
  }

  /// Called when user picks a BRP card file
  void setBrpFile(String name) {
    brpFileName = name;
    update();
  }

  /// Called when user taps "Analyze" or drops a file
  Future<void> uploadFile() async {
    if (fileName == null) return;

    state    = UploadState.loading;
    _msgIndex = 0;
    update();

    // Cycle loading messages every 500ms
    for (int i = 0; i < 4; i++) {
      await Future.delayed(const Duration(milliseconds: 450));
      _msgIndex++;
      update();
    }

    // Simulate remaining delay → total ~2s
    await Future.delayed(const Duration(milliseconds: 600));

    simulateProcessing();
  }

  /// Builds the hardcoded mock AI response
  void simulateProcessing() {
    // Update fake analytics
    docsProcessed++;
    errorsDetected++;

    // Hardcoded mock response
    result = const AnalysisResult(
      name:           'John Doe',
      visaType:       'Student Visa',
      expiryDate:     '12 Sep 2026',
      nationality:    'Indian',
      documentNumber: 'P7842953K',
      checklist: [
        ChecklistItem(label: 'Passport',            icon: '🛂', passed: true),
        ChecklistItem(label: 'CAS Letter',          icon: '🎓', passed: false),
        ChecklistItem(label: 'Bank Statement',      icon: '🏦', passed: false),
        ChecklistItem(label: 'Accommodation Letter',icon: '🏠', passed: true),
        ChecklistItem(label: 'TB Test Certificate', icon: '🩺', passed: false),
      ],
    );

    state = UploadState.result;
    update();
  }

  /// Reset everything for a new check
  void reset() {
    state       = UploadState.idle;
    fileName    = null;
    brpFileName = null;
    result      = null;
    _msgIndex   = 0;
    update();
  }

  /// Sidebar navigation
  void setNavIndex(int index) {
    activeNavIndex = index;
    update();
  }

  /// Drag hover state
  void setDragHover(bool val) {
    isDragHovering = val;
    update();
  }
}
