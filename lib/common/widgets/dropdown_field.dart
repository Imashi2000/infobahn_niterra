import 'package:flutter/material.dart';

class DropdownFieldBox extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final bool enabled;

  // Constructor to initialize the fields
  DropdownFieldBox({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.enabled = true, // Default value to true
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
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          value: value,
          onChanged: enabled ? onChanged : null, // Disable interaction if not enabled
          validator: (value) => value == null || value.isEmpty
              ? 'Please select $label'
              : null,
          disabledHint: Text(value ?? hint), // Show hint or selected value when disabled
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
