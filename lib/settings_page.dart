import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Track which menu is selected: 0 = Password, 1 = Notifications, 2 = Privacy
  int _selectedIndex = 0;

  // Password Visibility States
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Controllers for password update logic
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  void _updatePassword() {
    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    _currentPassController.clear();
    _newPassController.clear();
    _confirmPassController.clear();
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
              "Settings",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const Text(
              "Manage your account preferences and security",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN: Navigation Menu
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          Icons.lock_outline,
                          "Password And Security",
                          0,
                        ),
                        _buildMenuTile(
                          Icons.notifications_none,
                          "Notifications",
                          1,
                        ),
                        _buildMenuTile(Icons.security_outlined, "Privacy", 2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 25),

                // RIGHT COLUMN: Dynamic Content
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: _buildActiveSection(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Switches between the three sections
  Widget _buildActiveSection() {
    switch (_selectedIndex) {
      case 0:
        return _buildPasswordSection();
      case 1:
        return _buildNotificationsSection();
      case 2:
        return _buildPrivacySection();
      default:
        return _buildPasswordSection();
    }
  }

  // --- SECTION: PASSWORD AND SECURITY ---
  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          Icons.lock_person,
          "Password & Security",
          "Update your password and security settings",
        ),
        const SizedBox(height: 30),
        _buildPasswordField(
          "Current Password",
          _currentPassController,
          _obscureCurrent,
          () {
            setState(() => _obscureCurrent = !_obscureCurrent);
          },
        ),
        const SizedBox(height: 20),
        _buildPasswordField(
          "New Password",
          _newPassController,
          _obscureNew,
          () {
            setState(() => _obscureNew = !_obscureNew);
          },
          hint: "Minimum 6 characters",
        ),
        const SizedBox(height: 20),
        _buildPasswordField(
          "Confirm New Password",
          _confirmPassController,
          _obscureConfirm,
          () {
            setState(() => _obscureConfirm = !_obscureConfirm);
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _updatePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2962FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Update Password"),
        ),
      ],
    );
  }

  // --- SECTION: NOTIFICATIONS ---
  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          Icons.notifications_active,
          "Notifications",
          "Control how you receive alerts",
        ),
        const SizedBox(height: 20),
        SwitchListTile(
          title: const Text("Email Notifications"),
          subtitle: const Text("Receive updates via email"),
          value: true,
          onChanged: (v) {},
        ),
        SwitchListTile(
          title: const Text("Push Notifications"),
          subtitle: const Text("Mobile and desktop alerts"),
          value: false,
          onChanged: (v) {},
        ),
        SwitchListTile(
          title: const Text("Event Reminders"),
          subtitle: const Text("Get notified about upcoming reunions"),
          value: true,
          onChanged: (v) {},
        ),
      ],
    );
  }

  // --- SECTION: PRIVACY ---
  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          Icons.security,
          "Privacy Settings",
          "Manage your data and profile visibility",
        ),
        const SizedBox(height: 20),
        _buildPrivacyOption(
          "Public Profile",
          "Allow others to see your alumni profile",
          true,
        ),
        _buildPrivacyOption(
          "Show Employment",
          "Make your current job visible to classmates",
          false,
        ),
        _buildPrivacyOption(
          "Contact Info",
          "Allow alumni to see your contact details",
          false,
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EAF6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF3F51B5)),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, int index) {
    bool isActive = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyOption(String title, String desc, bool val) {
    return ListTile(
      title: Text(title),
      subtitle: Text(desc),
      trailing: Checkbox(value: val, onChanged: (v) {}),
    );
  }
}
