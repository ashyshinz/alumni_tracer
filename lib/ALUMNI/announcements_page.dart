import 'package:flutter/material.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  // 1. DYNAMIC DATA LIST
  final List<Map<String, dynamic>> _announcements = [
    {
      "id": 1,
      "title": "Alumni Reunion 2025 - Save the Date!",
      "content": "Join us for our biggest reunion yet! Mark your calendars for June 15-17, 2025. More details coming soon.",
      "postedBy": "Alumni Relations Office",
      "date": "Nov 5, 2024",
      "tag": "Event",
      "tagColor": const Color(0xFFD1C4E9),
      "tagTextColor": const Color(0xFF5E35B1),
      "isPinned": false,
    },
    {
      "id": 2,
      "title": "New Alumni Benefit: Career Services",
      "content": "We are excited to announce free career counseling services for all alumni. Book your session today through the portal.",
      "postedBy": "Career Services",
      "date": "Nov 3, 2024",
      "tag": "Benefit",
      "tagColor": const Color(0xFFC8E6C9),
      "tagTextColor": const Color(0xFF2E7D32),
      "isPinned": false,
    },
    {
      "id": 3,
      "title": "Homecoming Weekend Schedule Released",
      "content": "Check out the full schedule for homecoming weekend including the parade, football game, and alumni mixer.",
      "postedBy": "Events Committee",
      "date": "Nov 1, 2024",
      "tag": "Event",
      "tagColor": const Color(0xFFD1C4E9),
      "tagTextColor": const Color(0xFF5E35B1),
      "isPinned": false,
    },
    {
      "id": 4,
      "title": "Alumni Directory Update",
      "content": "Please update your contact information in the alumni directory to stay connected with your classmates.",
      "postedBy": "Alumni Relations Office",
      "date": "Oct 28, 2024",
      "tag": "Update",
      "tagColor": const Color(0xFFBBDEFB),
      "tagTextColor": const Color(0xFF1565C0),
      "isPinned": false,
    },
    {
      "id": 5,
      "title": "Mentorship Program Launches",
      "content": "Sign up to mentor current students or connect with alumni mentors in your field. Applications open now!",
      "postedBy": "Mentorship Committee",
      "date": "Oct 25, 2024",
      "tag": "Program",
      "tagColor": const Color(0xFFFFF9C4),
      "tagTextColor": const Color(0xFFFBC02D),
      "isPinned": false,
    },
  ];

  // 2. PIN LOGIC
  void _togglePin(int index) {
    setState(() {
      _announcements[index]['isPinned'] = !_announcements[index]['isPinned'];
      
      // Optional: Sort so pinned items stay at the top
      _announcements.sort((a, b) {
        if (b['isPinned'] && !a['isPinned']) return 1;
        if (!b['isPinned'] && a['isPinned']) return -1;
        return 0;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_announcements[index]['isPinned'] ? "Announcement Pinned" : "Announcement Unpinned"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F3F3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Announcements & Events",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const Text(
              "Stay updated with the latest news and upcoming events",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 3. GENERATE TILES FROM LIST
            ...List.generate(_announcements.length, (index) {
              final item = _announcements[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _buildAnnouncementTile(
                  index: index,
                  title: item['title'],
                  content: item['content'],
                  postedBy: item['postedBy'],
                  date: item['date'],
                  tag: item['tag'],
                  tagColor: item['tagColor'],
                  tagTextColor: item['tagTextColor'],
                  isPinned: item['isPinned'],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- Updated Helper Widget ---
  Widget _buildAnnouncementTile({
    required int index,
    required String title,
    required String content,
    required String postedBy,
    required String date,
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required bool isPinned,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isPinned ? Border.all(color: const Color(0xFF673AB7), width: 1) : null, // Highlight pinned
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
            child: const Icon(Icons.campaign_outlined, color: Color(0xFF673AB7), size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: tagTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(content, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("By $postedBy", style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                    Row(
                      children: [
                        Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 10),
                        // FUNCTIONAL PIN BUTTON
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _togglePin(index),
                          icon: Icon(
                            isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            size: 18,
                            color: isPinned ? const Color(0xFF673AB7) : Colors.grey,
                          ),
                          tooltip: isPinned ? "Unpin" : "Pin Announcement",
                        ),
                      ],
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