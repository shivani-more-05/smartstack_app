import 'package:cloud_firestore/cloud_firestore.dart';

class Clip {
  final String id;
  final String content;
  final String category;
  final DateTime? timestamp;

  Clip({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
  });

  factory Clip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Clip(
      id: doc.id,
      content: data['content'] ?? '',
      category: data['category'] ?? 'Others',
      timestamp: data['timestamp'] == null
          ? null
          : (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
