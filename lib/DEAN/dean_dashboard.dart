import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DeanDashboard extends StatelessWidget {
  const DeanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            "Dean Dashboard",
            style: TextStyle(color: Color(0xFF420031), fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text("High-level monitoring and decision-making for department alumni", 
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 25),

          // Summary Mini-Cards Row (Stats from Screenshot)
          Row(
            children: [
              _buildMiniRateCard("10", "Total Alumni", Icons.people_outline, const Color(0xFF420031)),
              _buildMiniRateCard("80.0%", "Employment Rate", Icons.trending_up, Colors.orange),
              _buildMiniRateCard("7", "Verified Alumni", Icons.verified_user_outlined, Colors.teal),
              _buildMiniRateCard("3", "Pending Verification", Icons.timer_outlined, Colors.redAccent),
            ],
          ),
          const SizedBox(height: 25),

          // Main Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Employment Rate per Batch (Bar Chart)
              Expanded(flex: 3, child: _buildBarChartCard("Employment Rate per Batch")),
              const SizedBox(width: 20),
              // 2. Industry Distribution (Pie Chart)
              Expanded(flex: 2, child: _buildPieChartCard("Industry Distribution")),
            ],
          ),
          const SizedBox(height: 25),

          // Bottom Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. Graduates per Year (Comparison Chart)
              Expanded(flex: 3, child: _buildComparisonChartCard("Graduates per Year")),
              const SizedBox(width: 20),
              // 4. Top Employers List
              Expanded(flex: 2, child: _buildTopEmployersCard("Top Employers")),
            ],
          ),
        ],
      ),
    );
  }

  // --- STAT CARDS ---
  Widget _buildMiniRateCard(String value, String label, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF420031))),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            const Spacer(),
            Icon(icon, color: iconColor.withOpacity(0.7), size: 24),
          ],
        ),
      ),
    );
  }

  // --- 1. BAR CHART (EMPLOYMENT RATE) ---
  Widget _buildBarChartCard(String title) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF420031))),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: 100,
                barGroups: [
                  _makeGroupData(0, 100, "2020"),
                  _makeGroupData(1, 50, "2021"),
                  _makeGroupData(2, 100, "2022"),
                  _makeGroupData(3, 65, "2023"),
                  _makeGroupData(4, 100, "2024"),
                ],
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const years = ["2020", "2021", "2022", "2023", "2024"];
                        return Text(years[value.toInt()], style: const TextStyle(fontSize: 10, color: Colors.grey));
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. PIE CHART (INDUSTRY) ---
  Widget _buildPieChartCard(String title) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF420031))),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(color: const Color(0xFF420031), value: 63, title: '63%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                  PieChartSectionData(color: const Color(0xFFB58D3D), value: 13, title: '13%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                  PieChartSectionData(color: Colors.brown, value: 13, title: '13%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                  PieChartSectionData(color: Colors.grey, value: 11, title: '11%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const Wrap(
            spacing: 10,
            children: [
              _Legend(color: Color(0xFF420031), text: "Tech"),
              _Legend(color: Color(0xFFB58D3D), text: "Consulting"),
              _Legend(color: Colors.brown, text: "Finance"),
            ],
          )
        ],
      ),
    );
  }

  // --- 3. COMPARISON CHART (GRADUATES VS EMPLOYED) ---
  Widget _buildComparisonChartCard(String title) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF420031))),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: [
                  _makeMultiGroupData(0, 2.0, 2.0), // 2020
                  _makeMultiGroupData(1, 2.0, 1.0), // 2021
                  _makeMultiGroupData(2, 2.0, 2.0), // 2022
                  _makeMultiGroupData(3, 3.0, 2.0), // 2023
                  _makeMultiGroupData(4, 1.0, 1.0), // 2024
                ],
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. TOP EMPLOYERS LIST ---
  Widget _buildTopEmployersCard(String title) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF420031))),
          const SizedBox(height: 20),
          _employerRow("1", "Tech Corp", "1 alumni"),
          _employerRow("2", "Data Solutions", "1 alumni"),
          _employerRow("3", "Brand Co", "1 alumni"),
          _employerRow("4", "Finance Group", "1 alumni"),
          _employerRow("5", "Design Studio", "1 alumni"),
        ],
      ),
    );
  }

  Widget _employerRow(String rank, String name, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(radius: 12, backgroundColor: const Color(0xFFB58D3D), child: Text(rank, style: const TextStyle(fontSize: 10, color: Colors.white))),
          const SizedBox(width: 15),
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(count, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // Helpers
  BarChartGroupData _makeGroupData(int x, double y, String year) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: const Color(0xFF420031), width: 40, borderRadius: BorderRadius.circular(0)),
    ]);
  }

  BarChartGroupData _makeMultiGroupData(int x, double y1, double y2) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y1, color: const Color(0xFFB58D3D), width: 35, borderRadius: BorderRadius.circular(0)),
      BarChartRodData(toY: y2, color: const Color(0xFF420031), width: 35, borderRadius: BorderRadius.circular(0)),
    ]);
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  const _Legend({required this.color, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}