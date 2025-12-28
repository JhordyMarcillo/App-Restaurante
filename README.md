# 🍲 Gestor de Almuerzos - App para Restaurante

Una aplicación móvil desarrollada en **Flutter**, diseñada específicamente para registrar y calcular las ventas diarias de un restaurante de almuerzos.

El foco principal de este proyecto es la **Accesibilidad (UI/UX)** para adultos mayores: textos grandes, alto contraste, navegación lineal y confirmaciones claras.

## 📱 Características Principales

* **Interfaz Senior-Friendly:** Botones grandes, tipografía legible y colores de alto contraste.
* **Registro en 2 Pasos:** 1.  **Menú:** Ingreso de Sopa, Segundo Principal, Acompañantes y Jugo.
    2.  **Caja:** Ingreso de cantidades vendidas y gastos de mercado.
* **Cálculos Automáticos:** El sistema calcula automáticamente el total vendido y la ganancia neta (Ventas - Gastos).
* **Historial en la Nube:** Todos los registros se guardan en **Firebase Firestore**, accesibles desde cualquier dispositivo autorizado.
* **Modo Offline:** Gracias a Firestore, la app guarda datos localmente si no hay internet y sincroniza al reconectarse.

## 🛠️ Tecnologías Utilizadas

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Backend / Base de Datos:** Firebase Firestore
* **Arquitectura:** MVVM (Model-View-ViewModel) con principios de Clean Architecture.
* **Gestión de Estado:** `provider`
* **Librerías Clave:**
    * `cloud_firestore`: Conexión a base de datos.
    * `intl`: Formato de fechas y moneda.
    * `flutter_launcher_icons`: Iconos personalizados.

## 📂 Estructura del Proyecto

El código está organizado para ser escalable y fácil de mantener:

```text
lib/
├── data/                  # Capa de Datos (Firebase)
│   ├── models/            # Modelos que traducen JSON <-> Dart
│   └── repositories/      # Implementación de la conexión a Firestore
│
├── domain/                # Capa de Dominio (Lógica pura)
│   ├── entities/          # Objetos de negocio (RegistroDiario)
│   └── repositories/      # Contratos (Interfaces) de lo que debe hacer la app
│
├── presentation/          # Capa Visual (UI)
│   ├── providers/         # Gestor de estado (conexión UI <-> Lógica)
│   ├── screens/           # Pantallas (Home, MenuEntry, SalesEntry, Detail)
│   └── widgets/           # Componentes reutilizables (SeniorInput)
│
└── utils/                 # Configuración Global
    └── app_styles.dart    # Colores y estilos de texto centralizados