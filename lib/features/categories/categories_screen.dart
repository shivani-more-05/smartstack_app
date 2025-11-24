import 'package:flutter/material.dart';
import 'package:smartstack_app/services/clip_service.dart';
import 'package:smartstack_app/features/clips/models/clip.dart';
import 'package:smartstack_app/features/clips/screens/clip_detail_screen.dart';

const Color deepLilac = Color(0xFF8C6EC7);
const Color lavenderMist = Color(0xFFECE6F6);

class CategoriesScreen extends StatelessWidget {
  final String categoryName;

  const CategoriesScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    print("📌 OPENED CATEGORY SCREEN: $categoryName");

    return Scaffold(
      backgroundColor: lavenderMist,
      appBar: AppBar(
        backgroundColor: deepLilac,
        title: Text(
          categoryName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<Clip>>(
        stream: clipService.streamClipsByCategory(categoryName),
        builder: (context, snapshot) {
          print(
              "🔥 STREAM STATUS for $categoryName => ${snapshot.connectionState}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            print("❌ No data returned for $categoryName");
            return const Center(child: Text("Loading..."));
          }

          final clips = snapshot.data!;
          print("📥 Retrieved ${clips.length} clips for $categoryName");

          if (clips.isEmpty) {
            return const Center(
              child: Text(
                "No clips in this category",
                style: TextStyle(
                  fontSize: 18,
                  color: deepLilac,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          // --- SHOW CLIPS ---
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final clip = clips[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    clip.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: deepLilac,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: clip.timestamp != null
                      ? Text(
                          clip.timestamp!.toLocal().toString().substring(0, 16),
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClipDetailScreen(clip: clip),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
