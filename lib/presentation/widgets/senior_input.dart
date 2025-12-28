import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class SeniorInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isNumber;

  const SeniorInput({
    Key? key,
    required this.label,
    required this.controller,
    this.isNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppStyles.labelStyle),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: AppStyles.inputTextStyle,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15
              ),
            ),
          ),
        ],
      ),
    );
  }
}