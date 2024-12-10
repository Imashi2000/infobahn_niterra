import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/widgets/bottombar.dart';
import 'package:niterra/screens/navbar/home/home_tab_page.dart';
import 'package:niterra/utils/size.dart'; // Import your ScreenUtils

class LandingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String leadingImage;
  final bool showBackArrow;
  final VoidCallback? onBackPressed;

  LandingAppBar({
    required this.leadingImage,
    this.showBackArrow = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 0.0),
          right: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBackArrow)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: onBackPressed ?? () => Get.to(BottomNavigationBarExample()),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:  Container(
                height: 60.0,
                width: 158.0,
                child: Center(
                  child: Image.asset(
                    leadingImage,
                    fit: BoxFit.contain, // Use BoxFit.contain to avoid cutting off the image
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 96.0,
              height: 25.0,
              child: Image.asset(
                'assets/images/logo.png'
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
