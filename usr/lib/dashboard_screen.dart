import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Analytics Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text('DA', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildMetricsGrid(context),
            const SizedBox(height: 32),
            const Text(
              'Revenue Performance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildBarChartCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: constraints.maxWidth > 500 ? 2.5 : 3.0,
          children: [
            _buildMetricCard('Total Revenue', '\$124,500', '+14%', Colors.green),
            _buildMetricCard('Active Users', '8,234', '+5%', Colors.green),
            _buildMetricCard('Churn Rate', '2.4%', '-1.2%', Colors.green),
            _buildMetricCard('Server Cost', '\$3,420', '+8%', Colors.orange),
          ],
        );
      }
    );
  }

  Widget _buildMetricCard(String title, String value, String change, Color changeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBarChartCard(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey.shade800,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${(rod.toY * 10).round()}k',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  );
                  String text;
                  switch (value.toInt()) {
                    case 0: text = 'Jan'; break;
                    case 1: text = 'Feb'; break;
                    case 2: text = 'Mar'; break;
                    case 3: text = 'Apr'; break;
                    case 4: text = 'May'; break;
                    case 5: text = 'Jun'; break;
                    default: text = ''; break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(text, style: style),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '\$${(value * 10).toInt()}k',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.black12,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeBarGroup(0, 8, 5),
            _makeBarGroup(1, 10, 6),
            _makeBarGroup(2, 14, 8),
            _makeBarGroup(3, 15, 9),
            _makeBarGroup(4, 13, 11),
            _makeBarGroup(5, 18, 14),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blueAccent,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.lightBlueAccent.withOpacity(0.5),
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}