import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/utils/size.dart';

class ReferenceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  const ReferenceDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GarageAppBar(
          isDetailsPage: true,
          detailsTitle: 'James Garage',
          showBackIcon: true,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 150.0)
                  ),
                  child: Image.asset(
                    'assets/images/bgSettings.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(
                    horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DASHBOARD',
                        style: TextStyle(
                            color: BaseColorTheme.headingTextColor,
                            fontSize: 22.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 32.0),
                      ),
                      const Text(
                        'Details',
                        style: TextStyle(
                            color: BaseColorTheme.subHeadingTextColor,
                            fontSize: 20.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 14.0),
                      ),
                      detailsWidget(
                        itemTitle: 'Sl No: ',
                        itemValue: item['Sl No'],
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 18.0),
                      ),
                      detailsWidget(
                        itemTitle: 'Product Type: ',
                        itemValue: item['Product Type'],
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 18.0),
                      ),
                      detailsWidget(
                        itemTitle: 'Competitor Part No: ',
                        itemValue: item['Competitor Part No'],
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 18.0),
                      ),
                      detailsWidget(
                        itemTitle: 'Competitor: ',
                        itemValue: item['Competitor'],
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 18.0),
                      ),
                      detailsWidget(
                        itemTitle: 'NGK/NTK Part No: ',
                        itemValue: item['NGK/NTK Part No'],
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 43.0),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BaseColorTheme.greyTextColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          )
                        ),
                          onPressed: (){
                            Get.back();
                          },
                          child: const Text(
                            'Go Back',
                            style: TextStyle(
                              color: BaseColorTheme.whiteTextColor,
                              fontWeight: BaseFontWeights.medium,
                              fontSize: 12.0
                            ),
                          )
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 42.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Image.asset(
                          'assets/images/details.png',
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class detailsWidget extends StatelessWidget {
  final String itemTitle;
  final String itemValue;
  const detailsWidget({
    super.key,
    required this.itemTitle,
    required this.itemValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          itemTitle,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: BaseFontWeights.semiBold,
            color: BaseColorTheme.unselectedIconColor
        )
        ),
        Text(
          itemValue,
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: BaseFontWeights.medium,
                color: BaseColorTheme.unselectedIconColor
            )
        )
      ],
    );
  }
}
