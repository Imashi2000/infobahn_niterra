import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';

class TextFieldFormWithBorder extends StatefulWidget {
  final String label;
  final String? hint;
  final String? value;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final double width;
  final bool isPasswordField;
  final bool isConfirmPasswordField;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? passwordController;
  final String? Function(String?)? validator;
  final bool? enabled;

  // Constructor to initialize required fields
  const TextFieldFormWithBorder({
    Key? key,
    required this.label,
    this.hint,
    required this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.width = 0,
    this.isPasswordField = false,
    this.isConfirmPasswordField = false,
    this.confirmPasswordController,
    this.passwordController,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<TextFieldFormWithBorder> createState() => _TextFieldFormWithBorderState();
}

class _TextFieldFormWithBorderState extends State<TextFieldFormWithBorder> {
  bool _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: widget.isPasswordField && _isPasswordHidden,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: BaseColorTheme.borderColor, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: BaseColorTheme.borderColor, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: BaseColorTheme.borderColor, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            suffixIcon: widget.isPasswordField
                ? IconButton(
              icon: Icon(
                _isPasswordHidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            )
                : null,
          ),
          enabled: widget.enabled,
          initialValue: widget.value,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.label}';
            }
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (widget.isConfirmPasswordField &&
                widget.passwordController?.text != value) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
