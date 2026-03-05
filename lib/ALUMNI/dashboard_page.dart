import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // REMOVED: Scaffold, Row, SidebarNavigation, and TopHeader to fix doubling
    return Container(
      color: const Color(0xFFF3F3F3), // The light grey background
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stat Cards Section
            Row(
              children: [
                _statCard("Profile Completion", "65 %", Colors.indigo, isProgress: true),
                const SizedBox(width: 20),
                _statCard("Documents Uploaded", "3/5", Colors.purple),
                const SizedBox(width: 20),
                _statCard("Verification Status", "Pending", Colors.orange),
              ],
            ),
            const SizedBox(height: 25),

            // 2. Purple Progress Banner
            _buildProfileBanner(),
            const SizedBox(height: 20),

            // 3. Status Alert
            _buildStatusAlert(),
            const SizedBox(height: 30),

            // 4. Quick Actions
            const Text("Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const QuickActionsGrid(),

            const SizedBox(height: 30),

            // 5. Announcements Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Announcements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text("View All →", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const AnnouncementCard(),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Methods ---

  Widget _statCard(String title, String value, Color color, {bool isProgress = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            if (isProgress) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.grey[200],
                  color: color,
                  minHeight: 8,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBanner() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF9B59B6), Color(0xFF5B2C6F)]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Complete your Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text("65%",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const Text("Help us serve you better by completing your profile",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 15),
          LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 10),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: Colors.purple),
            child: const Text("Complete Profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusAlert() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFFF9E79F), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 10),
              Text("Verification Status: pending",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF7D6608))),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 5),
            child: Text(
                "Your documents are being reviewed by our team. This usually takes 2-3 business days.",
                style: TextStyle(fontSize: 12, color: Color(0xFF7D6608))),
          ),
          TextButton(
              onPressed: () {},
              child: const Text("View Details",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xFF7D6608))))
        ],
      ),
    );
  }
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _actionItem(Icons.person, "Update Profile", "Keep your information current",
            Colors.blue),
        const SizedBox(width: 15),
        _actionItem(Icons.work, "Update Employment", "Add or update your job info",
            Colors.purple),
        const SizedBox(width: 15),
        _actionItem(Icons.file_upload, "Upload Documents",
            "Submit verification files", Colors.red),
        const SizedBox(width: 15),
        _actionItem(Icons.insights, "Career Timeline", "Track your progress",
            Colors.green),
      ],
    );
  }

  Widget _actionItem(IconData icon, String title, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text("Event",
                    style: TextStyle(color: Colors.white, fontSize: 10)),
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(width: 10),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              SizedBox(width: 5),
              Text("December 15, 2025",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          SizedBox(height: 10),
          Text("Alumni Reunion 2025",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Join us for our annual alumni reunion celebration...",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}