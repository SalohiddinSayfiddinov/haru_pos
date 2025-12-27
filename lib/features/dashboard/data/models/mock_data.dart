import 'package:haru_pos/features/dashboard/data/models/dashboard_model.dart';

class MockData {
  static final profitData = ProfitData(
    dailyProfit: 1500000,
    weeklyProfit: 7400000,
    monthlyProfit: 31580000,
    totalProfit: 136580000,
    monthlyGrowth: 30.5,
    yearlyGrowth: 30.5,
  );

  static final employees = [
    Employee(name: 'Кобилов Одил', position: 'Кассир'),
    Employee(name: 'Кобилов Одил', position: 'Официант'),
    Employee(name: 'Кобилов Одил', position: 'Кассир'),
  ];

  static final topProducts = [
    Product(rank: 1, name: 'Роллы', popularity: 0, salesPercentage: 46),
    Product(rank: 2, name: 'Макидзуси', popularity: 0, salesPercentage: 17),
    Product(rank: 3, name: 'Хосомаки', popularity: 0, salesPercentage: 19),
    Product(rank: 4, name: 'Футомаки', popularity: 0, salesPercentage: 29),
  ];

  static final orders = [
    Order(
      tableNumber: 1,
      items: 'Роллы, Макидзуси, Хосомаки',
      price: '267,000 сум',
      waiter: 'Кабилов Одил',
      status: OrderStatus.notPaid,
    ),
    Order(
      tableNumber: 2,
      items: 'Роллы, Макидзуси, Хосомаки',
      price: '267,000 сум',
      waiter: 'Кабилов Одил',
      status: OrderStatus.notPaid,
    ),
    Order(
      tableNumber: 3,
      items: 'Роллы, Макидзуси, Хосомаки',
      price: '267,000 сум',
      waiter: 'Кабилов Одил',
      status: OrderStatus.notPaid,
    ),
    Order(
      tableNumber: 4,
      items: '-',
      price: '-',
      waiter: '-',
      status: OrderStatus.empty,
    ),
    Order(
      tableNumber: 5,
      items: '',
      price: '',
      waiter: '',
      status: OrderStatus.free,
    ),
    Order(
      tableNumber: 6,
      items: '',
      price: '',
      waiter: '',
      status: OrderStatus.free,
    ),
  ];

  static final averageBillData = AverageBillData(
    currentAverage: 267000,
    previousAverage: 204500,
    growthPercentage: 30.5,
    dailyData: [
      BillDataPoint(day: 'ПН', amount: 245000, previousAmount: 189000),
      BillDataPoint(day: 'ВТ', amount: 278000, previousAmount: 215000),
      BillDataPoint(day: 'СР', amount: 312000, previousAmount: 238000),
      BillDataPoint(day: 'ЧТ', amount: 295000, previousAmount: 224000),
      BillDataPoint(day: 'ПТ', amount: 356000, previousAmount: 272000),
      BillDataPoint(day: 'СБ', amount: 389000, previousAmount: 298000),
      BillDataPoint(day: 'ВС', amount: 275000, previousAmount: 210000),
    ],
  );
}
