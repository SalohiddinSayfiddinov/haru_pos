import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class AverageBillSection extends StatelessWidget {
  final AverageCheckEntity averageBillData;

  const AverageBillSection({super.key, required this.averageBillData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255.0,
      width: 270.0,
      child: DashboardSectionCard(
        title: LocaleKeys.dashboard_average_check.tr(),
        padding: EdgeInsets.all(14.0),
        children: [
          // const SizedBox(height: 16),
          // SizedBox(height: 150, child: LineChart(_buildChartData())),
          // const SizedBox(height: 8),
          _buildChartLegend(context),
        ],
      ),
    );
  }

  // LineChartData _buildChartData() {
  //   return LineChartData(
  //     gridData: FlGridData(show: false),
  //     titlesData: FlTitlesData(show: false),
  //     borderData: FlBorderData(show: false),
  //     minX: 0,
  //     maxX: (averageBillData.daily.length - 1).toDouble(),
  //     minY: 0,
  //     maxY: _calculateMaxY(),
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: _generateSpots(true),
  //         color: Color(0xFFA9DFD8),
  //         barWidth: 1.15,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(
  //           show: true,
  //           getDotPainter: (spot, percent, barData, index) {
  //             return FlDotCirclePainter(
  //               radius: 2,
  //               color: Color(0xFFA9DFD8),
  //               strokeWidth: 0,
  //             );
  //           },
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors: [
  //               Color(0xFFA9DFD8),
  //               Color(0xFFF2F2F5).withValues(alpha: .7),
  //               Color(0xFFFFFFFF),
  //             ],
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //           ),
  //         ),
  //       ),
  //
  //       LineChartBarData(
  //         spots: _generateSpots(false),
  //         color: Color(0xFFF2C8ED),
  //         barWidth: 1.15,
  //         isStrokeCapRound: true,
  //         dotData: FlDotData(
  //           show: true,
  //           getDotPainter: (spot, percent, barData, index) {
  //             return FlDotCirclePainter(
  //               radius: 2,
  //               color: Color(0xFFF2C8ED),
  //               strokeWidth: 0,
  //             );
  //           },
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors: [
  //               Color(0xFFF2C8ED),
  //               Color(0xFFF2F2F5).withValues(alpha: .7),
  //             ],
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // List<FlSpot> _generateSpots(bool isCurrent) {
  //   return averageBillData.dailyData.asMap().entries.map((entry) {
  //     final index = entry.key;
  //     final data = entry.value;
  //     return FlSpot(
  //       index.toDouble(),
  //       isCurrent ? data.amount : data.previousAmount,
  //     );
  //   }).toList();
  // }

  // double _calculateMaxY() {
  //   final maxCurrent = averageBillData.dailyData
  //       .map((e) => e.amount)
  //       .reduce((a, b) => a > b ? a : b);
  //   final maxPrevious = averageBillData.dailyData
  //       .map((e) => e.previousAmount)
  //       .reduce((a, b) => a > b ? a : b);
  //   final maxValue = maxCurrent > maxPrevious ? maxCurrent : maxPrevious;
  //   return (maxValue * 1.2).roundToDouble();
  // }

  Widget _buildChartLegend(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildLegendItem(
            LocaleKeys.dashboard_last_month.tr(),
            averageBillData.lastMonth,
            Color(0xFFA9DFD8),
            context
          ),
          const SizedBox(width: 16),
          _buildLegendItem(
            LocaleKeys.dashboard_this_month.tr(),
            averageBillData.thisMonth,
            Color(0xFFF2C8ED),
            context
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, double value, Color color, BuildContext context) {
    return Column(
      spacing: 4.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 3, backgroundColor: color),
            Text(
              text,
              style: GoogleFonts.inter(
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value.formatCurrency(context),
          style: GoogleFonts.inter(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
