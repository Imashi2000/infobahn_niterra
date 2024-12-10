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
import 'package:niterra/screens/navbar/trusted_pages/trusted_program_tab_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_qa_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_retailer_tab_page.dart';
import 'package:niterra/utils/size.dart';

import '../home/home_tab_page.dart';

class VehicalElectronicsPage extends StatefulWidget {
  VehicalElectronicsPage({super.key});

  @override
  State<VehicalElectronicsPage> createState() => _VehicalElectronicsPageState();
}

class _VehicalElectronicsPageState extends State<VehicalElectronicsPage> {
  final List<Map<String, String>> products = [
    {
      'imgLink': 'assets/images/lamda_sensors.png',
      'titleText': 'Oxygen/Lambda Sensors',
      'body': 'NTK oxygen/lambda sensors are known for their high quality and broad vehicle coverage. They are an important technical element that guarantee the reduction of pollutant emissions from combustion engines, in the aim of making engines cleaner and more productive.',
      'url' : 'https://www.ngkntk.com/products/oxygen-lambda-sensors/'
    },
    {
      'imgLink': 'assets/images/egts.png',
      'titleText': 'EGTS',
      'body': 'Exhaust gas temperature sensors (EGTS) measure the temperature of components within the exhaust gas system. This guarantees optimal running characteristics, contributes to the reduction of pollutant emissions, and protects the components against thermal damage.',
      'url':'https://www.ngkntk.com/products/exhaust-gas-temperature-sensors/'
    },
    {
      'imgLink': 'assets/images/map_maf.png',
      'titleText': 'MAP / MAF Sensors',
      'body': 'These sensors are an integral part of modern engine management systems They send information to the engine control unit, which controls the mixture of air and fuel. This allows engines to work more efficiently and with lower emissions. Thanks to reduced fuel consumption, the sensors contribute to creating an environmentally friendly combustion process. Strict tests ensure that they fulfil the highest of standards and deliver excellent performance under all conditions.',
      'url':'https://www.ngkntk.com/products/mapmaf-sensors/'
    },
    {
      'imgLink': 'assets/images/engine_speed.png',
      'titleText': 'Engine Speed & Position Sensors',
      'body': 'Speed and position sensors are crucial in ensuring the optimal running of a combustion engine. They provide the engine control unit with the most important information from the crankshaft and the camshaft, which is essential for the operation of the engine. In highly complex engine processes, the precise timing of fuel injection and ignition are essential to efficient operation.',
      'url':'https://www.ngkntk.com/products/engine-speed-position-sensors/'
    },
    {
      'imgLink': 'assets/images/valves.png',
      'titleText': 'ERG Valves',
      'body': 'NTK EGR valves are designed to reduce the amount of nitrogen oxides (NOx) generated during combustion and to help protect the engine.',
      'url':'https://www.ngkntk.com/products/exhaust-gas-recirculation-valves/'
    },
    {
      'imgLink': 'assets/images/EDP.png',
      'titleText': 'EDP Sensors',
      'body': 'EDPS are required to provide the engine control units with the necessary information regarding the exhaust gas pressures and the filling level of the diesel particle filter.',
      'url':'https://www.ngkntk.com/products/exhaust-differential-pressure-sensors/'
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
                      width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 89.45),
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 74.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/vehical_electronics.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 89.45),
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 26.56),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/vehical_electronics_text.png'),
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
