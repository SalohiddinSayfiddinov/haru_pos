class Employee {
  final String name;
  final String position;

  Employee({required this.name, required this.position});
}

class Product {
  final int rank;
  final String name;
  final int popularity;
  final int salesPercentage;

  Product({
    required this.rank,
    required this.name,
    required this.popularity,
    required this.salesPercentage,
  });
}

class Order {
  final int tableNumber;
  final String items;
  final String price;
  final String waiter;
  final OrderStatus status;

  Order({
    required this.tableNumber,
    required this.items,
    required this.price,
    required this.waiter,
    required this.status,
  });
}

enum OrderStatus { notPaid, empty, free }

class ProfitData {
  final double dailyProfit;
  final double weeklyProfit;
  final double monthlyProfit;
  final double totalProfit;
  final double monthlyGrowth;
  final double yearlyGrowth;

  ProfitData({
    required this.dailyProfit,
    required this.weeklyProfit,
    required this.monthlyProfit,
    required this.totalProfit,
    required this.monthlyGrowth,
    required this.yearlyGrowth,
  });
}

class AverageBillData {
  final List<BillDataPoint> dailyData;
  final double currentAverage;
  final double previousAverage;
  final double growthPercentage;

  AverageBillData({
    required this.dailyData,
    required this.currentAverage,
    required this.previousAverage,
    required this.growthPercentage,
  });
}

class BillDataPoint {
  final String day;
  final double amount;
  final double previousAmount;

  BillDataPoint({
    required this.day,
    required this.amount,
    required this.previousAmount,
  });
}
