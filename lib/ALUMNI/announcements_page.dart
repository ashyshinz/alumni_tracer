import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {

  List announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {

    try {

      final response = await http.get(
        Uri.parse("http://192.168.137.1:8080/alumni_api/get_announcementsadmin.php"),
      );

      if (response.statusCode == 200) {

        setState(() {
          announcements = jsonDecode(response.body);
          isLoading = false;
        });

      }

    } catch (e) {

      print("Error loading announcements: $e");

      setState(() {
        isLoading = false;
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(0xFFF3F3F3),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Announcements & Events",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const Text(
              "Stay updated with the latest news and upcoming events",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : announcements.isEmpty
                      ? const Center(child: Text("No announcements found"))
                      : ListView.builder(
                          itemCount: announcements.length,
                          itemBuilder: (context, index) {

                            final item = announcements[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: _buildAnnouncementTile(
                                title: item['title'] ?? "",
                                content: item['description'] ?? "",
                                postedBy: item['author'] ?? "Admin",
                                date: item['date_created'] ?? "",
                                tag: item['type'] ?? "Announcement",
                              ),
                            );
                          },
                        ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementTile({
    required String title,
    required String content,
    required String postedBy,
    required String date,
    required String tag,
  }) {

    Color tagColor = const Color(0xFFEDE7F6);
    Color tagTextColor = const Color(0xFF673AB7);

    if (tag == "Event") {
      tagColor = const Color(0xFFD1C4E9);
      tagTextColor = const Color(0xFF5E35B1);
    }

    if (tag == "Update") {
      tagColor = const Color(0xFFBBDEFB);
      tagTextColor = const Color(0xFF1565C0);
    }

    if (tag == "Benefit") {
      tagColor = const Color(0xFFC8E6C9);
      tagTextColor = const Color(0xFF2E7D32);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: Color(0xFF673AB7),
              size: 28,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: tagTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "By $postedBy",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}