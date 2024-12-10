import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niterra/utils/size.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String btnText;
  final Color buttonColor;
  final double buttonHeight;
  final double buttonWidth;
  final double buttonBorderRaduis;
  final Color buttonTextColor;
  final FontWeight buttonFontWeight;
  final double buttonFontSize;
  const CommonButton({
    required this.btnText,
    required this.buttonColor,
    this.onPressed,
  required this.buttonHeight,
  required this.buttonWidth,
    required this.buttonBorderRaduis,
    required this.buttonTextColor,
    required this.buttonFontWeight,
    required this.buttonFontSize,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonBorderRaduis)
      ),
      width: buttonWidth,
      height: buttonHeight,
      child: Center(
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonBorderRaduis),
              ),
            ),
            child: Center(
              child: Text(
                btnText,
                style:  GoogleFonts.inter(
                    color: buttonTextColor,
                    fontWeight: buttonFontWeight,
                    fontSize: buttonFontSize,
                ),
              ),
            )
        ),
      ),
    );
  }
}
