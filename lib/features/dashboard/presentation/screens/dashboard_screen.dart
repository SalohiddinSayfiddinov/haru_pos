import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haru_pos/core/locale/locale_keys.g.dart';
import 'package:haru_pos/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:haru_pos/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:haru_pos/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/average_bill_section.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/employees_section.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/profit_card.dart';
import 'package:haru_pos/features/dashboard/presentation/widgets/top_products_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetDashboardData());
  }

  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLocale = context.locale;

    if (_lastLocale != currentLocale) {
      _lastLocale = currentLocale;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final bool isSmallScreen = width < 1750;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DashboardLoaded) {
          final data = state.dashboardData;

          return Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.dashboard_title.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Row(
                          spacing: 25,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfitCard(profitData: data.profit),
                            if (!isSmallScreen)
                              EmployeesSection(employees: state.employees),
                          ],
                        ),

                        const SizedBox(height: 25),

                        Row(
                          spacing: 25,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopProductsSection(products: data.topProducts),
                            if (!isSmallScreen)
                              AverageBillSection(
                                averageBillData: data.averageCheck,
                              ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        if (isSmallScreen)
                          Row(
                            children: [
                              Expanded(
                                child: EmployeesSection(
                                  employees: state.employees,
                                ),
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: AverageBillSection(
                                  averageBillData: data.averageCheck,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
