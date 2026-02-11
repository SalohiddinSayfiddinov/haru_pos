import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final ProfitEntity profit;
  final List<TopProductEntity> topProducts;
  final AverageCheckEntity averageCheck;

  const DashboardEntity({
    required this.profit,
    required this.topProducts,
    required this.averageCheck,
  });

  @override
  List<Object> get props => [profit, topProducts, averageCheck];
}

class ProfitEntity extends Equatable {
  final ProfitPeriodEntity day;
  final ProfitPeriodEntity week;
  final ProfitPeriodEntity month;
  final ProfitPeriodEntity year;
  final ProfitPeriodEntity total;

  const ProfitEntity({
    required this.day,
    required this.week,
    required this.month,
    required this.year,
    required this.total,
  });

  @override
  List<Object> get props => [day, week, month, year, total];
}

class ProfitPeriodEntity extends Equatable {
  final int money;
  final bool status;
  final double percentage;

  const ProfitPeriodEntity({
    required this.money,
    required this.status,
    required this.percentage,
  });

  @override
  List<Object> get props => [money, status, percentage];
}

class TopProductEntity extends Equatable {
  final int id;
  final String name;
  final int soldCount;
  final double popularity;
  final double salesPercent;

  const TopProductEntity({
    required this.id,
    required this.name,
    required this.soldCount,
    required this.popularity,
    required this.salesPercent,
  });

  @override
  List<Object> get props => [id, name, soldCount, popularity, salesPercent];
}

class AverageCheckEntity extends Equatable {
  final double thisMonth;
  final double lastMonth;

  const AverageCheckEntity({required this.thisMonth, required this.lastMonth});

  @override
  List<Object> get props => [thisMonth, lastMonth];
}
