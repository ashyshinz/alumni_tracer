import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsReportsPage extends StatelessWidget {
  const AnalyticsReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER WITH EXPORT BUTTONS ---
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analytics & Reports",
                      style: TextStyle(color: Color(0xFF420031), fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text("Comprehensive data analysis and reporting tools", 
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text("Export PDF"),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF420031)),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined, size: 18),
                  label: const Text("Export CSV"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC69C6D),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- TOP STAT CARDS ---
            Row(
              children: [
                _buildStatCard("Overall Employment Rate", "80.0%", "8 of 10 alumni employed", Icons.trending_up, Colors.purple),
                const SizedBox(width: 20),
                _buildStatCard("Total Alumni", "10", "Across all batches", Icons.people_outline, Colors.orange),
                const SizedBox(width: 20),
                _buildStatCard("Industries Covered", "4", "Different industry sectors", Icons.business_center_outlined, Colors.red),
              ],
            ),
            const SizedBox(height: 25),

            // --- 1. EMPLOYMENT TRENDS (LINE CHART) ---
            _buildChartSection(
              title: "Employment Rate Trends by Batch (%)",
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: _buildAxes(isLine: true),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 110,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 100), // 2020
                        FlSpot(1, 50),  // 2021
                        FlSpot(2, 100), // 2022
                        FlSpot(3, 65),  // 2023
                        FlSpot(4, 100), // 2024
                      ],
                      isCurved: true,
                      color: const Color(0xFF420031),
                      barWidth: 4,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: const Color(0xFF420031).withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- 2. PLACEMENT & 3. DISTRIBUTION ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildChartSection(
                    title: "Alumni Placement Trends (Count)",
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 5,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: _buildAxes(),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        barGroups: [
                          _makeStackedGroup(0, 2, 0), // 2020: 2 Employed, 0 Unemployed
                          _makeStackedGroup(1, 1, 1), // 2021: 1 Emp, 1 Unemp
                          _makeStackedGroup(2, 2, 0), // 2022
                          _makeStackedGroup(3, 2, 1), // 2023
                          _makeStackedGroup(4, 1, 0), // 2024
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: _buildChartSection(
                    title: "Industry Distribution",
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(color: const Color(0xFF420031), value: 5, title: '63%', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          PieChartSectionData(color: const Color(0xFFC69C6D), value: 1, title: '13%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                          PieChartSectionData(color: Colors.purple.shade900, value: 1, title: '13%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                          PieChartSectionData(color: Colors.orange, value: 1, title: '13%', radius: 45, titleStyle: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- 4. BATCH PERFORMANCE (GROUPED BAR CHART) ---
            _buildChartSection(
              title: "Batch Performance Comparison (Total Grads vs Employed)",
              height: 300,
              child: BarChart(
                BarChartData(
                  maxY: 4,
                  titlesData: _buildAxes(),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeGroupedData(0, 2, 2), // 2020: 2 Grads, 2 Emp
                    _makeGroupedData(1, 2, 1), // 2021
                    _makeGroupedData(2, 2, 2), // 2022
                    _makeGroupedData(3, 3, 2), // 2023
                    _makeGroupedData(4, 1, 1), // 2024
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- INDUSTRY BREAKDOWN LIST ---
            _buildIndustryBreakdown(),
            const SizedBox(height: 25),

            // --- EXECUTIVE SUMMARY ---
            _buildExecutiveSummary(),
          ],
        ),
      ),
    );
  }

  // --- HELPER: CHART AXES TILES ---
  FlTitlesData _buildAxes({bool isLine = false}) {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const years = ["2020", "2021", "2022", "2023", "2024"];
            if (value >= 0 && value < years.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(years[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 10)),
              );
            }
            return const Text("");
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            return Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10));
          },
          reservedSize: 28,
        ),
      ),
    );
  }

  // --- HELPER: STACKED BAR (Employed + Unemployed) ---
  BarChartGroupData _makeStackedGroup(int x, double employed, double unemployed) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: employed + unemployed,
          width: 25,
          borderRadius: BorderRadius.circular(4),
          rodStackItems: [
            BarChartRodStackItem(0, employed, const Color(0xFF420031)),
            BarChartRodStackItem(employed, employed + unemployed, const Color(0xFFE0E0E0)),
          ],
        ),
      ],
    );
  }

  // --- HELPER: GROUPED BAR (Grads vs Employed side-by-side) ---
  BarChartGroupData _makeGroupedData(int x, double grads, double employed) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(toY: grads, color: const Color(0xFFC69C6D), width: 12, borderRadius: BorderRadius.circular(2)),
        BarChartRodData(toY: employed, color: const Color(0xFF420031), width: 12, borderRadius: BorderRadius.circular(2)),
      ],
    );
  }

  // (The rest of your existing UI methods: _buildStatCard, _buildChartSection, _buildIndustryBreakdown, _buildIndustryRow, _buildExecutiveSummary, _bulletPoint)
  // ... Paste your existing UI methods here to complete the file ...
  
  // (Note: Including them below for completeness)

  Widget _buildStatCard(String title, String value, String sub, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF420031), fontSize: 12, fontWeight: FontWeight.w500)),
                Icon(icon, color: iconColor.withOpacity(0.5), size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF420031))),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({required String title, required double height, required Widget child}) {
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
          SizedBox(height: height, child: child),
        ],
      ),
    );
  }

  Widget _buildIndustryBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Industry Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF420031))),
          const SizedBox(height: 20),
          _industryRow("Technology", "62.5% of employed alumni", "5", const Color(0xFF420031)),
          _industryRow("Marketing", "12.5% of employed alumni", "1", const Color(0xFFC69C6D)),
          _industryRow("Finance", "12.5% of employed alumni", "1", Colors.purple.shade900),
          _industryRow("Consulting", "12.5% of employed alumni", "1", Colors.orange),
        ],
      ),
    );
  }

  Widget _industryRow(String name, String desc, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 12, backgroundColor: color, child: Text(count, style: const TextStyle(color: Colors.white, fontSize: 10))),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Text("$count alumni", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF420031).withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF420031).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Executive Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF420031))),
          const SizedBox(height: 15),
          _bulletPoint("Department maintains a **80.0% employment rate** across all batches"),
          _bulletPoint("**8 out of 10** alumni are currently employed"),
          _bulletPoint("Alumni are distributed across **4 major industries**"),
          _bulletPoint("**7** alumni profiles have been verified and approved"),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Color(0xFF420031), fontSize: 18)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }
}