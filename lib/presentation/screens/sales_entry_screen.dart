import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/daily_record.dart';
import '../providers/record_provider.dart';
import '../widgets/senior_input.dart';
import '../../utils/app_styles.dart';

class SalesEntryScreen extends StatefulWidget {
  // Recibimos los datos del paso anterior
  final String soup, mainDish, sides, juice;
  final String? extraDish;

  const SalesEntryScreen({
    Key? key,
    required this.soup,
    required this.mainDish,
    required this.sides,
    required this.juice,
    this.extraDish,
  }) : super(key: key);

  @override
  _SalesEntryScreenState createState() => _SalesEntryScreenState();
}

class _SalesEntryScreenState extends State<SalesEntryScreen> {
  final _qtyLunchCtrl = TextEditingController();
  final _qtyExtraCtrl = TextEditingController();
  final _expensesCtrl = TextEditingController();
  bool _isLoading = false;

  void _confirmarYGuardar() {
    if (_qtyLunchCtrl.text.isEmpty || _expensesCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Faltan cantidades o gastos")));
      return;
    }

    // Convertir datos
    final int cantAlmuerzos = int.tryParse(_qtyLunchCtrl.text) ?? 0;
    final int cantExtras = int.tryParse(_qtyExtraCtrl.text) ?? 0;
    final double gastos = double.tryParse(_expensesCtrl.text.replaceAll(',', '.')) ?? 0.0;

    // Crear el objeto final
    final nuevoRegistro = DailyRecord(
      date: DateTime.now(),
      soup: widget.soup,
      mainDish: widget.mainDish,
      sides: widget.sides,
      juice: widget.juice,
      extraDish: widget.extraDish,
      soldLunches: cantAlmuerzos,
      soldExtras: cantExtras,
      totalExpenses: gastos,
    );

    // Diálogo de Confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Resumen Final", style: AppStyles.titleStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Venta Total: \$${nuevoRegistro.totalIncome.toStringAsFixed(2)}", style: TextStyle(fontSize: 20)),
            Text("Gastos: -\$${nuevoRegistro.totalExpenses.toStringAsFixed(2)}", style: TextStyle(fontSize: 20, color: Colors.red)),
            Divider(thickness: 2),
            Text("GANANCIA: \$${nuevoRegistro.netBalance.toStringAsFixed(2)}",
                style: AppStyles.moneyStyle),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppStyles.accentColor),
            onPressed: () {
              Navigator.pop(context); // Cerrar alerta
              _guardarRealmente(nuevoRegistro);
            },
            child: Text("FINALIZAR Y GUARDAR", style: TextStyle(fontSize: 18, color: Colors.white)),
          )
        ],
      ),
    );
  }

  Future<void> _guardarRealmente(DailyRecord registro) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<RecordProvider>(context, listen: false).addRecord(registro);
      // Regresar hasta el Home (quitando todas las pantallas de registro)
      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("¡Día registrado con éxito!"), backgroundColor: Colors.green)
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paso 2: Ventas y Gastos"), backgroundColor: AppStyles.primaryColor),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("¿Cuánto se vendió hoy?", style: AppStyles.titleStyle),
            SizedBox(height: 20),

            SeniorInput(label: "Cantidad de Almuerzos", controller: _qtyLunchCtrl, isNumber: true),
            SeniorInput(label: "Cantidad de Segundos", controller: _qtyExtraCtrl, isNumber: true),

            Divider(thickness: 2, height: 40),

            Text("¿Cuánto se gastó?", style: AppStyles.titleStyle),
            SizedBox(height: 10),
            SeniorInput(label: "Dinero gastado en mercado (\$)", controller: _expensesCtrl, isNumber: true),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppStyles.accentColor),
                onPressed: _confirmarYGuardar,
                child: Text("GUARDAR TODO", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}