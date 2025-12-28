import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';
import '../widgets/senior_input.dart';
import 'sales_entry_screen.dart'; // Importamos el paso 2

class MenuEntryScreen extends StatefulWidget {
  @override
  _MenuEntryScreenState createState() => _MenuEntryScreenState();
}

class _MenuEntryScreenState extends State<MenuEntryScreen> {
  final _soupCtrl = TextEditingController();
  final _mainDishCtrl = TextEditingController();
  final _sidesCtrl = TextEditingController();
  final _juiceCtrl = TextEditingController();
  final _extraDishCtrl = TextEditingController();

  void _irAlSiguientePaso() {
    // Validación simple
    if (_soupCtrl.text.isEmpty || _mainDishCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor escriba la Sopa y el Segundo", style: TextStyle(fontSize: 20)))
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesEntryScreen(
          soup: _soupCtrl.text,
          mainDish: _mainDishCtrl.text,
          sides: _sidesCtrl.text,
          juice: _juiceCtrl.text,
          extraDish: _extraDishCtrl.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paso 1: El Menú"), backgroundColor: AppStyles.primaryColor),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("La comida de hoy:", style: AppStyles.titleStyle),
            SizedBox(height: 20),

            SeniorInput(label: "1. Sopa", controller: _soupCtrl),
            SeniorInput(label: "2. Segundo Principal", controller: _mainDishCtrl),

            SeniorInput(label: "3. Acompañamiento", controller: _sidesCtrl),

            SeniorInput(label: "4. Jugo", controller: _juiceCtrl),

            Divider(thickness: 2, height: 40),
            SeniorInput(label: "Segundo Extra (Opcional)", controller: _extraDishCtrl),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppStyles.primaryColor),
                onPressed: _irAlSiguientePaso,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Siguiente", style: TextStyle(fontSize: 22, color: Colors.white)),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 30)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}