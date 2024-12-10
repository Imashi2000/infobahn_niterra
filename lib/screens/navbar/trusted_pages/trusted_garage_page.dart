import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/utils/size.dart';

class TrustedGaragePage extends StatelessWidget {
  const TrustedGaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: LandingAppBar(
          showBackArrow: true,
          leadingImage: 'assets/images/tg.png',
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
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 16.5),
                    ),
                    const Text(
                      'Trusted Garage',
                      style: TextStyle(
                          color: BaseColorTheme.primaryRedColor,
                          fontSize: 20.0,
                          fontWeight: BaseFontWeights.semiBold
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 19.0),
                    ),
                    const Text(
                      'Trusted Garages are rigorously screened and assessed by our dedicated team to ensure they meet our high standards.'
                          'We take the following steps to maintain the integrity of our network: \n'
                      'Comprehensive Screening: Each garage undergoes thorough checks to ensure they are not engaged in any malpractice.\n'
                    'Rigorous Training: Our partners receive extensive training on the technical aspects of our product specially on how to distinguish between genuine and counterfeit items.\n'
                    'Technical Expertise: In addition to anti-counterfeiting training, they gain in-depth knowledge about the technical specifications and maintenance of all our products.',
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
                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 107.0),
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
