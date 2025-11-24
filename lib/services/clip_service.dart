import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartstack_app/features/clips/models/clip.dart';

class ClipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔥 HARD-CODED UID (the one that actually has your clips)
  final String _userId = "7odIXe6bYLSOhqSG048f9FVVmJf2";

  // -------------------- STREAM ALL CLIPS --------------------
  Stream<List<Clip>> streamAllClips() {
    print("🔥 Fetching all clips for UID = $_userId");

    return _firestore
        .collection("users")
        .doc(_userId)
        .collection("clips")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Clip.fromFirestore(doc)).toList();
    });
  }

  // -------------------- STREAM BY CATEGORY --------------------
  Stream<List<Clip>> streamClipsByCategory(String category) {
    print("📁 Fetching category: $category");

    return _firestore
        .collection("users")
        .doc(_userId)
        .collection("clips")
        .where("category", isEqualTo: category)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Clip.fromFirestore(doc)).toList();
    });
  }

  // -------------------- SAVE NEW CLIP --------------------
  Future<void> saveClip(String content) async {
    final category = detectCategory(content);

    await _firestore.collection("users").doc(_userId).collection("clips").add({
      "content": content,
      "category": category,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // -------------------- UPDATE CLIP --------------------
  Future<void> updateClip({
    required String clipId,
    required String content,
    required String category,
  }) async {
    await _firestore
        .collection("users")
        .doc(_userId)
        .collection("clips")
        .doc(clipId)
        .update({
      "content": content,
      "category": category,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // -------------------- DELETE CLIP --------------------
  Future<void> deleteClip(String clipId) async {
    await _firestore
        .collection("users")
        .doc(_userId)
        .collection("clips")
        .doc(clipId)
        .delete();
  }

  // -------------------- CATEGORY DETECTOR --------------------
  String detectCategory(String text) {
    final t = text.trim();

    final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    if (emailRegex.hasMatch(t)) return "Emails";

    if (t.startsWith("http") ||
        t.contains("www.") ||
        RegExp(r"https?://").hasMatch(t)) {
      return "Links";
    }

    if (t.contains('"') || t.contains("“") || t.contains("”")) {
      return "Quotes";
    }

    if (t.contains("{") ||
        t.contains("}") ||
        t.contains("<") ||
        t.contains(">") ||
        t.contains("(") ||
        t.contains(")") ||
        t.contains("[") ||
        t.contains("]") ||
        t.contains(";") ||
        t.contains("=>")) {
      return "Code";
    }

    final digits = t.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length == 10) return "Phone";

    if (t.length >= 3) return "Notes";

    return "Others";
  }
}

final clipService = ClipService();
