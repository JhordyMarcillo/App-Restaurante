import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/record_provider.dart';
import '../../domain/entities/daily_record.dart';
import '../../utils/app_styles.dart';
import 'add_record_screen.dart';
import 'menu_entry_screen.dart';
import 'record_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordProvider>(context);

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text("Mis Ventas", style: TextStyle(fontSize: 24)),
        backgroundColor: AppStyles.primaryColor,
        toolbarHeight: 80, // AppBar más alta
      ),
      body: StreamBuilder<List<DailyRecord>>(
        stream: provider.recordsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error al cargar"));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final records = snapshot.data!;

          if (records.isEmpty) {
            return Center(
                child: Text("No hay registros aún.\nPresione + para agregar.",
                    textAlign: TextAlign.center,
                    style: AppStyles.labelStyle)
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _RecordCard(record: record);
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 80, height: 80,
        child: FloatingActionButton(
          backgroundColor: AppStyles.primaryColor,
          child: const Icon(Icons.add, size: 40),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => MenuEntryScreen())
            );
          },
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final DailyRecord record;
  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    // Formato de fecha simple y seguro
    final dateStr = DateFormat('dd/MM/yyyy').format(record.date);
    final dayName = DateFormat('EEEE', 'es').format(record.date); // Lunes, Martes...

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => RecordDetailScreen(record: record))
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dayName.toUpperCase(),
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(dateStr,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppStyles.primaryColor),
                ],
              ),
              Divider(thickness: 2, color: Colors.grey[300]),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Ganancia:", style: TextStyle(fontSize: 20, color: Colors.black87)),
                  Text("\$${record.netBalance.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppStyles.accentColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}