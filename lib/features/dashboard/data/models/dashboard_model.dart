import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.profit,
    required super.topProducts,
    required super.averageCheck,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      profit: ProfitModel.fromJson(json['profit'] ?? {}),
      topProducts: json['top_products'] != null
          ? List<TopProductModel>.from(
              json['top_products'].map((x) => TopProductModel.fromJson(x)),
            )
          : [],
      averageCheck: AverageCheckModel.fromJson(json['average_check'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profit': (profit as ProfitModel).toJson(),
      'top_products': topProducts
          .map((e) => (e as TopProductModel).toJson())
          .toList(),
      'average_check': (averageCheck as AverageCheckModel).toJson(),
    };
  }

  DashboardEntity toEntity() {
    return DashboardEntity(
      profit: profit,
      topProducts: topProducts,
      averageCheck: averageCheck,
    );
  }
}

class ProfitModel extends ProfitEntity {
  const ProfitModel({
    required super.day,
    required super.week,
    required super.month,
    required super.year,
    required super.total,
  });

  factory ProfitModel.fromJson(Map<String, dynamic> json) {
    return ProfitModel(
      day: ProfitPeriodModel.fromJson(json['day'] ?? {}),
      week: ProfitPeriodModel.fromJson(json['week'] ?? {}),
      month: ProfitPeriodModel.fromJson(json['month'] ?? {}),
      year: ProfitPeriodModel.fromJson(json['year'] ?? {}),
      total: ProfitPeriodModel.fromJson(json['total'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': (day as ProfitPeriodModel).toJson(),
      'week': (week as ProfitPeriodModel).toJson(),
      'month': (month as ProfitPeriodModel).toJson(),
      'year': (year as ProfitPeriodModel).toJson(),
      'total': (total as ProfitPeriodModel).toJson(),
    };
  }
}

class ProfitPeriodModel extends ProfitPeriodEntity {
  const ProfitPeriodModel({
    required super.money,
    required super.status,
    required super.percentage,
  });

  factory ProfitPeriodModel.fromJson(Map<String, dynamic> json) {
    return ProfitPeriodModel(
      money: json['money'] ?? 0,
      status: json['status'] ?? false,
      percentage: json['percentage']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'money': money, 'status': status, 'percentage': percentage};
  }
}

class TopProductModel extends TopProductEntity {
  const TopProductModel({
    required super.id,
    required super.name,
    required super.soldCount,
    required super.popularity,
    required super.salesPercent,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) {
    return TopProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      soldCount: json['sold_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
      salesPercent: (json['sales_percent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sold_count': soldCount,
      'popularity': popularity,
      'sales_percent': salesPercent,
    };
  }
}

class AverageCheckModel extends AverageCheckEntity {
  const AverageCheckModel({required super.thisMonth, required super.lastMonth});

  factory AverageCheckModel.fromJson(Map<String, dynamic> json) {
    return AverageCheckModel(
      thisMonth: (json['this_month'] ?? 0).toDouble(),
      lastMonth: (json['last_month'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'this_month': thisMonth, 'last_month': lastMonth};
  }
}
