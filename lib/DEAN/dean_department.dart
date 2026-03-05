import 'package:flutter/material.dart';

class DepartmentAlumniPage extends StatefulWidget {
  const DepartmentAlumniPage({super.key});

  @override
  State<DepartmentAlumniPage> createState() => _DepartmentAlumniPageState();
}

class _DepartmentAlumniPageState extends State<DepartmentAlumniPage> {
  String _searchQuery = "";
  String _selectedStatus = "All Statuses";
  String _selectedVerification = "All Verification";
  Map<String, dynamic>? _selectedAlumnus;

  // --- MOCK DATA ---
  final List<Map<String, dynamic>> _alumniData = [
    {
      "name": "John Smith",
      "course": "BS in Information Technology",
      "batch": "Batch 2020",
      "empStatus": "Employed",
      "verStatus": "Verified",
      "pos": "Software Engineer",
      "email": "john.smith@techcorp.com",
      "address": "123 Silicon Valley, CA",
      "skills": ["Flutter", "Dart", "Firebase"]
    },
    {
      "name": "Michael Brown",
      "course": "BS in Computer Science",
      "batch": "Batch 2021",
      "empStatus": "Unemployed",
      "verStatus": "Pending",
      "pos": "-",
      "email": "m.brown@email.com",
      "address": "456 Oak St, New York, NY",
      "skills": ["Management", "Planning"]
    },
    {
      "name": "Emily Davis",
      "course": "BS in Information Systems",
      "batch": "Batch 2021",
      "empStatus": "Employed",
      "verStatus": "Verified",
      "pos": "Marketing Manager",
      "email": "emily.d@brandco.com",
      "address": "789 Pine St, Chicago, IL",
      "skills": ["SEO", "Copywriting"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedAlumnus != null) {
      return _buildAlumniDetailView(_selectedAlumnus!);
    }

    List<Map<String, dynamic>> filteredList = _alumniData.where((alumnus) {
      final name = alumnus['name']?.toString().toLowerCase() ?? "";
      final batch = alumnus['batch']?.toString().toLowerCase() ?? "";
      final course = alumnus['course']?.toString().toLowerCase() ?? "";
      
      final matchesSearch = name.contains(_searchQuery.toLowerCase()) ||
          batch.contains(_searchQuery.toLowerCase()) ||
          course.contains(_searchQuery.toLowerCase());
          
      final matchesStatus = _selectedStatus == "All Statuses" || alumnus['empStatus'] == _selectedStatus;
      final matchesVer = _selectedVerification == "All Verification" || alumnus['verStatus'] == _selectedVerification;
      
      return matchesSearch && matchesStatus && matchesVer;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Department Alumni", style: TextStyle(color: Color(0xFF420031), fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            _buildSearchFilters(),
            const SizedBox(height: 25),
            _buildAlumniTable(filteredList),
          ],
        ),
      ),
    );
  }

  // --- SEARCH FILTERS ---
  Widget _buildSearchFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildFilterField(Icons.search, "Search name, batch, or course...")),
          const SizedBox(width: 15),
          Expanded(child: _buildRealDropdown(["All Statuses", "Employed", "Unemployed"], _selectedStatus, (val) => setState(() => _selectedStatus = val!))),
          const SizedBox(width: 15),
          Expanded(child: _buildRealDropdown(["All Verification", "Verified", "Pending"], _selectedVerification, (val) => setState(() => _selectedVerification = val!))),
        ],
      ),
    );
  }

  // --- DATA TABLE ---
  Widget _buildAlumniTable(List<Map<String, dynamic>> list) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Batch')),
          DataColumn(label: Text('Employment')),
          DataColumn(label: Text('Action')),
        ],
        rows: list.map((data) => DataRow(cells: [
          DataCell(Text(data['name'] ?? "Unknown")),
          DataCell(Text(data['course'] ?? "N/A")),
          DataCell(Text(data['batch'] ?? "N/A")),
          DataCell(_buildBadge(data['empStatus'] ?? "N/A", data['empStatus'] == "Employed" ? Colors.green : Colors.blueGrey)),
          DataCell(IconButton(
            icon: const Icon(Icons.visibility_outlined, color: Colors.blue),
            onPressed: () => setState(() => _selectedAlumnus = data),
          )),
        ])).toList(),
      ),
    );
  }

  // --- DETAIL VIEW ---
  Widget _buildAlumniDetailView(Map<String, dynamic> data) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF420031)), onPressed: () => setState(() => _selectedAlumnus = null)),
        title: Text(data['name'] ?? "Profile Detail", style: const TextStyle(color: Color(0xFF420031), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 30),
            Wrap(
              spacing: 30,
              runSpacing: 20,
              children: [
                _detailItem("Full Name", data['name'] ?? "Not Provided", Icons.person_outline),
                _detailItem("Course", data['course'] ?? "Not Provided", Icons.book_outlined),
                _detailItem("Email", data['email'] ?? "Not Provided", Icons.email_outlined),
                _detailItem("Batch", data['batch'] ?? "Not Provided", Icons.school_outlined),
              ],
            ),
            const SizedBox(height: 30),
            _detailItem("Address", data['address'] ?? "No Address Provided", Icons.location_on_outlined, isFullWidth: true),
            const SizedBox(height: 30),
            const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: (data['skills'] as List? ?? []).map((s) => Chip(label: Text(s.toString()))).toList(),
            )
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _detailItem(String label, String value, IconData icon, {bool isFullWidth = false}) {
    return SizedBox(
      width: isFullWidth ? double.infinity : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF420031)),
                const SizedBox(width: 10),
                Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFilterField(IconData icon, String hint) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(prefixIcon: Icon(icon, size: 18), hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
      ),
    );
  }

  Widget _buildRealDropdown(List<String> items, String value, Function(String?) onChanged) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        ),
      ),
    );
  }
}