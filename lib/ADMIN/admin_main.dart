import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'admin_adminusers.dart';
import 'admin_alumnimanagement.dart';
import 'admin_announcements.dart';
import 'admin_employment.dart';
import 'admin_settings.dart';
import 'admin_verification.dart';

class AdminMainShell extends StatefulWidget {
  // Gidugangan og parameters para sa dynamic naming
  final String adminName;
  final String adminRole;

  const AdminMainShell({
    super.key, 
    this.adminName = "System Admin", // Default value kung wala pay data
    this.adminRole = "Superuser Access",
  });

  @override
  State<AdminMainShell> createState() => _AdminMainShellState();
}

class _AdminMainShellState extends State<AdminMainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardPage(),
    const AlumniManagementPage(),
    const EmploymentAnalyticsPage(),
    const VerificationQueuePage(),
    const AnnouncementsPage(),
    const AdminUsersPage(),
    const SystemSettingsPage(),
  ];

  // --- AI ASSISTANT MODAL ---
  void _showAIChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Color(0xFFB58D3D)),
                  const SizedBox(width: 10),
                  const Text("Admin AI Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Ask me for system reports or user analytics.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search records via AI...",
                  suffixIcon: const Icon(Icons.send, color: Color(0xFF420031)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _showAIChat,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFB58D3D), Color(0xFF420031)], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
            ],
          ),
          child: const Icon(Icons.psychology, color: Colors.white, size: 30),
        ),
      ),

      body: Row(
        children: [
          // 1. SIDEBAR (Maroon)
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: Color(0xFF420031),
            ),
            child: Column(
              children: [
                _buildAdminHeader(),
                const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _navItem(Icons.grid_view_rounded, "DashBoard", 0),
                      _navItem(Icons.people_outline, "Alumni Management", 1),
                      _navItem(Icons.bar_chart, "Employment Analytics", 2),
                      _navItem(Icons.verified_user_outlined, "Verification Queue", 3),
                      _navItem(Icons.campaign_outlined, "Announcements", 4),
                      _navItem(Icons.admin_panel_settings_outlined, "Users", 5),
                      _navItem(Icons.settings_outlined, "Settings", 6),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                _navItem(Icons.logout, "Logout", -1),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 2. MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(), // Mao ni ang Header
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SIDEBAR HEADER ---
  Widget _buildAdminHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(Icons.admin_panel_settings, color: Color(0xFF420031), size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Admin Portal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Management System", style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // --- TOP HEADER (DYNAMIC) ---
  Widget _buildTopHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 400,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                hintText: "Search for records, users, or logs...",
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none, color: Color(0xFF420031), size: 24),
          const SizedBox(width: 25),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.adminName, // DYNAMIC NAME
                    style: const TextStyle(color: Color(0xFF420031), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    widget.adminRole, // DYNAMIC ROLE
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF420031), width: 1.5),
                ),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFFB58D3D),
                  child: Text(
                    widget.adminName.isNotEmpty ? widget.adminName[0].toUpperCase() : "?",
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- NAV ITEM ---
  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFB58D3D) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -3),
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        onTap: () {
          if (index == -1) {
            _showLogoutDialog();
          } else {
            setState(() => _selectedIndex = index);
          }
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Admin Logout"),
        content: const Text("Ensure all administrative tasks are saved. Logout now?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}