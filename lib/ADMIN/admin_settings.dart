import 'package:flutter/material.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  // Track which section is currently selected
  String _activeSection = "System Settings";

  void _updateSection(String section) {
    setState(() {
      _activeSection = section;
    });
  }

  void _showSaveFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$_activeSection updated successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("System Settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Configure system preferences and integrations", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SETTINGS NAVIGATION SIDEBAR
              Container(
                width: 280,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    _settingsNavItem(Icons.settings_outlined, "System Settings"),
                    _settingsNavItem(Icons.email_outlined, "Email Configuration"),
                    _settingsNavItem(Icons.notifications_none, "Notification"),
                    _settingsNavItem(Icons.data_usage, "Database Backup"),
                    _settingsNavItem(Icons.lock_outline, "Security"),
                  ],
                ),
              ),
              const SizedBox(width: 25),

              // 2. DYNAMIC CONFIGURATION FORM
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: _buildActiveForm(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- FORM BUILDER LOGIC ---

  Widget _buildActiveForm() {
    switch (_activeSection) {
      case "Email Configuration":
        return _formWrapper(
          icon: Icons.email_outlined,
          title: "Email SMTP Settings",
          children: [
            _buildTextField("SMTP Host", "smtp.gmail.com"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextField("SMTP Port", "587")),
                const SizedBox(width: 20),
                Expanded(child: _buildTextField("Encryption", "TLS")),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField("Sender Name", "Alumni Admin"),
          ],
        );
      case "Notification":
        return _formWrapper(
          icon: Icons.notifications_none,
          title: "Push & Email Notifications",
          children: [
            _buildSwitchTile("New Alumni Registration", true),
            _buildSwitchTile("Event Reminders", true),
            _buildSwitchTile("Document Verification Alerts", false),
            _buildSwitchTile("System Maintenance Notices", true),
          ],
        );
      case "Database Backup":
        return _formWrapper(
          icon: Icons.storage_rounded,
          title: "Backup & Restore",
          children: [
            const Text("Last Backup: January 20, 2026", style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            _buildDropdownField("Backup Frequency", "Daily"),
            const SizedBox(height: 20),
            _buildTextField("Cloud Storage Provider", "Google Drive"),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text("Run Manual Backup Now"),
            )
          ],
        );
      case "Security":
        return _formWrapper(
          icon: Icons.security_outlined,
          title: "System Security Settings",
          children: [
            _buildSwitchTile("Two-Factor Authentication (Required)", true),
            const SizedBox(height: 10),
            _buildDropdownField("Session Timeout", "30 Minutes"),
            const SizedBox(height: 20),
            _buildTextField("Password Expiry (Days)", "90"),
            const SizedBox(height: 20),
            _buildTextField("Allowed IP Access (Whitelist)", "192.168.1.*"),
          ],
        );
      default: // System Settings
        return _formWrapper(
          icon: Icons.language_outlined,
          title: "System Configuration",
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField("Site Name", "Alumni Management System")),
                const SizedBox(width: 20),
                Expanded(child: _buildTextField("Site URL", "https://alumni.edu")),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextField("Admin Email", "admin@alumni.edu")),
                const SizedBox(width: 20),
                Expanded(child: _buildDropdownField("Timezone", "Eastern Time (ET)")),
              ],
            ),
            const SizedBox(height: 20),
            _buildDropdownField("Language", "English"),
          ],
        );
    }
  }

  // Wrapper to keep the icon, title, and "Save" button consistent
  Widget _formWrapper({required IconData icon, required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF2D31FA)),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 30),
        ...children,
        const SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D31FA),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _showSaveFeedback,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --- HELPER COMPONENTS ---

  Widget _settingsNavItem(IconData icon, String label) {
    bool isActive = _activeSection == label;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF0F2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? const Color(0xFF2D31FA) : Colors.black87, size: 20),
        title: Text(label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF2D31FA) : Colors.black87,
            )),
        onTap: () => _updateSection(label),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black12)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: [DropdownMenuItem(value: value, child: Text(value))],
            onChanged: (v) {},
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool val) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: val,
      onChanged: (v) {},
      contentPadding: EdgeInsets.zero,
      activeThumbColor: const Color(0xFF2D31FA),
    );
  }
}