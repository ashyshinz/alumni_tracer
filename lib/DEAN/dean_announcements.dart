import 'package:flutter/material.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            const Text(
              "Announcements",
              style: TextStyle(color: Color(0xFF420031), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("View department-related announcements and events", 
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),

            // --- READ-ONLY ACCESS BANNER ---
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

            // --- ANNOUNCEMENT CARDS LIST ---
            _buildAnnouncementCard(
              tag: "Event",
              tagColor: Colors.blue,
              date: "January 15, 2026",
              title: "Alumni Networking Event 2026",
              content: "Join us for our annual networking event featuring industry leaders and recent graduates. Register now!",
            ),
            _buildAnnouncementCard(
              tag: "Important",
              tagColor: Colors.red,
              date: "January 10, 2026",
              title: "Department Achievement Award",
              content: "Our department has been recognized for excellence in alumni placement rates.",
            ),
            _buildAnnouncementCard(
              tag: "Event",
              tagColor: Colors.blue,
              date: "January 05, 2026",
              title: "Career Fair Schedule",
              content: "The upcoming career fair will be held on March 15, 2026. All alumni are welcome to participate.",
            ),
            _buildAnnouncementCard(
              tag: "General",
              tagColor: Colors.grey,
              date: "December 20, 2025",
              title: "Alumni Directory Update",
              content: "Please remind alumni to update their profiles for accurate tracking.",
            ),
            const SizedBox(height: 25),

            // --- SUMMARY COUNTERS ---
            Row(
              children: [
                _buildSummaryCounter("Total Announcements", "5", const Color(0xFF420031)),
                const SizedBox(width: 15),
                _buildSummaryCounter("Events", "2", Colors.blue),
                const SizedBox(width: 15),
                _buildSummaryCounter("Important Notices", "2", Colors.red),
              ],
            ),
            const SizedBox(height: 25),

            // --- LATEST UPDATES TIMELINE ---
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
                  const Text("Latest Updates", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF420031))),
                  const SizedBox(height: 20),
                  _buildUpdateItem("Alumni Networking Event 2026", "Jan 15, 2026", "Event"),
                  _buildUpdateItem("Department Achievement Award", "Jan 10, 2026", "Important"),
                  _buildUpdateItem("Career Fair Schedule", "Jan 05, 2026", "Event"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Announcement Card UI
  Widget _buildAnnouncementCard({required String tag, required Color tagColor, required String date, required String title, required String content}) {
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
                decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Icon(Icons.sell_outlined, size: 12, color: tagColor),
                    const SizedBox(width: 4),
                    Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF420031))),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        ],
      ),
    );
  }

  // Numeric Summary Box
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
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: valueColor, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Update Item for Bottom Section
  Widget _buildUpdateItem(String title, String date, String tag) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFFC69C6D)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
            child: Text(tag, style: const TextStyle(color: Colors.grey, fontSize: 9)),
          ),
        ],
      ),
    );
  }
}