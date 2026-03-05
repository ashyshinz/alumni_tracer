import 'package:flutter/material.dart';

class SurveysPage extends StatelessWidget {
  const SurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Text(
              "Surveys & Tracer Studies",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF420031)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your feedback helps the institution improve its curriculum and support services.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),

            // Active Surveys List
            Expanded(
              child: ListView(
                children: [
                  _sectionHeader("Active Surveys"),
                  _buildSurveyCard(
                    context,
                    title: "2026 Graduate Tracer Study",
                    description: "Required for all 2020-2025 graduates to track employment status.",
                    deadline: "Ends in 12 days",
                    isMandatory: true,
                    status: "Pending",
                  ),
                  _buildSurveyCard(
                    context,
                    title: "Curriculum Relevancy Survey",
                    description: "How well did your degree prepare you for your current role?",
                    deadline: "Ends in 5 days",
                    isMandatory: false,
                    status: "Pending",
                  ),
                  const SizedBox(height: 20),
                  _sectionHeader("Completed"),
                  _buildSurveyCard(
                    context,
                    title: "Alumni Engagement Feedback",
                    description: "Feedback on the last alumni reunion event.",
                    deadline: "Submitted on Jan 15, 2026",
                    isMandatory: false,
                    status: "Completed",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildSurveyCard(
    BuildContext context, {
    required String title,
    required String description,
    required String deadline,
    required bool isMandatory,
    required String status,
  }) {
    bool isCompleted = status == "Completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green[50] : const Color(0xFF420031).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_outline : Icons.assignment_outlined,
              color: isCompleted ? Colors.green : const Color(0xFF420031),
            ),
          ),
          const SizedBox(width: 20),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 10),
                    if (isMandatory && !isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(4)),
                        child: const Text("MANDATORY", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 8),
                Text(deadline, style: TextStyle(color: isCompleted ? Colors.grey : Colors.orange[800], fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Action Button
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: isCompleted ? null : () => _openTracerForm(context, title),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? Colors.grey[200] : const Color(0xFFC69C6D),
              foregroundColor: isCompleted ? Colors.grey : Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(isCompleted ? "View Response" : "Start Now"),
          ),
        ],
      ),
    );
  }

  void _openTracerForm(BuildContext context, String surveyTitle) {
    // You would navigate to a detailed form page here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Opening $surveyTitle...")),
    );
  }
}