import 'package:flutter/material.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Quantity',
      ),
    );
  }
}
