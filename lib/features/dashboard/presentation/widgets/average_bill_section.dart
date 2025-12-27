import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class AverageBillSection extends StatelessWidget {
  final AverageBillData averageBillData;

  const AverageBillSection({super.key, required this.averageBillData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275.0,
      width: 270.0,
      child: DashboardSectionCard(
        title: 'Средний чек',
        padding: EdgeInsets.all(14.0),
        children: [
          const SizedBox(height: 16),
          SizedBox(height: 150, child: LineChart(_buildChartData())),
          const SizedBox(height: 8),
          _buildChartLegend(),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (averageBillData.dailyData.length - 1).toDouble(),
      minY: 0,
      maxY: _calculateMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _generateSpots(true),
          color: Color(0xFFA9DFD8),
          barWidth: 1.15,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: Color(0xFFA9DFD8),
                strokeWidth: 0,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Color(0xFFA9DFD8),
                Color(0xFFF2F2F5).withValues(alpha: .7),
                Color(0xFFFFFFFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        LineChartBarData(
          spots: _generateSpots(false),
          color: Color(0xFFF2C8ED),
          barWidth: 1.15,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 2,
                color: Color(0xFFF2C8ED),
                strokeWidth: 0,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Color(0xFFF2C8ED),
                Color(0xFFF2F2F5).withValues(alpha: .7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots(bool isCurrent) {
    return averageBillData.dailyData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(
        index.toDouble(),
        isCurrent ? data.amount : data.previousAmount,
      );
    }).toList();
  }

  double _calculateMaxY() {
    final maxCurrent = averageBillData.dailyData
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);
    final maxPrevious = averageBillData.dailyData
        .map((e) => e.previousAmount)
        .reduce((a, b) => a > b ? a : b);
    final maxValue = maxCurrent > maxPrevious ? maxCurrent : maxPrevious;
    return (maxValue * 1.2).roundToDouble();
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('В прошлом месяце', Color(0xFFA9DFD8)),
        const SizedBox(width: 16),
        _buildLegendItem('В этом месяце', Color(0xFFF2C8ED)),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Column(
      children: [
        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 3, backgroundColor: color),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          '280,500 сум',
          style: GoogleFonts.inter(fontSize: 12.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
