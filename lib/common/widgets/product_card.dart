import 'package:flutter/material.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/read_more_button.dart';
import 'package:niterra/utils/size.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductCard extends StatelessWidget {
  final String imgLink;
  final String titleText;
  final String body;
  final String url; // URL for this card

  const ProductCard({
    super.key,
    required this.imgLink,
    required this.titleText,
    required this.body,
    required this.url,
  });

  void _navigateToWebsite() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Log the error or show a message to the user
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        vertical: ScreenUtils.getResponsiveHeight(
          context: context,
          portionHeightValue: 10.0,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(
              ScreenUtils.getResponsiveWidth(
                context: context,
                portionWidthValue: 8.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.asset(
                imgLink,
                width: double.infinity,
                height: ScreenUtils.getResponsiveHeight(
                  context: context,
                  portionHeightValue: 200.0,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              ScreenUtils.getResponsiveWidth(
                context: context,
                portionWidthValue: 16.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    titleText,
                    style: TextStyle(
                      color: BaseColorTheme.subHeadingTextColor,
                      fontSize: ScreenUtils.getResponsiveWidth(
                        context: context,
                        portionWidthValue: 20.0,
                      ),
                      fontFamily: 'Inter',
                      fontWeight: BaseFontWeights.semiBold,
                    ),
                  ),
                ),
                ScreenUtils.heightSpace(8.0, context),
                Padding(
                  padding: EdgeInsets.all(
                    ScreenUtils.getResponsiveWidth(
                      context: context,
                      portionWidthValue: 10.0,
                    ),
                  ),
                  child: Text(
                    body,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                      fontFamily: 'Inter',
                      fontSize: ScreenUtils.getResponsiveWidth(
                        context: context,
                        portionWidthValue: 14.0,
                      ),
                      fontWeight: BaseFontWeights.regular,
                      height: 1.57,
                    ),
                  ),
                ),
                ScreenUtils.heightSpace(8.0, context),
                Padding(
                  padding: EdgeInsets.all(
                    ScreenUtils.getResponsiveWidth(
                      context: context,
                      portionWidthValue: 10.0,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ReadMoreButton(
                      onPressed: _navigateToWebsite,
                      btnText: 'Read More',
                      buttonColor: BaseColorTheme.primaryRedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

