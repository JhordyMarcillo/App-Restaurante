import 'package:flutter/material.dart';
import '../../domain/entities/daily_record.dart';
import '../../domain/repositories/i_record_repository.dart';

class RecordProvider extends ChangeNotifier {
  final IRecordRepository _repository;

  RecordProvider(this._repository);

  Stream<List<DailyRecord>> get recordsStream => _repository.getRecordsStream();

  Future<void> addRecord(DailyRecord record) async {
    try {
      await _repository.saveRecord(record);
      notifyListeners();
    } catch (e) {
      print("Error al guardar: $e");
      rethrow;
    }
  }
}