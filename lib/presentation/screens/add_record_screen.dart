import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/daily_record.dart';
import '../providers/record_provider.dart';
import '../widgets/senior_input.dart';
import '../../utils/app_styles.dart';

class AddRecordScreen extends StatefulWidget {
  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  // Controladores de texto para capturar lo que escribe el usuario
  final _soupCtrl = TextEditingController();
  final _mainDishCtrl = TextEditingController();
  final _extraDishCtrl = TextEditingController(); // Opcional
  final _juiceCtrl = TextEditingController();

  final _qtyLunchCtrl = TextEditingController();
  final _qtyExtraCtrl = TextEditingController();
  final _expensesCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // Limpieza de memoria
    _soupCtrl.dispose();
    _mainDishCtrl.dispose();
    _extraDishCtrl.dispose();
    _juiceCtrl.dispose();
    _qtyLunchCtrl.dispose();
    _qtyExtraCtrl.dispose();
    _expensesCtrl.dispose();
    super.dispose();
  }

  void _confirmarYGuardar() {
    // 1. Validaciones básicas
    if (_soupCtrl.text.isEmpty || _mainDishCtrl.text.isEmpty || _qtyLunchCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Faltan datos obligatorios (Sopa, Segundo o Cantidades)",
                style: TextStyle(fontSize: 20)),
            backgroundColor: AppStyles.errorColor,
            padding: EdgeInsets.all(20),
          )
      );
      return;
    }

    // 2. Convertir texto a números
    final int cantAlmuerzos = int.tryParse(_qtyLunchCtrl.text) ?? 0;
    final int cantExtras = int.tryParse(_qtyExtraCtrl.text) ?? 0;
    final double gastos = double.tryParse(_expensesCtrl.text.replaceAll(',', '.')) ?? 0.0;

    // 3. Crear objeto temporal para calcular
    final nuevoRegistro = DailyRecord(
      date: DateTime.now(),
      soup: _soupCtrl.text,
      mainDish: _mainDishCtrl.text,
      extraDish: _extraDishCtrl.text,
      juice: _juiceCtrl.text,
      soldLunches: cantAlmuerzos,
      soldExtras: cantExtras,
      totalExpenses: gastos,
    );

    // 4. Diálogo de Confirmación (Muy útil para seniors)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¿Guardar este día?", style: AppStyles.titleStyle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vendido: \$${nuevoRegistro.totalIncome.toStringAsFixed(2)}", style: AppStyles.labelStyle),
            Text("Gastado: \$${nuevoRegistro.totalExpenses.toStringAsFixed(2)}", style: AppStyles.labelStyle),
            Divider(thickness: 2),
            Text("Ganancia: \$${nuevoRegistro.netBalance.toStringAsFixed(2)}",
                style: AppStyles.moneyStyle.copyWith(fontSize: 28)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancelar
            child: Text("REVISAR", style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppStyles.accentColor),
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              _guardarEnBaseDeDatos(nuevoRegistro); // Guardar real
            },
            child: Text("SÍ, GUARDAR", style: TextStyle(fontSize: 18, color: Colors.white)),
          )
        ],
      ),
    );
  }

  Future<void> _guardarEnBaseDeDatos(DailyRecord registro) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<RecordProvider>(context, listen: false).addRecord(registro);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("¡Guardado correctamente!", style: TextStyle(fontSize: 20)))
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar: $e"), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Registro"), backgroundColor: AppStyles.primaryColor),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("1. El Menú"),
            SeniorInput(label: "Sopa", controller: _soupCtrl),
            SeniorInput(label: "Segundo Principal", controller: _mainDishCtrl),
            SeniorInput(label: "Jugo", controller: _juiceCtrl),
            SeniorInput(label: "Segundo Extra (Opcional)", controller: _extraDishCtrl),

            SizedBox(height: 20),
            _buildHeader("2. Las Cuentas"),

            Row(
              children: [
                Expanded(child: SeniorInput(label: "Cant. Almuerzos", controller: _qtyLunchCtrl, isNumber: true)),
                SizedBox(width: 20),
                Expanded(child: SeniorInput(label: "Cant. Segundos", controller: _qtyExtraCtrl, isNumber: true)),
              ],
            ),

            SeniorInput(label: "Total Gastado en Mercado (\$)", controller: _expensesCtrl, isNumber: true),

            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: _confirmarYGuardar,
                child: Text("CALCULAR Y GUARDAR",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.titleStyle.copyWith(color: AppStyles.primaryColor)),
          Divider(thickness: 2, color: AppStyles.primaryColor),
        ],
      ),
    );
  }
}