import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/daily_record.dart';

class RecordModel extends DailyRecord {
  RecordModel({
    super.id,
    required super.date,
    required super.soup,
    required super.mainDish,
    super.sides,
    super.extraDish,
    required super.juice,
    required super.soldLunches,
    required super.soldExtras,
    required super.totalExpenses,
  });

  // Convertir de Firebase (Map) a Objeto Dart
  factory RecordModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RecordModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      soup: data['menu']['soup'] ?? '',
      mainDish: data['menu']['mainDish'] ?? '',
      sides: data['menu']['sides'] ?? '',
      extraDish: data['menu']['extraDish'],
      juice: data['menu']['juice'] ?? '',
      soldLunches: data['sales']['soldLunches'] ?? 0,
      soldExtras: data['sales']['soldExtras'] ?? 0,
      totalExpenses: (data['sales']['totalExpenses'] ?? 0).toDouble(),
    );
  }

  // Convertir de Objeto Dart a Firebase (Map)
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'menu': {
        'soup': soup,
        'mainDish': mainDish,
        'sides': sides,
        'extraDish': extraDish,
        'juice': juice,
      },
      'sales': {
        'soldLunches': soldLunches,
        'soldExtras': soldExtras,
        'totalExpenses': totalExpenses,
      },
      // Guardamos los calculados para consultas rápidas si fuera necesario
      'summary': {
        'totalIncome': totalIncome,
        'netBalance': netBalance,
      }
    };
  }
}