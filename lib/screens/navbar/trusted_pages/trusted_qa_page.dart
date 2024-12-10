import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/utils/size.dart';

class TrustedQaPage extends StatelessWidget {
  const TrustedQaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: LandingAppBar(
          showBackArrow: true,
          leadingImage: 'assets/images/tqa.png',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.getResponsiveWidth(
                context: context, portionWidthValue: AppSpace.bodyPadding),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 20.0),
                      ),
                      const Text(
                        'Trusted Quality Assurance',
                        style: TextStyle(
                            color: BaseColorTheme.primaryRedColor,
                            fontSize: 20.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 20.0),
                      ),
                      const Text(
                        'How to Secure Your Warranty',
                        style: TextStyle(
                            color: BaseColorTheme.primaryGreenColor,
                            fontSize: 15.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 20.0),
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Register Your Product: ',
                              style: TextStyle(
                                color: BaseColorTheme.unselectedIconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'To benefit from our warranty, simply register your NGK & NTK product with us. Provide all necessary information and select the nearest trusted garage for your product registration.',
                              style: TextStyle(
                                color: BaseColorTheme.unselectedIconColor, // Default color for this text
                                fontSize: 14.0,
                                fontWeight: BaseFontWeights.regular
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0)
                      ), // Space between sections
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Visit Trusted Garages: ',
                              style: TextStyle(
                                color: BaseColorTheme.unselectedIconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'For any warranty claims, users must visit the garage where the product was initially installed. There, you can get your claim registration done seamlessly.',
                              style: TextStyle(
                                  color: BaseColorTheme.unselectedIconColor, // Default color for this text
                                  fontSize: 14.0,
                                  fontWeight: BaseFontWeights.regular
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0)
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Claim Review and Replacement: ',
                              style: TextStyle(
                                color: BaseColorTheme.unselectedIconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Once your claim is registered, our dedicated XYZ team will review and confirm its validity. If the product is found faulty, we will replace it with a new one.',
                              style: TextStyle(
                                  color: BaseColorTheme.unselectedIconColor, // Default color for this text
                                  fontSize: 14.0,
                                  fontWeight: BaseFontWeights.regular
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0)
                      ),
                      const Text("Join the Trusted Quality Assurance Program for premium support and unmatched service. Your satisfaction is our top priority.",
                      style: TextStyle(
                        color: BaseColorTheme.primaryGreenColor,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: BaseFontWeights.semiBold,
                      ),)
                    ]),
              ),
              SizedBox(
                height: ScreenUtils.getResponsiveHeight(
                    context: context, portionHeightValue: 29.09),
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
