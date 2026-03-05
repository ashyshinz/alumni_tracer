import 'package:flutter/material.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Return a Container to fit into your main sidebar shell
    return Container(
      color: const Color(0xFFF3F3F3),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PAGE TITLE
            const Text(
              "Verification Status",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
            ),
            const Text(
              "Track your account verification progress",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // 2. OVERALL STATUS BANNER (ORANGE)
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFE67E22), // Matching the orange design
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Overall Verification Status", 
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                          Text("Pending", 
                            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.access_time, color: Colors.white, size: 48),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.5, // 50% completed as per image
                      minHeight: 12,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("2 of 4 steps completed", style: TextStyle(color: Colors.white, fontSize: 13)),
                      Text("50%", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. INFORMATIONAL ALERT BOX
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE), // Light blue background
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue, size: 24),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Verification Progress", 
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                        const SizedBox(height: 5),
                        Text(
                          "Your documents are being reviewed by our verification team. This process typically takes 2-3 business days. You'll receive an email notification once the review is complete.",
                          style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. VERIFICATION REQUIREMENTS LIST
            const Text("Verification Requirements", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            _buildRequirementCard("Profile Information", "Basic profile information verified", true),
            const SizedBox(height: 15),
            _buildRequirementCard("Profile Information", "Basic profile information verified", true),
            const SizedBox(height: 15),
            _buildRequirementCard("Profile Information", "Basic profile information verified", true),
            const SizedBox(height: 15),
            _buildRequirementCard("Profile Information", "Basic profile information verified", true),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget for Requirement Cards ---
  Widget _buildRequirementCard(String title, String subtitle, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFD4EFDF), // Light green background from design
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.green.shade800)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Completed", 
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}