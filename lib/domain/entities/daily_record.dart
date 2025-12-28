class DailyRecord {
  final String? id;
  final DateTime date;

  // Menú
  final String soup;
  final String mainDish;
  final String? sides;
  final String? extraDish; // Opcional
  final String juice;

  final int soldLunches;
  final int soldExtras;
  final double totalExpenses;

  static const double PRICE_LUNCH = 3.50;
  static const double PRICE_EXTRA = 2.50;

  DailyRecord({
    this.id,
    required this.date,
    required this.soup,
    required this.mainDish,
    this.sides,
    this.extraDish,
    required this.juice,
    required this.soldLunches,
    required this.soldExtras,
    required this.totalExpenses,
  });


  double get totalIncome {
    return (soldLunches * PRICE_LUNCH) + (soldExtras * PRICE_EXTRA);
  }

  double get netBalance {
    return totalIncome - totalExpenses;
  }
}