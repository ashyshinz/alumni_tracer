import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SurveysPage extends StatefulWidget {
  const SurveysPage({super.key});

  @override
  State<SurveysPage> createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage> {

  List surveys = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSurveys();
  }

  Future<void> fetchSurveys() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:8080/alumni_api/get_surveys.php"),
      );

      if (response.statusCode == 200) {
        setState(() {
          surveys = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching surveys: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Surveys & Tracer Studies",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF420031),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Your feedback helps the institution improve its curriculum and support services.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : surveys.isEmpty
                      ? const Center(child: Text("No surveys available"))
                      : ListView.builder(
                          itemCount: surveys.length,
                          itemBuilder: (context, index) {

                            final survey = surveys[index];

                            bool isCompleted = survey['status'] == "Completed";

                            return _buildSurveyCard(
                              context,
                              title: survey['title'] ?? "",
                              description: survey['description'] ?? "",
                              deadline: "Created: ${survey['date_created']}",
                              isMandatory: survey['status'] == "Active",
                              status: survey['status'],
                            );
                          },
                        ),
            ),
          ],
        ),
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
      ),
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green[50]
                  : const Color(0xFF420031).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check_circle_outline
                  : Icons.assignment_outlined,
              color: isCompleted
                  ? Colors.green
                  : const Color(0xFF420031),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),

                    if (isMandatory && !isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text(
                          "MANDATORY",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),

                const SizedBox(height: 8),

                Text(
                  deadline,
                  style: TextStyle(
                      color: isCompleted
                          ? Colors.grey
                          : Colors.orange[800],
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton(
            onPressed: isCompleted
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Opening $title survey...")),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted
                  ? Colors.grey[200]
                  : const Color(0xFFC69C6D),
              foregroundColor:
                  isCompleted ? Colors.grey : Colors.white,
            ),
            child: Text(isCompleted ? "Completed" : "Start Now"),
          ),
        ],
      ),
    );
  }
}