import 'package:flutter/material.dart';

class TextFieldForm extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final bool? enabled;
  final TextEditingController? controller;


  // Constructor to initialize required fields
  const TextFieldForm({
    Key? key,
    required this.label,
    required this.hint,
    this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.controller,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12),
          ),
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          controller: controller,
          enabled: enabled,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
