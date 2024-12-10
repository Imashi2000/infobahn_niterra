import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/auth/sign_in_page.dart';
import 'package:niterra/screens/garage/dashboard_page.dart';
import 'package:niterra/screens/navbar/home/home_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/no_content_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_program_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_qa_page.dart';
import 'package:niterra/utils/size.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  final List<Widget> pages = [
    const HomeTabPage(),
    const TrustedQaPage(),
    const TrustedProgramTabPage(),
    const NoContentPage(),
    const SignInPage(),
  ];

  int selectedIndex = 0;

  final List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: Icons.home_filled,
      title: 'Home',
    ),
    BottomMenuModel(
      icon: Icons.message,
      title: 'TQA',
    ),
    BottomMenuModel(
      icon: Icons.stars,
      title: 'Trusted Prog',
    ),
    BottomMenuModel(
      icon: Icons.loyalty,
      title: 'Loyalty',
    ),
    BottomMenuModel(
      icon: Icons.account_circle_rounded,
      title: 'Account',
    ),
  ];

  void onTap(int index) async {
    if (index == 4) { // Account menu item
      final userDetails = await UserPreferences.getUserDetails();
      if (userDetails['userId'] != null) {
        // User is logged in, navigate to GarageDashboardScreen
        Get.to(() => GarageDashboardScreen());
      } else {
        // User is not logged in, navigate to SignInPage
        Get.to(() => SignInPage());
      }
    } else {
      setState(() {
        selectedIndex = index; // Update selected index for other items
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: ScreenUtils.getResponsiveHeight(
              context: context, portionHeightValue: 16.0),
          left: ScreenUtils.getResponsiveWidth(
              context: context, portionWidthValue: 16.0),
          right: ScreenUtils.getResponsiveWidth(
              context: context, portionWidthValue: 16.0),
        ),
        child: Container(
          height: ScreenUtils.getResponsiveHeight(
              context: context, portionHeightValue: 60.0),
          decoration: BoxDecoration(
            color: BaseColorTheme.bottomBarColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: BaseColorTheme.shadowColor,
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              elevation: 0,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: List.generate(bottomMenuList.length, (index) {
                return BottomNavigationBarItem(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        bottomMenuList[index].icon,
                        color: selectedIndex == index
                            ? BaseColorTheme.selectedIconColor
                            : BaseColorTheme.unselectedIconColor,
                      ),
                      Text(
                        bottomMenuList[index].title ?? '',
                        style: GoogleFonts.inter(
                          color: selectedIndex == index
                              ? BaseColorTheme.selectedIconColor
                              : BaseColorTheme.unselectedIconColor,
                          fontWeight: selectedIndex == index
                              ? BaseFontWeights.bold
                              : BaseFontWeights.regular,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  label: '',
                );
              }),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomMenuModel {
  IconData icon;
  String? title;

  BottomMenuModel({
    required this.icon,
    this.title,
  });
}
