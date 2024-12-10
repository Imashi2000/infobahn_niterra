import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/utils/size.dart'; // Import your ScreenUtils

class GarageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackIcon;
  final bool? isDetailsPage;
  final String? detailsTitle;
  final VoidCallback? onMenuTap; // Add this parameter
  final VoidCallback? onBackTap;

  GarageAppBar({
    required,
    this.showBackIcon = false,
    this.isDetailsPage = false,
    this.detailsTitle = '',
    this.onMenuTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.getResponsiveWidth(
              context: context, portionWidthValue: 6.0),
          right: ScreenUtils.getResponsiveWidth(
              context: context, portionWidthValue: 6.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (showBackIcon)
                  GestureDetector(
                    onTap: onBackTap ?? () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      color: BaseColorTheme.headingTextColor,
                    ),
                  )
                else if (onMenuTap != null)
                  GestureDetector(
                    onTap: onMenuTap,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: 16.0,
                        width: 20.0,
                        child: Center(
                          child: Image.asset(
                           'assets/images/menu-icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isDetailsPage!)
              Center(
                  child: Text(
                detailsTitle.toString(),
                style: const TextStyle(
                    color: BaseColorTheme.headingTextColor,
                    fontSize: 14.0,
                    fontWeight: BaseFontWeights.medium),
              ))
            else
              Center(
                child: Image.asset(
                  'assets/images/tp.png',
                  width: 136.0,
                  height: 58.0,
                ),
              ),
            GestureDetector(
              child: CircleAvatar(
                radius: 18.0,
                backgroundColor: Colors.grey[200],
                backgroundImage: const AssetImage('assets/images/profile.png'),
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
