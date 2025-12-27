import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/assets/app_icons.dart';
import 'package:haru_pos/core/constants/app_colors.dart';
import 'package:haru_pos/core/utils/extensions.dart';
import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/dashboard_section_card.dart';

class ProfitCard extends StatefulWidget {
  final ProfitData profitData;

  const ProfitCard({super.key, required this.profitData});

  @override
  State<ProfitCard> createState() => _ProfitCardState();
}

class _ProfitCardState extends State<ProfitCard> {
  final List<_ProfitData> _profitData = [];
  @override
  void initState() {
    super.initState();
    _profitData.addAll([
      _ProfitData(
        icon: AppIcons.day,
        title: 'Прибыль за день',
        amount: widget.profitData.dailyProfit,
        growth: widget.profitData.monthlyGrowth,
      ),
      _ProfitData(
        icon: AppIcons.week,
        title: 'Прибыль за неделю',
        amount: widget.profitData.weeklyProfit,
        growth: widget.profitData.monthlyGrowth,
      ),
      _ProfitData(
        icon: AppIcons.month,
        title: 'Прибыль за месяц',
        amount: widget.profitData.monthlyProfit,
        growth: widget.profitData.monthlyGrowth,
      ),
      _ProfitData(
        icon: AppIcons.year,
        title: 'Общий прибыль',
        amount: widget.profitData.totalProfit,
        growth: widget.profitData.monthlyGrowth,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255.0,
      // width: 780,
      child: DashboardSectionCard(
        title: 'Статистика оборота',
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
        children: [
          SizedBox(height: 5.0),
          Text(
            'Прибыль',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Color(0xFFA0A0A0),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 20.0,
            children: _profitData.map((e) {
              return _buildProfitItem(e);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitItem(_ProfitData data) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(14.0).copyWith(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(data.icon),
            SizedBox(height: 13.0),
            Text(
              data.amount.formatCurrency(),
              style: GoogleFonts.inter(
                fontSize: setSize(data.amount),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.0),
            Text(data.title, style: GoogleFonts.inter(fontSize: 10.0)),
            SizedBox(height: 16.0),
            _buildGrowthIndicator(data.growth),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthIndicator(double growth) {
    if (growth >= 0) {
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_downward, size: 10.0, color: AppColors.error),
          Text(
            "$growth%",
            style: GoogleFonts.inter(fontSize: 10.0, color: AppColors.error),
          ),
          Text(" с прошлого месяца", style: GoogleFonts.inter(fontSize: 10.0)),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_upward, size: 10.0, color: Color(0xFF1BB90C)),
        Text(
          "$growth%",
          style: GoogleFonts.inter(fontSize: 10.0, color: Color(0xFF1BB90C)),
        ),
        Text(" с прошлого месяца", style: GoogleFonts.inter(fontSize: 10.0)),
      ],
    );
  }

  double setSize(double value) {
    if (value < 10000000) {
      return 16.0;
    } else if (value >= 10000000) {
      return 15.0;
    } else {
      return 14.0;
    }
  }
}

class _ProfitData {
  final String icon;
  final String title;
  final double amount;
  final double growth;

  _ProfitData({
    required this.icon,
    required this.title,
    required this.amount,
    required this.growth,
  });
}
