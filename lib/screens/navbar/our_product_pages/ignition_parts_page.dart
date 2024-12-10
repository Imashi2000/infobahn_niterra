import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/common/widgets/product_card.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/screens/navbar/home/home_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_program_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_qa_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_retailer_tab_page.dart';
import 'package:niterra/utils/size.dart';

class IgnitionPartsPage extends StatefulWidget {
  IgnitionPartsPage({super.key});

  @override
  State<IgnitionPartsPage> createState() => _IgnitionPartsPageState();
}

class _IgnitionPartsPageState extends State<IgnitionPartsPage> {
  final List<Map<String, String>> products = [
    {
      'imgLink': 'assets/images/spark_plugs.png',
      'titleText': 'Spark Plugs',
      'body': 'The product for which Niterra is best known! Available for almost every engine type, spark plugs are a vital component when it comes to igniting the mixture of air and fuel inside the combustion chamber of a petrol engine. As a provider of spark plugs for OE and aftermarket customers, Niterra is continually improving its products with a view to making combustion in engines cleaner and more efficient.',
      'url':'https://www.ngkntk.com/products/spark-plugs/'
    },
    {
      'imgLink': 'assets/images/glow_plugs.png',
      'titleText': 'Glow Plugs',
      'body': 'Glow plugs enable optimal starting conditions and environmentally friendly combustion in diesel engines. With long-term experience in the development of glow plugs, both for OE and for the aftermarket, Niterra is continually setting new standards in the area of glow plug technology.',
      'url':'https://www.ngkntk.com/products/glow-plugs/'
    },
    {
      'imgLink': 'assets/images/leads_caps.png',
      'titleText': 'Ignition Leads & Caps',
      'body': 'Ignition leads and caps play a central role within the ignition process in many petrol engines. While ignition cables connect the ignition coils to the spark plugs, caps guarantee a secure connection between the spark plugs and the high-voltage ignition cable. Under extreme conditions such as heat and vibrations, NGK products impress on account of their reliability and efficient voltage transmission.',
      'url':'https://www.ngkntk.com/products/ignition-leads-caps/'
    },
    {
      'imgLink': 'assets/images/coils.png',
      'titleText': 'Ignition Coils',
      'body': 'Ignition coils supply high voltage to the spark plug, which is necessary in order to generate the ignition spark. The comprehensive NGK ignition coil range impresses with a high precision fit, exceptional vibration resistance, outstanding short circuit and moisture resistance, and a long service life.',
      'url':'https://www.ngkntk.com/products/ignition-coils/'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: LandingAppBar(
          leadingImage: 'assets/images/tp.png',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.getResponsiveWidth(
                context: context,
                portionWidthValue: 40,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ScreenUtils.heightSpace(30.0, context),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.of(context).pop(); // Navigate back
                      },
                    ),
                    ScreenUtils.widthSpace(54.0, context),
                    Container(
                      width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 120),
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 74.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/ignition_parts.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                ScreenUtils.heightSpace(20.0, context),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      imgLink: products[index]['imgLink']!,
                      titleText: products[index]['titleText']!,
                      body: products[index]['body']!,
                      url: products[index]['url']!, // Pass the specific URL
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
