import '../entities/daily_record.dart';

abstract class IRecordRepository {
  Future<void> saveRecord(DailyRecord record);
  Stream<List<DailyRecord>> getRecordsStream();
}