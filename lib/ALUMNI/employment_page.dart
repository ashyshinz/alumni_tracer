import 'package:flutter/material.dart';

class EmploymentPage extends StatefulWidget {
  const EmploymentPage({super.key});

  @override
  State<EmploymentPage> createState() => _EmploymentPageState();
}

class _EmploymentPageState extends State<EmploymentPage> {
  // Mock current user ID (Alumni ID)
  final String _currentAlumniId = "ALUM-2024-001";

  final List<Map<String, dynamic>> _employmentHistory = [
    {
      "employmentId": "EMP-1700000000",
      "alumniId": "ALUM-2024-001",
      "title": "Senior Developer",
      "company": "Tech Solutions Inc.",
      "date": "2023-01-15 - Present",
      "location": "San Francisco, CA",
      "description": "Leading development team on enterprise projects",
      "isCurrent": true,
    },
  ];

  void _showEmploymentDialog({int? index}) {
    final bool isEditing = index != null;
    
    final titleController = TextEditingController(
      text: isEditing ? _employmentHistory[index]['title'] : "",
    );
    final companyController = TextEditingController(
      text: isEditing ? _employmentHistory[index]['company'] : "",
    );
    final locationController = TextEditingController(
      text: isEditing ? _employmentHistory[index]['location'] : "",
    );
    final descController = TextEditingController(
      text: isEditing ? _employmentHistory[index]['description'] : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit Employment" : "Add Employment Information"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the IDs as read-only or info text
              if (!isEditing) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Assigning to Alumni ID: $_currentAlumniId",
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                  ),
                ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Job Title", hintText: "e.g. Software Engineer"),
              ),
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: "Company", hintText: "e.g. Google"),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location", hintText: "e.g. Cebu City, PH"),
              ),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description", hintText: "Briefly describe your role"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && companyController.text.isNotEmpty) {
                setState(() {
                  // Generate or Retain IDs
                  final String empId = isEditing 
                      ? _employmentHistory[index]['employmentId'] 
                      : "EMP-${DateTime.now().millisecondsSinceEpoch}";
                  
                  final newData = {
                    "employmentId": empId,
                    "alumniId": _currentAlumniId, // Always tied to current user
                    "title": titleController.text,
                    "company": companyController.text,
                    "date": isEditing ? _employmentHistory[index]['date'] : "Present",
                    "location": locationController.text,
                    "description": descController.text,
                    "isCurrent": isEditing ? _employmentHistory[index]['isCurrent'] : false,
                  };

                  if (isEditing) {
                    _employmentHistory[index] = newData;
                  } else {
                    _employmentHistory.add(newData);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEditing ? "Updated ID: ${_employmentHistory[index]['employmentId']}" : "Added with ID: ${_employmentHistory.last['employmentId']}")),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
            child: Text(isEditing ? "Save Changes" : "Add Record"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Added Scaffold for better layout handling
      backgroundColor: const Color(0xFFF3F3F3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Employment Information",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                    ),
                    Text(
                      "Manage your history with automated tracking",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEmploymentDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add Employment"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            for (int i = 0; i < _employmentHistory.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildEmploymentCard(
                  index: i,
                  job: _employmentHistory[i],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmploymentCard({required int index, required Map<String, dynamic> job}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("ID: ${job['employmentId']}", style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace')),
                  ],
                ),
              ),
              _buildTag("Employed", Colors.green),
              const SizedBox(width: 5),
              if (job['isCurrent']) _buildTag("Current", Colors.indigo),
              IconButton(
                onPressed: () => _showEmploymentDialog(index: index), 
                icon: const Icon(Icons.edit_note, color: Colors.indigo),
              ),
              IconButton(
                onPressed: () => setState(() => _employmentHistory.removeAt(index)), 
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const Divider(height: 25),
          Text(job['company'], style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(job['date'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(width: 20),
              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(job['alumniId'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Text(job['description'], style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}