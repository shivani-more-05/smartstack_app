import 'package:flutter/material.dart';
import 'package:smartstack_app/features/clips/models/clip.dart';
import 'package:smartstack_app/services/clip_service.dart';

class ClipDetailScreen extends StatefulWidget {
  final Clip clip;

  const ClipDetailScreen({super.key, required this.clip});

  @override
  State<ClipDetailScreen> createState() => _ClipDetailScreenState();
}

class _ClipDetailScreenState extends State<ClipDetailScreen> {
  late TextEditingController controller;
  late String category;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.clip.content);
    category = widget.clip.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clip.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              clipService.deleteClip(widget.clip.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Edit clip",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await clipService.updateClip(
                  clipId: widget.clip.id,
                  content: controller.text.trim(),
                  category: category,
                );
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
