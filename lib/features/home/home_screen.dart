import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartstack_app/services/clip_service.dart';
import 'package:smartstack_app/features/clips/models/clip.dart';
import 'package:smartstack_app/features/categories/categories_screen.dart';
import 'package:smartstack_app/features/clips/screens/clip_detail_screen.dart';

const Color lavenderMist = Color(0xFFECE6F6);
const Color deepLilac = Color(0xFF8C6EC7);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  // CATEGORY NAMES MUST MATCH FIRESTORE EXACTLY
  final List<Map<String, dynamic>> categories = [
    {"label": "Links", "icon": Icons.link},
    {"label": "Emails", "icon": Icons.email},
    {"label": "Notes", "icon": Icons.note},
    {"label": "Quotes", "icon": Icons.format_quote},
    {"label": "Code", "icon": Icons.code},
    {"label": "Phone", "icon": Icons.phone},
    {"label": "Others", "icon": Icons.folder_open},
  ];

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? "User";

    return Scaffold(
      backgroundColor: lavenderMist,
      floatingActionButton: FloatingActionButton(
        backgroundColor: deepLilac,
        onPressed: _saveFromClipboard,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: deepLilac,
        title: const Text("SmartStack", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Welcome back, $userName 👋",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: deepLilac,
            ),
          ),

          const SizedBox(height: 15),

          // SEARCH BAR
          TextField(
            decoration: InputDecoration(
              hintText: "Search clips...",
              prefixIcon: const Icon(Icons.search, color: deepLilac),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (val) => setState(() => searchQuery = val),
          ),

          const SizedBox(height: 25),

          // CATEGORY SECTION
          const Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: deepLilac,
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoriesScreen(categoryName: item['label']),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: deepLilac.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item["icon"], color: deepLilac, size: 28),
                      const SizedBox(height: 10),
                      Text(
                        item["label"], // FIXED!!
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: deepLilac,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          const Text(
            "Recent Clips",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: deepLilac,
            ),
          ),

          const SizedBox(height: 12),

          StreamBuilder<List<Clip>>(
            stream: clipService.streamAllClips(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final clips = snap.data!;
              if (clips.isEmpty) {
                return const Text("No clips found.");
              }

              final filtered = searchQuery.isEmpty
                  ? clips
                  : clips
                      .where((c) => c.content
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();

              return Column(
                children: filtered.map((clip) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        clip.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(clip.category),
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
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveFromClipboard() async {
    final data = await Clipboard.getData("text/plain");
    if (data?.text == null || data!.text!.trim().isEmpty) return;

    await clipService.saveClip(data.text!.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Clip Saved!")),
    );
  }
}
