import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/utils/size.dart';

enum BottomBarEnum {Home, TQA, Trustedprog, Loyalty, Account}

class BottomBar extends StatefulWidget {
  Function(BottomBarEnum)? onChanged;
   BottomBar({
     this.onChanged,
     super.key,
});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
        icon: Icons.home_filled,
        type: BottomBarEnum.Home,
        title: 'Home'
    ),
    BottomMenuModel(
        icon: Icons.message,
        type: BottomBarEnum.TQA,
        title: 'TQA'
    ),
    BottomMenuModel(
        icon: Icons.stars,
        type: BottomBarEnum.Trustedprog,
        title: 'Trusted Prog'
    ),
    BottomMenuModel(
        icon: Icons.loyalty,
        type: BottomBarEnum.Loyalty,
        title: 'Loyalty'
    ),
    BottomMenuModel(
        icon: Icons.account_circle_rounded,
        type: BottomBarEnum.Account,
        title: 'Account'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 60.0),
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
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 0,
          elevation: 0,
          currentIndex: selectedIndex,
          items: List.generate(bottomMenuList.length, (index) {
            return BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  )
                ],
              ),
              label: '',
            );
          }),
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            widget.onChanged?.call(bottomMenuList[index].type);
          },
        ),
      ),
    );
  }
}


class BottomMenuModel{
  IconData icon;
  // String activeIcon;
  String? title;
  BottomBarEnum type;
  BottomMenuModel({
    required this.icon,
    // required this.activeIcon,
    this.title,
    required this.type
});
}
