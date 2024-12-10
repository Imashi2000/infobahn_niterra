import 'package:flutter/material.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/utils/size.dart';

class TrustedRetailerTabPage extends StatelessWidget {
  const TrustedRetailerTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: LandingAppBar(
          showBackArrow: true,
          leadingImage: 'assets/images/tr.png',
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
                      'Trusted Retailer',
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
                      'Similar to our garages, Trusted Retailers are chosen based on '
                          'their commitment to authenticity and quality. They receive the same level of '
                          'scrutiny and training to ensure they uphold the values of our Trusted Program',
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.6000000238418579),
                          fontFamily: 'Inter',
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: BaseFontWeights.regular,
                          height: 1.5714285714285714),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 327.09),
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
