import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
              "Settings",
              style: TextStyle(color: Color(0xFF420031), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("Manage your account and access preferences", 
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 25),

            // --- PROFILE INFORMATION SECTION ---
            _buildSectionCard(
              title: "Profile Information",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Color(0xFF420031),
                        child: Text("DD", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Dr. Dean Anderson", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF420031))),
                          const Text("Department Dean - Computer Science", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.shield_outlined, size: 14, color: Colors.orange.shade700),
                              const SizedBox(width: 5),
                              Text("Role: Department Dean (Read-Only Access)", style: TextStyle(color: Colors.orange.shade700, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Full Name", "Dr. Dean Anderson", Icons.person_outline)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Email Address", "dean.anderson@university.edu", Icons.email_outlined)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Phone Number", "+1 (555) 123-4567", Icons.phone_outlined)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Department", "Computer Science", Icons.business_outlined)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF420031),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Save Profile Changes", style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- CHANGE PASSWORD SECTION ---
            _buildSectionCard(
              title: "Change Password",
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: Colors.grey),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password Security", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                      Text("Last changed 45 days ago", style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF420031))),
                    child: const Text("Change Password", style: TextStyle(color: Color(0xFF420031))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- ROLE-BASED ACCESS CONTROL ---
            _buildSectionCard(
              title: "Role-Based Access Control",
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Dean Access Level", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF420031))),
                    const SizedBox(height: 15),
                    _buildAccessItem(Icons.check_circle, "View all department alumni records", Colors.green),
                    _buildAccessItem(Icons.check_circle, "Access career and employment data", Colors.green),
                    _buildAccessItem(Icons.check_circle, "Generate analytics and reports", Colors.green),
                    _buildAccessItem(Icons.check_circle, "View announcements and events", Colors.green),
                    _buildAccessItem(Icons.cancel, "Edit or delete alumni data (restricted)", Colors.red),
                    _buildAccessItem(Icons.cancel, "Approve document verifications (restricted)", Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- SYSTEM INFORMATION ---
            _buildSectionCard(
              title: "System Information",
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 3,
                children: [
                  _buildSystemData("Account Created", "January 10, 2020"),
                  _buildSystemData("Last Login", "January 20, 2026"),
                  _buildSystemData("Account Status", "Active", isStatus: true),
                  _buildSystemData("User ID", "DEAN-CS-001"),
                  _buildSystemData("System Version", "v2.5.1"),
                  _buildSystemData("Support Email", "support@university.edu"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Wrapper
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF420031))),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // Input Field Placeholder
  Widget _buildTextField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: value,
            prefixIcon: Icon(icon, size: 18),
            filled: true,
            fillColor: const Color(0xFFF1F3F4),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  // Access Level Item
  Widget _buildAccessItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  // System Data Grid Item
  Widget _buildSystemData(String label, String value, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isStatus ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }
}