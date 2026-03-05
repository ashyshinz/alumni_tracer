import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EmploymentAnalyticsPage extends StatefulWidget {
  const EmploymentAnalyticsPage({super.key});

  @override
  State<EmploymentAnalyticsPage> createState() => _EmploymentAnalyticsPageState();
}

class _EmploymentAnalyticsPageState extends State<EmploymentAnalyticsPage> {
  // 1. STATE VARIABLES FOR FILTERS
  String selectedYear = "All Years";
  String selectedCourse = "All Courses";
  String selectedBatch = "All Batches";

  // Mock data that "changes" based on selection
  double employmentRate = 87.3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Employment Analytics", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text("Comprehensive insights into alumni employment trends", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 25),

          // 2. FUNCTIONAL FILTER BAR
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                _buildFilterDropdown("Year", selectedYear, ["All Years", "2024", "2023", "2022"], (val) {
                  setState(() {
                    selectedYear = val!;
                    // Logic: Change data based on year
                    employmentRate = val == "2024" ? 92.5 : 87.3;
                  });
                }),
                const SizedBox(width: 20),
                _buildFilterDropdown("Courses", selectedCourse, ["All Courses", "IT", "CS", "IS"], (val) {
                  setState(() => selectedCourse = val!);
                }),
                const SizedBox(width: 20),
                _buildFilterDropdown("Batch", selectedBatch, ["All Batches", "Batch A", "Batch B"], (val) {
                  setState(() => selectedBatch = val!);
                }),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // 3. DYNAMIC MINI STATS
          Row(
            children: [
              _miniStatCard(Icons.trending_up, "$employmentRate%", "Overall Employment Rate"),
              _miniStatCard(Icons.people, "1,240", "Total Alumni Tracked"),
              _miniStatCard(Icons.business, "450", "Partner Companies"),
              _miniStatCard(Icons.timer, "3.2 Months", "Avg. Time to Hire"),
            ],
          ),
          const SizedBox(height: 25),

          // MIDDLE CHARTS ROW
          Row(
            children: [
              _analyticsBox("Employment by Batch", _buildSimpleBarChart(), 1),
              const SizedBox(width: 15),
              _analyticsBox("Batch Comparison", _buildMultiBarChart(), 1),
            ],
          ),
          const SizedBox(height: 25),

          // BOTTOM CHARTS ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _analyticsBox("Employment Status Distribution", _buildPieWithLegend(), 1),
              const SizedBox(width: 15),
              _analyticsBox("Top Hiring Industries", _buildIndustryHiring(), 1),
            ],
          ),
        ],
      ),
    );
  }

  // --- FUNCTIONAL DROPDOWN ---
  Widget _buildFilterDropdown(String label, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              items: options.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // --- CHART BUILDERS (Dynamic Based on State) ---
  Widget _buildSimpleBarChart() {
    // If "2024" is selected, we could show different heights here
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("${2020 + value.toInt()}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeGroupData(0, selectedYear == "2024" ? 95 : 82, Colors.blue),
          _makeGroupData(1, 45, Colors.blue),
          _makeGroupData(2, 38, Colors.blue),
          _makeGroupData(3, 90, Colors.blue),
          _makeGroupData(4, 15, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildPieWithLegend() {
    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(value: 43.6, color: Colors.cyan, title: '', radius: 50),
                PieChartSectionData(value: 32.8, color: Colors.blue, title: '', radius: 50),
                PieChartSectionData(value: 23.6, color: Colors.orange, title: '', radius: 50),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _legendItem(Colors.blue, "Employed", "32.8%"),
            _legendItem(Colors.cyan, "Unemployed", "43.6%"),
            _legendItem(Colors.orange, "Self-Employed", "23.5%"),
          ],
        )
      ],
    );
  }

  // --- STAT CARD HELPER ---
  Widget _miniStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12), 
          border: Border.all(color: Colors.black12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: Colors.blue),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  // Existing helpers (GroupData, IndustryRow, etc.) simplified for brevity...
  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [BarChartRodData(toY: y, color: color, width: 20, borderRadius: BorderRadius.circular(4))]);
  }

  BarChartGroupData _makeMultiGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y1, color: Colors.blue, width: 7),
      BarChartRodData(toY: y2, color: Colors.orange, width: 7),
      BarChartRodData(toY: y3, color: Colors.cyan, width: 7),
    ]);
  }

  Widget _buildMultiBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => Text("202${v.toInt()}", style: const TextStyle(fontSize: 10)))),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          _makeMultiGroupData(0, 40, 90, 75),
          _makeMultiGroupData(1, 80, 30, 40),
          _makeMultiGroupData(2, 90, 95, 55),
          _makeMultiGroupData(3, 95, 90, 85),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildIndustryHiring() {
    return Column(
      children: [
        _industryRow("Technology", 0.8, "59.23%"),
        _industryRow("Finance", 0.6, "41.85%"),
        _industryRow("Healthcare", 0.4, "25.11%"),
        _industryRow("Education", 0.3, "20.17%"),
      ],
    );
  }

  Widget _industryRow(String label, double value, String percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(percentage, style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: value, color: Colors.blue, backgroundColor: Colors.grey[200], minHeight: 8, borderRadius: BorderRadius.circular(10)),
        ],
      ),
    );
  }

  Widget _analyticsBox(String title, Widget chart, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 25),
            Expanded(child: chart),
          ],
        ),
      ),
    );
  }
}