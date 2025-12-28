import 'package:flutter/material.dart';

class AppStyles {
  // Colores de Alto Contraste
  static const Color primaryColor = Color(0xFF1565C0); // Azul fuerte
  static const Color accentColor = Color(0xFF2E7D32);  // Verde fuerte (Dinero)
  static const Color errorColor = Color(0xFFD32F2F);   // Rojo fuerte (Alerta)
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris muy claro para fondo

  // Estilos de Texto (Grandes y Legibles)
  static const TextStyle titleStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 22,
    color: Colors.black,
  );

  static const TextStyle moneyStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: accentColor,
  );
}