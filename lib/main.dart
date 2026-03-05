import 'package:flutter/material.dart';

// --- Page Imports ---
import 'login_page.dart';
import 'ALUMNI/dashboard_page.dart';
import 'ALUMNI/profile_page.dart';
import 'ALUMNI/employment_page.dart';
import 'ALUMNI/career_timeline_page.dart';
import 'ALUMNI/documents_page.dart';
import 'ALUMNI/verification_page.dart';
import 'ALUMNI/announcements_page.dart';
import 'settings_page.dart';
import 'ALUMNI/surveys_page.dart'; 

// --- Shell Imports ---
import 'DEAN/dean_main.dart';

void main() => runApp(const AlumniPortalApp());

class AlumniPortalApp extends StatelessWidget {
  const AlumniPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alumni Portal',
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        // Placeholder routes for named navigation if needed
        '/dashboard': (context) => const MainShell(),
        '/dean_dashboard': (context) => const DeanMainShell(), 
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final bool _isLoggedIn = false; 

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const MainShell() : const LoginPage();
  }
}

// --- ALUMNI MAIN SHELL ---
class MainShell extends StatefulWidget {
  final String userName;
  final String userRole;
  final String userEmail; // Added Email field

  const MainShell({
    super.key, 
    this.userName = "Alumni User", 
    this.userRole = "Alumni Member",
    this.userEmail = "alumni@jmc.edu.ph", // Default placeholder
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  late List<Widget> _pages; // Use late to initialize with widget data

  @override
  void initState() {
    super.initState();
    // Initialize pages here so we can pass the dynamic data to ProfilePage
    _pages = [
      const DashboardPage(),         // Index 0
      ProfilePage(
        initialName: widget.userName, 
        initialEmail: widget.userEmail
      ),                              // Index 1 (Linked to Database)
      const EmploymentPage(),         // Index 2
      const CareerTimelinePage(),    // Index 3
      const DocumentsPage(),         // Index 4
      const VerificationPage(),      // Index 5
      const SurveysPage(),           // Index 6 
      const AnnouncementsPage(),     // Index 7
      const SettingsPage(),          // Index 8
    ];
  }

  final List<Map<String, String>> _notifications = [
    {"title": "Profile Verified", "msg": "Your profile is now 100% verified.", "time": "2m ago"},
    {"title": "Tracer Study", "msg": "New survey: Graduate Success 2026.", "time": "1h ago"},
    {"title": "Document Update", "msg": "Your Diploma copy was approved.", "time": "5h ago"},
  ];

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
              width: 40, height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Color(0xFF8E2DE2), size: 28),
                  const SizedBox(width: 12),
                  const Text("AI Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Hello ${widget.userName}! How can I help you navigate the portal today?", 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(color: Colors.grey)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Ask me anything...",
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAIChat,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 60, height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: const Icon(Icons.psychology, color: Colors.white, size: 32),
        ),
      ),
      body: Row(
        children: [
          // 1. SIDEBAR
          Container(
            width: 260,
            decoration: const BoxDecoration(color: Color(0xFF420031)),
            child: Column(
              children: [
                _buildSidebarHeader(),
                const Divider(color: Colors.white12, indent: 20, endIndent: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      _navItem(Icons.grid_view_rounded, "Dashboard", 0),
                      _navItem(Icons.person_outline, "Profile", 1),
                      _navItem(Icons.work_outline, "Employment", 2),
                      _navItem(Icons.trending_up, "Career Timeline", 3),
                      _navItem(Icons.description_outlined, "Documents", 4),
                      _navItem(Icons.verified_user_outlined, "Verification", 5),
                      _navItem(Icons.assignment_outlined, "Surveys & Tracer", 6),
                      _navItem(Icons.campaign_outlined, "Announcements", 7),
                      _navItem(Icons.settings_outlined, "Settings", 8),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                _navItem(Icons.logout, "Logout", -1),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 2. MAIN CONTENT AREA
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
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

  Widget _buildSidebarHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.school, color: Color(0xFF420031), size: 20),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Alumni Portal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                // Synchronized with login response
                Text(widget.userRole, style: const TextStyle(color: Colors.white70, fontSize: 11), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                  hintText: "Search alumni, jobs, or announcements...",
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Notification Bell
          PopupMenuButton<int>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, color: Color(0xFF420031), size: 28),
                Positioned(
                  right: -2, top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFB58D3D), shape: BoxShape.circle),
                    child: Text("${_notifications.length}", style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(enabled: false, child: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold))),
              const PopupMenuDivider(),
              ..._notifications.map((n) => PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(n['msg']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Divider(),
                  ],
                ),
              )),
            ],
          ),
          const SizedBox(width: 25),
          // Dynamic User Profile
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Synchronized with database name
                  Text(widget.userName, style: const TextStyle(color: Color(0xFF420031), fontWeight: FontWeight.bold, fontSize: 14)),
                  // Synchronized with role
                  Text(widget.userRole, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF420031),
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : "?", 
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFC69C6D) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -2),
        leading: Icon(icon, color: Colors.white, size: 22),
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
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
        title: const Text("Confirm Logout"),
        content: const Text("Do you want to leave the Alumni Portal?"),
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