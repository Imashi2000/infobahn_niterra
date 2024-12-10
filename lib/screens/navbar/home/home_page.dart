import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/widgets/auth_button.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/screens/auth/sign_in_page.dart';
import 'package:niterra/screens/navbar/home/home_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/no_content_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_program_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_qa_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_retailer_tab_page.dart';
import 'package:niterra/utils/size.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  BottomBarEnum selectedPage = BottomBarEnum.Home;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColorTheme.whiteTextColor,
      body: _getBody(selectedPage),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 12.0),
          horizontal: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 12.0)
        ),
        child: BottomBar(
          onChanged: (BottomBarEnum type){
            setState(() {
              selectedPage = type;
            });
          },
        ),
      ),
    );
  }

  Widget _getBody(BottomBarEnum selectedPage) {
    switch (selectedPage) {
      case BottomBarEnum.Home:
        return HomeTabPage();
      case BottomBarEnum.TQA:
        return TrustedQaPage();
      case BottomBarEnum.Trustedprog:
        return const TrustedProgramTabPage();
      case BottomBarEnum.Loyalty:
        return NoContentPage();
      case BottomBarEnum.Account:
        return SignInPage();
      default:
        return const Center(
          child: Text("Home Page Content"),
        );
    }
  }
}



