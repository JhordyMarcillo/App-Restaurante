import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/daily_record.dart';
import '../../domain/repositories/i_record_repository.dart';
import '../models/record_model.dart';

class FirebaseRecordRepository implements IRecordRepository {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('daily_records');

  @override
  Future<void> saveRecord(DailyRecord record) async {
    // Convertimos la entidad de dominio a modelo de datos
    final model = RecordModel(
      date: record.date,
      soup: record.soup,
      mainDish: record.mainDish,
      sides: record.sides,
      extraDish: record.extraDish,
      juice: record.juice,
      soldLunches: record.soldLunches,
      soldExtras: record.soldExtras,
      totalExpenses: record.totalExpenses,
    );

    await _collection.add(model.toMap());
  }

  @override
  Stream<List<DailyRecord>> getRecordsStream() {
    return _collection
        .orderBy('date', descending: true) // Los más recientes primero
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecordModel.fromSnapshot(doc))
          .toList();
    });
  }
}