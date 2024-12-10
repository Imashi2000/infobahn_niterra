import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/utils/size.dart';

class TrustedProgramTabPage extends StatelessWidget {
  const TrustedProgramTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: LandingAppBar(
          leadingImage: 'assets/images/tp.png',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.getResponsiveWidth(
                  context: context, portionWidthValue: AppSpace.bodyPadding),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             Container(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(
                     height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0),
                   ),
                   const Text(
                     'Trusted Program',
                     style: TextStyle(
                         color: BaseColorTheme.primaryRedColor,
                         fontSize: 20.0,
                         fontWeight: BaseFontWeights.semiBold
                     ),
                   ),
                   SizedBox(
                     height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 31.0),
                   ),
                   const Text(
                     'Our Trusted Garages and Retailers are a carefully selected network of '
                         'reliable partners committed to providing exceptional service and genuine products. '
                         'By choosing our Trusted Garages and Retailers, you can be confident in receiving '
                         'top-quality service and authentic products, backed by a network of professionals '
                         'dedicated to excellence.',
                     style: TextStyle(
                         color: Color.fromRGBO(0, 0, 0, 0.6000000238418579),
                         fontFamily: 'Inter',
                         fontSize: 14,
                         letterSpacing: 0,
                         fontWeight: BaseFontWeights.bold,
                         height: 1.5714285714285714),
                   ),
                 ],
               ),
             ),
              SizedBox(
                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 36.0),
              ),
              const AuthSection(
                btnText: 'SIGN UP NOW',
                btnColor: BaseColorTheme.primaryGreenColor,
                sectionFirstText: 'Already have an account?',
                sectionSecondText: 'Sign In',
                sectionSecondColor: BaseColorTheme.primaryRedColor,
                onPressed: (),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
