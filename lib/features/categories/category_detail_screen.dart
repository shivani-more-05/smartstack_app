import 'package:flutter/material.dart';
import 'package:smartstack_app/services/clip_service.dart';
import 'package:smartstack_app/features/clips/screens/clip_detail_screen.dart';
import 'package:smartstack_app/features/clips/models/clip.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: StreamBuilder<List<Clip>>(
        stream: clipService.streamClipsByCategory(categoryName),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final clips = snapshot.data!;

          if (clips.isEmpty) {
            return const Center(child: Text("No clips found"));
          }

          return ListView.builder(
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final clip = clips[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    clip.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(clip.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => clipService.deleteClip(clip.id),
                  ),
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
