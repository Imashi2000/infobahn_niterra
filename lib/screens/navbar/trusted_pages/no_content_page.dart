import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/utils/size.dart';


class NoContentPage extends StatelessWidget {
  const NoContentPage({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue:20),
                    ),
                    const Text(
                      'Loyalty',
                      style: TextStyle(
                          color: BaseColorTheme.primaryRedColor,
                          fontSize: 20.0,
                          fontWeight: BaseFontWeights.semiBold
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                            spreadRadius: 1, // Spread radius
                            blurRadius: 5, // Blur radius
                            //offset: Offset(0, 3), // Changes the position of the shadow
                          ),
                        ],
                        border: Border.all(
                          color: Colors.black12, // Border color
                          width: 2.0, // Border width
                        ),
                        color: Colors.white, // Background color
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0), // Match Container's border radius
                        child: Image.asset(
                          'assets/images/loyalty.png',
                          fit: BoxFit.cover, // Adjust the image to fit within the container
                        ),
                      ),
                    ),
      
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0),
                    ),
                    Text(
                      'PLATINUMPOINTS is a loyalty program initiated by Niterra Middle East FZE, aimed for workshops & Garages. Under the program, members who buy and use Niterra products can collect packaging boxes, earn points and rewarded with a wide range of gifts available at rewards portal.',
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
                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 60.0),
              ),
              AuthSection(
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
