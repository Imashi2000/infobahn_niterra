import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/screens/garage/training_tracker_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/utils/size.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({Key? key}) : super(key: key);

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDownloading = false; // Track download status
  double _downloadProgress = 0.0; // Track download progress
  @override
  Widget build(BuildContext context) {
    // Retrieve the certificate URL from the arguments
    final arguments = Get.arguments;
    final String? certificateUrl = arguments != null ? arguments['certificateUrl'] : null;
    final bool hasCertificate = certificateUrl != null && certificateUrl.isNotEmpty;


    return Scaffold(
      key: _scaffoldKey,
      appBar: GarageAppBar(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: NavigationDrawerScreen(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 12.0),
          horizontal: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 12.0),
        ),
        child: BottomBar(
          onChanged: (BottomBarEnum type) {
            setState(() {
              Get.to(const HomePage());
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/bgSettings.png',
                width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 257),
                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 514),
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 8),
                    ),
                    const Text(
                      'DASHBOARD',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: BaseColorTheme.garageHeadingTextColor,
                        fontSize: 22.0,
                        fontWeight: BaseFontWeights.semiBold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 40.23),
                    ),
                    const Text(
                      'CERTIFICATE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: BaseColorTheme.subHeadingTextColor,
                        fontSize: 20.0,
                        fontWeight: BaseFontWeights.semiBold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 38),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: BaseColorTheme.whiteTextColor,
                        boxShadow: const [
                          BoxShadow(
                            color: BaseColorTheme.textfieldShadowColor,
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0),
                        ),
                        child: hasCertificate
                            ? SizedBox(
                          height: 500,
                          child: SfPdfViewer.network(certificateUrl!),
                        )
                            : const Center(
                          child: Text(
                            'No certificate available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: BaseColorTheme.subHeadingTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 38),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonButton(
                            btnText: 'Back',
                            buttonColor: BaseColorTheme.buttonBgColor,
                            buttonHeight: 25,
                            buttonWidth: 80,
                            buttonBorderRaduis: 15,
                            buttonTextColor: BaseColorTheme.whiteTextColor,
                            buttonFontWeight: BaseFontWeights.medium,
                            buttonFontSize: 12,
                          onPressed: () {
                            Get.to(() => TrainingTrackerPage());
                          },
                        ),
                        CommonButton(
                          btnText: 'Download',
                          buttonColor: BaseColorTheme.primaryGreenColor,
                          buttonHeight: 25,
                          buttonWidth: 120,
                          buttonBorderRaduis: 15,
                          buttonTextColor: BaseColorTheme.whiteTextColor,
                          buttonFontWeight: BaseFontWeights.medium,
                          buttonFontSize: 12,
                          onPressed:  certificateUrl !=null
                            ? () async {
                            await _downloadCertificate(certificateUrl);
                          }
                          :null
                        ),
                      ],
                    ),
                    if(_isDownloading)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: LinearProgressIndicator(
                          value: _downloadProgress,
                          color: BaseColorTheme.primaryGreenColor,
                          backgroundColor: BaseColorTheme.textfieldShadowColor,
                        ),
                      ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 38),
                    ),
                      ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _downloadCertificate(String url) async {
    try {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      final dio = Dio();
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/certificate.pdf';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          setState(() {
            _downloadProgress = received / total;
          });
        },
      );

     CommonLoaders.successSnackBar(title: 'Download completed', message:'$filePath', duration: 4);
    } catch (e) {
      CommonLoaders.errorSnackBar(title: 'Download Failed',message: 'Try Again, $e', duration:4);
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }
}
