import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/record_provider.dart';
import '../../domain/entities/daily_record.dart';
import '../../utils/app_styles.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context);

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Reporte Semanal", style: TextStyle(fontSize: 24)),
        backgroundColor: AppStyles.primaryColor,
        toolbarHeight: 80,
      ),
      body: StreamBuilder<List<DailyRecord>>(
        stream: provider.recordsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final records = snapshot.data!;
          if (records.isEmpty) {
            return Center(child: Text("No hay datos para generar reportes"));
          }

          final weeklyData = _agruparPorSemanas(records);

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: weeklyData.length,
            itemBuilder: (context, index) {
              return _WeeklyCard(data: weeklyData[index]);
            },
          );
        },
      ),
    );
  }

  List<WeeklySummary> _agruparPorSemanas(List<DailyRecord> records) {
    Map<DateTime, WeeklySummary> groups = {};

    for (var record in records) {
      final difference = record.date.weekday - 1;
      final monday = DateTime(record.date.year, record.date.month, record.date.day - difference);

      if (!groups.containsKey(monday)) {
        groups[monday] = WeeklySummary(startDate: monday);
      }

      groups[monday]!.addRecord(record);
    }

    final lista = groups.values.toList();
    lista.sort((a, b) => b.startDate.compareTo(a.startDate));
    return lista;
  }
}

class WeeklySummary {
  final DateTime startDate;
  double totalIncome = 0;
  double totalExpenses = 0;
  double totalProfit = 0;
  int daysCount = 0;

  WeeklySummary({required this.startDate});

  void addRecord(DailyRecord record) {
    totalIncome += record.totalIncome;
    totalExpenses += record.totalExpenses;
    totalProfit += record.netBalance;
    daysCount++;
  }

  DateTime get endDate => startDate.add(Duration(days: 6));
}

class _WeeklyCard extends StatelessWidget {
  final WeeklySummary data;

  const _WeeklyCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final startStr = DateFormat('d MMM', 'es').format(data.startDate);
    final endStr = DateFormat('d MMM', 'es').format(data.endDate);

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.green[800]),
                    SizedBox(width: 10),
                    Text("$startStr - $endStr",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Text("${data.daysCount} días", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _filaDato("Ventas Totales", data.totalIncome, Colors.black87),
                SizedBox(height: 10),
                _filaDato("Gastos Totales", data.totalExpenses, Colors.red[700]!),
                Divider(thickness: 2, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ganancia Neta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("\$${data.totalProfit.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green[800])),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaDato(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        Text("\$${value.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}