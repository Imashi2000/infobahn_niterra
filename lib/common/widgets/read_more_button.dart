import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/utils/size.dart';

class ReadMoreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String btnText;
  final Color buttonColor;
  const ReadMoreButton({
    required this.btnText,
    required this.buttonColor,
    this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0)
      ),
      width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 127),
      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 45),
      child: Center(
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Center(
              child: Text(
                btnText,
                style:  GoogleFonts.inter(
                    color: BaseColorTheme.whiteTextColor,
                    fontWeight: BaseFontWeights.extraBold,
                    fontSize: 16.0
                ),
              ),
            )
        ),
      ),
    );
  }
}
