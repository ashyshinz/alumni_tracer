import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CareerTimelinePage extends StatefulWidget {
  const CareerTimelinePage({super.key});

  @override
  State<CareerTimelinePage> createState() => _CareerTimelinePageState();
}

class _CareerTimelinePageState extends State<CareerTimelinePage> {
  final List<Map<String, dynamic>> _timelineEvents = [
    {
      "icon": Icons.arrow_upward,
      "iconBg": Colors.green.shade800,
      "badge": "Job Change",
      "badgeColor": Colors.blue.shade700,
      "date": "January 2023",
      "title": "Senior Developer",
      "company": "Tech Solutions Inc",
      "desc": "Promoted to senior position, leading a team of 5 developers",
    },
  ];

  // HTTP POST request to PHP backend
  Future<void> _addCareerEventToBackend(Map<String, dynamic> event) async {
    final url = Uri.parse('http://localhost:8080/alumni_api/add_career_event.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': event['title'],
          'company': event['company'],
          'desc': event['desc'],
          'type': event['badge'],
          'date': event['date'],
        }),
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        if (resBody['success'] == true) {
          // Successfully added
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Event added successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${resBody['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final descController = TextEditingController();
    String selectedType = 'Job Change';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Fill up Career Event"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: ['Job Change', 'Promotion', 'Achievement', 'Education']
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => selectedType = val!),
                  decoration: const InputDecoration(labelText: "Event Type"),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title/Position"),
                ),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: "Company or School"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Short Description"),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final newEvent = {
                    "icon": _getIcon(selectedType),
                    "iconBg": _getColor(selectedType),
                    "badge": selectedType,
                    "badgeColor": _getColor(selectedType).withOpacity(0.7),
                    "date": "Present",
                    "title": titleController.text,
                    "company": companyController.text,
                    "desc": descController.text,
                  };

                  // Add to timeline locally
                  setState(() {
                    _timelineEvents.insert(0, newEvent);
                  });

                  // Send to backend
                  await _addCareerEventToBackend(newEvent);

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A0E2E),
                foregroundColor: Colors.white,
              ),
              child: const Text("Add to Timeline"),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    if (type == 'Promotion') return Icons.trending_up;
    if (type == 'Achievement') return Icons.workspace_premium;
    if (type == 'Education') return Icons.school;
    return Icons.work;
  }

  Color _getColor(String type) {
    if (type == 'Promotion') return Colors.blue.shade800;
    if (type == 'Achievement') return Colors.purple.shade700;
    if (type == 'Education') return Colors.indigo.shade900;
    return Colors.orange.shade800;
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
            const Text("Career Timeline", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Track your professional journey", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: List.generate(_timelineEvents.length, (index) {
                  final e = _timelineEvents[index];
                  return _buildTimelineEntry(
                    icon: e['icon'],
                    iconBg: e['iconBg'],
                    badge: e['badge'],
                    badgeColor: e['badgeColor'],
                    date: e['date'],
                    title: e['title'],
                    company: e['company'],
                    desc: e['desc'],
                    isLast: index == _timelineEvents.length - 1,
                  );
                }),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: _showAddEventDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A0E2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Add Career Event"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineEntry({
    required IconData icon,
    required Color iconBg,
    required String badge,
    required Color badgeColor,
    required String date,
    required String title,
    required String company,
    required String desc,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, color: Colors.white, size: 20)),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.indigo.shade100)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
                        child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11))),
                    const SizedBox(width: 10),
                    Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                  const SizedBox(height: 10),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(company, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 5),
                  Text(desc, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}