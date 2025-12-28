import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/daily_record.dart';
import '../../utils/app_styles.dart';

class RecordDetailScreen extends StatelessWidget {
  final DailyRecord record;

  const RecordDetailScreen({required this.record});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEEE, d MMMM yyyy', 'es').format(record.date);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Detalle del Día"),
        backgroundColor: AppStyles.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha Grande
            Center(
              child: Text(dateStr.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppStyles.titleStyle.copyWith(fontSize: 22)),
            ),
            Divider(thickness: 2, height: 40),

            // Resumen Financiero (Lo más importante)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.green, width: 2)
              ),
              child: Column(
                children: [
                  _filaResumen("Venta Total:", "\$${record.totalIncome.toStringAsFixed(2)}"),
                  SizedBox(height: 10),
                  _filaResumen("Gastos:", "-\$${record.totalExpenses.toStringAsFixed(2)}", isRed: true),
                  Divider(color: Colors.black),
                  _filaResumen("GANANCIA:", "\$${record.netBalance.toStringAsFixed(2)}", isBold: true),
                ],
              ),
            ),

            SizedBox(height: 30),
            Text("El Menú Vendido:", style: AppStyles.titleStyle),
            SizedBox(height: 15),

            _datoDetalle("Sopa", record.soup),
            _datoDetalle("Segundo", record.mainDish),
            _datoDetalle("Acompañamiento", record.sides ?? "Ninguno"),
            if (record.extraDish != null && record.extraDish!.isNotEmpty)
              _datoDetalle("Extra", record.extraDish!),
            _datoDetalle("Jugo", record.juice),

            SizedBox(height: 30),
            Text("Cantidades:", style: AppStyles.titleStyle),
            SizedBox(height: 15),

            _datoDetalle("Almuerzos", "${record.soldLunches}"),
            _datoDetalle("Segundos", "${record.soldExtras}"),
          ],
        ),
      ),
    );
  }

  Widget _filaResumen(String label, String value, {bool isRed = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
            fontSize: 20,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal
        )),
        Text(value, style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isRed ? AppStyles.errorColor : (isBold ? AppStyles.accentColor : Colors.black)
        )),
      ],
    );
  }

  Widget _datoDetalle(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(label + ":", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          ),
          Expanded(
            child: Text(valor, style: TextStyle(fontSize: 20, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}