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
        Uri.parse("http://localhost:8080/alumni_api/get_announcementsadmin.php"),
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

    int total = announcements.length;
    int events = announcements.where((a) => a['tag'] == "Event").length;
    int important = announcements.where((a) => a['tag'] == "Important").length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Announcements",
              style: TextStyle(
                color: Color(0xFF420031),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "View department-related announcements and events",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 20),

            // READ ONLY BANNER
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),

              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "Read-Only Access: You can view all announcements here. To create or modify announcements, please contact the system administrator.",
                      style: TextStyle(color: Colors.blue, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ANNOUNCEMENTS LIST
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: announcements.map((item) {

                      Color tagColor = Colors.grey;

                      if (item['tag'] == "Event") {
                        tagColor = Colors.blue;
                      }

                      if (item['tag'] == "Important") {
                        tagColor = Colors.red;
                      }

                      return _buildAnnouncementCard(
                        tag: item['tag'] ?? "General",
                        tagColor: tagColor,
                        date: item['date_created'] ?? "",
                        title: item['title'] ?? "",
                        content: item['content'] ?? "",
                      );

                    }).toList(),
                  ),

            const SizedBox(height: 25),

            // SUMMARY COUNTERS
            Row(
              children: [

                _buildSummaryCounter(
                  "Total Announcements",
                  total.toString(),
                  const Color(0xFF420031),
                ),

                const SizedBox(width: 15),

                _buildSummaryCounter(
                  "Events",
                  events.toString(),
                  Colors.blue,
                ),

                const SizedBox(width: 15),

                _buildSummaryCounter(
                  "Important Notices",
                  important.toString(),
                  Colors.red,
                ),

              ],
            ),

            const SizedBox(height: 25),

            // LATEST UPDATES
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF8F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Latest Updates",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF420031),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...announcements.take(3).map((item) {

                    return _buildUpdateItem(
                      item['title'] ?? "",
                      item['date_created'] ?? "",
                      item['tag'] ?? "",
                    );

                  }),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ANNOUNCEMENT CARD
  Widget _buildAnnouncementCard({
    required String tag,
    required Color tagColor,
    required String date,
    required String title,
    required String content,
  }) {

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),

                child: Row(
                  children: [

                    Icon(Icons.sell_outlined, size: 12, color: tagColor),
                    const SizedBox(width: 4),

                    Text(
                      tag,
                      style: TextStyle(
                        color: tagColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: Colors.grey.shade400,
              ),

              const SizedBox(width: 4),

              Text(
                date,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),

            ],
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF420031),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            content,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),

        ],
      ),
    );
  }

  // SUMMARY BOX
  Widget _buildSummaryCounter(String label, String value, Color valueColor) {

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),

        child: Column(
          children: [

            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }

  // UPDATE ITEM
  Widget _buildUpdateItem(String title, String date, String tag) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Row(
        children: [

          const Icon(
            Icons.circle,
            size: 8,
            color: Color(0xFFC69C6D),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),

              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 9,
              ),
            ),
          ),

        ],
      ),
    );
  }
}