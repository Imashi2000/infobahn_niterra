import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart'; // Import Get for navigation
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/auth_button.dart';
import 'package:niterra/utils/size.dart';

class SignUpButton extends StatelessWidget {
  final String btnText;
  final Color btnColor;
  final String sectionFirstText;
  final String sectionSecondText;
  final Color sectionSecondColor;
  final VoidCallback onPressed;
  final Widget navigateToPage; // Accept a widget to navigate to

  const SignUpButton({
    super.key,
    required this.btnText,
    required this.btnColor,
    required this.sectionFirstText,
    required this.sectionSecondText,
    required this.sectionSecondColor,
    required this.onPressed,
    required this.navigateToPage, // Initialize it
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1.0,
          color: BaseColorTheme.lineColor,
        ),
        SizedBox(
          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0),
        ),
        AuthButton(
          btnText: btnText,
          buttonColor: btnColor,
          onPressed: onPressed,
        ),
        SizedBox(
          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0),
        ),
        Row(
          children: [
            Text(
              sectionFirstText,
              style: GoogleFonts.inter(
                fontSize: 15.0,
                color: BaseColorTheme.greyTextColor,
              ),
            ),
            SizedBox(width: 8.0),
            InkWell(
              onTap: () {
                // Navigate dynamically using Get
                Get.to( navigateToPage);
              },
              child: Text(
                sectionSecondText,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: sectionSecondColor,
                  fontWeight: BaseFontWeights.semiBold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: BaseColorTheme.lineColor,
        ),
      ],
    );
  }
}
