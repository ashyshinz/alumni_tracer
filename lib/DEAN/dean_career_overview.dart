import 'package:flutter/material.dart';

class CareerOverviewPage extends StatefulWidget {
  const CareerOverviewPage({super.key});

  @override
  State<CareerOverviewPage> createState() => _CareerOverviewPageState();
}

class _CareerOverviewPageState extends State<CareerOverviewPage> {
  // 1. MOCK DATA - Represents your database of alumni career records
  final List<Map<String, dynamic>> _alumniRecords = [
    {
      "display": "John Smith - Batch 2020",
      "current": {"pos": "Software Engineer", "company": "Tech Corp", "industry": "Technology"},
      "summary": {"total": "2", "status": "Employed", "primary": "Technology"},
      "history": [
        {"title": "Software Engineer", "company": "Tech Corp", "ind": "Technology", "period": "2020-07 - Present", "dur": "4 years"},
        {"title": "Junior Developer", "company": "StartUp Inc", "ind": "Technology", "period": "2020-01 - 2020-06", "dur": "6 months"},
      ]
    },
    {
      "display": "Sarah Johnson - Batch 2021",
      "current": {"pos": "Data Analyst", "company": "DataViz Group", "industry": "Finance"},
      "summary": {"total": "1", "status": "Employed", "primary": "Finance"},
      "history": [
        {"title": "Data Analyst", "company": "DataViz Group", "ind": "Finance", "period": "2021-08 - Present", "dur": "3 years"},
      ]
    },
    {
      "display": "Michael Chen - Batch 2019",
      "current": {"pos": "-", "company": "-", "industry": "None"},
      "summary": {"total": "3", "status": "Unemployed", "primary": "Education"},
      "history": [
        {"title": "Teacher", "company": "Global School", "ind": "Education", "period": "2019-05 - 2023-12", "dur": "4.5 years"},
      ]
    },
  ];

  // 2. STATE VARIABLE - Holds the currently selected record
  late Map<String, dynamic> _selectedData;

  @override
  void initState() {
    super.initState();
    _selectedData = _alumniRecords[0]; // Default to first person
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Career Overview",
              style: TextStyle(color: Color(0xFF420031), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("View employment details and career history of alumni", 
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 25),

            // --- SELECT ALUMNI SECTION (FUNCTIONAL DROPDOWN) ---
            _buildSectionCard(
              title: "Select Alumni",
              child: Container(
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Map<String, dynamic>>(
                    value: _selectedData,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    isExpanded: true,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    items: _alumniRecords.map((record) {
                      return DropdownMenuItem(
                        value: record,
                        child: Text(record['display']),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedData = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- CURRENT EMPLOYMENT SECTION ---
            _buildSectionCard(
              title: "Current Employment",
              child: Row(
                children: [
                  _buildEmploymentDetail(Icons.work_outline, "Position", _selectedData['current']['pos']),
                  const SizedBox(width: 40),
                  _buildEmploymentDetail(Icons.business, "Company", _selectedData['current']['company']),
                  const SizedBox(width: 40),
                  _buildEmploymentDetail(Icons.access_time, "Industry", _selectedData['current']['industry'], isBadge: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- CAREER HISTORY TIMELINE ---
            _buildSectionCard(
              title: "Career History Timeline",
              child: Column(
                children: List.generate(_selectedData['history'].length, (index) {
                  final item = _selectedData['history'][index];
                  return _buildTimelineItem(
                    title: item['title'],
                    company: item['company'],
                    industry: item['ind'],
                    period: item['period'],
                    duration: item['dur'],
                    isLast: index == _selectedData['history'].length - 1,
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // --- EMPLOYMENT SUMMARY ---
            _buildSectionCard(
              title: "Employment Summary",
              child: Row(
                children: [
                  _buildSummaryBox("Total Positions", _selectedData['summary']['total'], Colors.black87),
                  const SizedBox(width: 15),
                  _buildSummaryBox(
                    "Current Status", 
                    _selectedData['summary']['status'], 
                    _selectedData['summary']['status'] == "Employed" ? Colors.green : Colors.red, 
                    isStatus: true
                  ),
                  const SizedBox(width: 15),
                  _buildSummaryBox("Primary Industry", _selectedData['summary']['primary'], const Color(0xFF420031)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- READ-ONLY FOOTER ---
            _buildFooterInfo(),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE WIDGETS ---

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF420031))),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildEmploymentDetail(IconData icon, String label, String value, {bool isBadge = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Color(0xFFF5F5F5), shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            if (isBadge && value != "-")
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF420031), borderRadius: BorderRadius.circular(4)),
                child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 10)),
              )
            else
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        )
      ],
    );
  }

  Widget _buildTimelineItem({required String title, required String company, required String industry, required String period, required String duration, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              const Icon(Icons.circle, size: 8, color: Color(0xFFC69C6D)),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade200)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFBFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF420031))),
                      Text(company, style: const TextStyle(color: Color(0xFFC69C6D), fontSize: 12)),
                      const SizedBox(height: 5),
                      const Text("Industry", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(industry, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: Text(duration, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                      const SizedBox(height: 15),
                      const Text("Period", style: TextStyle(color: Colors.grey, fontSize: 10)),
                      Text(period, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String label, String value, Color color, {bool isStatus = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 8),
            if (isStatus)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              )
            else
              Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Read-Only View: This section provides career information for monitoring purposes only. All data is verified and approved through the system administrator.",
              style: TextStyle(color: Colors.blue.shade800, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}