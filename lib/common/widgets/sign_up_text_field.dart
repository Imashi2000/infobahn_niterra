import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/utils/size.dart';

class CustomTextField extends StatelessWidget {
  final String textTitle;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.textTitle,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          textTitle,
          style: const TextStyle(
            color: Color.fromRGBO(66, 66, 66, 1),
            fontFamily: 'Inter',
            fontSize: 16,
            letterSpacing: 0,
            fontWeight: BaseFontWeights.semiBold,
            height: 1.375,
          ),
        ),
        SizedBox(
          height: ScreenUtils.getResponsiveHeight(
              context: context, portionHeightValue: 8.0),
        ),
        SizedBox(
          height: ScreenUtils.getResponsiveHeight(
              context: context, portionHeightValue: 48.0),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: BaseColorTheme.unselectedIconColor,
                fontSize: 12.0,
                fontWeight: BaseFontWeights.regular,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: BaseColorTheme.borderColor,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: BaseColorTheme.borderColor,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: BaseColorTheme.borderColor,
                  width: 2.0,
                ),
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}

