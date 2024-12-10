import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getGarageAgreement_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/certificate_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/garage_agreement_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:path_provider/path_provider.dart';

class GarageAgreementPage extends StatefulWidget {
  GarageAgreementPage({super.key});

  @override
  State<GarageAgreementPage> createState() => _GarageAgreementPageState();
}

class _GarageAgreementPageState extends State<GarageAgreementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GarageAgreementService _garageAgreementService =
      GarageAgreementService();

  int? loggedUserid;
  bool isLoading = false;
  GarageAgreement? garageAgreement;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedUserid != null) {
      _fetchGarageAgreementByUser();
    }
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
      });

      print("Logged User ID: $loggedUserid");
      if (loggedUserid != null && loggedUserid != 0) {
        await _fetchGarageAgreementByUser();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchGarageAgreementByUser() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedAgreement =
          await _garageAgreementService.fetchGarageAgreement(loggedUserid!);

      setState(() {
        garageAgreement = fetchedAgreement;
        isLoading = false;
      });

      if (fetchedAgreement == null && mounted) {
        CommonLoaders.warningSnackBar(title: 'Not Exists',message: 'Garage agreement not generated.', duration: 4);
      }
    } catch (e) {
      print("Error occurred while fetching garage agreement: $e");

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error fetching garage agreement. Please try again.')),
        );
      }
    }
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      // Create a Dio instance
      final dio = Dio();

      // Get the external directory (Documents folder)
      Directory directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw Exception("Unsupported platform");
      }

      // Construct the file path
      final filePath = '${directory.path}/$fileName';

      // Download the file
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      print('File downloaded to: $filePath');
    } catch (e) {
      print('Error downloading file: $e');
      throw Exception('Failed to download file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GarageAppBar(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: NavigationDrawerScreen(),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/bgSettings.png',
                  width: ScreenUtils.getResponsiveWidth(
                      context: context, portionWidthValue: 257),
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 514),
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.getResponsiveWidth(
                        context: context, portionWidthValue: 17.0)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 8),
                      ),
                      const Text(
                        'DASHBOARD',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: BaseColorTheme.garageHeadingTextColor,
                            fontSize: 22.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 40.23),
                      ),
                      const Text(
                        'GARAGE AGREEMENT',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: BaseColorTheme.subHeadingTextColor,
                            fontSize: 20.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 38),
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 9.0),
                            ),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 230),
                            //     ),
                            //     CommonButton(
                            //       buttonColor: BaseColorTheme.buttonBgColor,
                            //       btnText: 'Add New +',
                            //       buttonBorderRaduis: 10.0,
                            //       buttonFontSize: 12.0 ,
                            //       buttonFontWeight:BaseFontWeights.medium ,
                            //       buttonHeight: 22.0,
                            //       buttonTextColor: BaseColorTheme.whiteTextColor,
                            //       buttonWidth: 117.0 ,
                            //       onPressed: (){},
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 10.0),
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     SizedBox(
                            //       width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 22.0),
                            //     ),
                            //     const Text(
                            //       "Show",
                            //       style: TextStyle(
                            //           fontSize: 12.0,
                            //           color: BaseColorTheme.unselectedIconColor,
                            //           fontWeight: BaseFontWeights.medium,
                            //           fontFamily: 'Inter'
                            //       ),
                            //     ),
                            //     const SizedBox(width: 6),
                            //
                            //     SizedBox(
                            //       width: 77.0,
                            //       height: 32.0,
                            //       child: TextFormField(
                            //         readOnly: true, // To open dropdown on click
                            //         decoration: InputDecoration(
                            //           hintText: '10',
                            //           hintStyle: TextStyle(
                            //             color: BaseColorTheme.blackColor,
                            //             fontSize: 12,
                            //             fontFamily: 'Inter',
                            //             fontWeight: BaseFontWeights.regular,
                            //           ),
                            //           suffixIcon: const Icon(Icons.arrow_drop_down),
                            //           contentPadding:
                            //           const EdgeInsets.symmetric(horizontal: 8),
                            //           border: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(10),
                            //             borderSide: const BorderSide(
                            //               color: BaseColorTheme.dropdownBoderColor, //
                            //               width: 1.5,
                            //             ),
                            //           ),
                            //           enabledBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(8),
                            //             borderSide: const BorderSide(
                            //               color: BaseColorTheme.dropdownBoderColor,
                            //               width: 1.5,
                            //             ),
                            //           ),
                            //           focusedBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(8),
                            //             borderSide: const BorderSide(
                            //               color: BaseColorTheme.dropdownBoderColor,
                            //               width: 1.5,
                            //             ),
                            //           ),
                            //         ),
                            //         onTap: () {
                            //         },
                            //       ),
                            //     ),
                            //     const SizedBox(width: 16),
                            //
                            //     // "Entries" text
                            //     const Text(
                            //       "Entries Search",
                            //       style: TextStyle(
                            //           fontSize: 12.0,
                            //           fontFamily: 'Inter',
                            //           color: BaseColorTheme.unselectedIconColor,
                            //           fontWeight: BaseFontWeights.medium
                            //       ),
                            //     ),
                            //     const SizedBox(width: 6),
                            //
                            //     // Search text field
                            //     Expanded(
                            //       child: Container(
                            //         height: 32.0,
                            //         width: 117,
                            //         child: TextField(
                            //           decoration: InputDecoration(
                            //             hintText: '',
                            //             border: OutlineInputBorder(
                            //               borderRadius: BorderRadius.circular(8),
                            //               borderSide: const BorderSide(
                            //                 color: BaseColorTheme.dropdownBoderColor,
                            //                 width: 1.5,
                            //               ),
                            //             ),
                            //             enabledBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.circular(8),
                            //               borderSide: const BorderSide(
                            //                 color: BaseColorTheme.dropdownBoderColor,
                            //                 width: 1.5,
                            //               ),
                            //             ),
                            //             focusedBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.circular(8),
                            //               borderSide: const BorderSide(
                            //                 color: BaseColorTheme.dropdownBoderColor,
                            //                 width: 1.5,
                            //               ),
                            //             ),
                            //             contentPadding:
                            //             const EdgeInsets.symmetric(horizontal: 12),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 15.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 17.0)),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: MaterialStateColor.resolveWith(
                                      (states) =>
                                          BaseColorTheme.tableHeadingBgColor),
                                  dataRowColor: MaterialStateColor.resolveWith(
                                      (states) => BaseColorTheme.tableRowBgColor),
                                  headingTextStyle: const TextStyle(
                                      color: BaseColorTheme.blackColor,
                                      fontWeight: BaseFontWeights.semiBold,
                                      fontSize: 12.0),
                                  dataTextStyle: const TextStyle(
                                      color: BaseColorTheme.blackColor,
                                      fontWeight: BaseFontWeights.regular,
                                      fontSize: 12.0),
                                  border: TableBorder.all(
                                      color: BaseColorTheme.tableLineColor),
                                  headingRowHeight:
                                      ScreenUtils.getResponsiveHeight(
                                          context: context,
                                          portionHeightValue: 36.0),
                                  dataRowHeight: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 90.0),
                                  columns: const [
                                    DataColumn(label: Text('Garage Name')),
                                    DataColumn(label: Text('Contact Name')),
                                    DataColumn(label: Text('Designation')),
                                    DataColumn(label: Text('Email')),
                                    DataColumn(label: Text('Phone')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: [
                                    DataRow(
                                      cells: garageAgreement != null
                                          ? [
                                              DataCell(Text(
                                                  garageAgreement?.garageName ??
                                                      '')),
                                              DataCell(Text(
                                                  garageAgreement?.contactName ??
                                                      '')),
                                              DataCell(Text(
                                                  garageAgreement?.designation ??
                                                      '')),
                                              DataCell(Text(
                                                  garageAgreement?.email ?? '')),
                                              DataCell(Text(
                                                  garageAgreement?.phone ?? '')),
                                              DataCell(CommonButton(
                                                btnText: garageAgreement
                                                        ?.garageStatus ??
                                                    '',
                                                buttonColor:
                                                    BaseColorTheme.approvedColor,
                                                buttonHeight: 25,
                                                buttonWidth: 80,
                                                buttonBorderRaduis: 15,
                                                buttonTextColor:
                                                    BaseColorTheme.whiteTextColor,
                                                buttonFontWeight:
                                                    BaseFontWeights.medium,
                                                buttonFontSize: 10,
                                                onPressed: () {},
                                              )),
                                              DataCell(Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonButton(
                                                    btnText:
                                                        'View Member Certificate',
                                                    buttonColor: BaseColorTheme
                                                        .subHeadingTextColor,
                                                    buttonHeight: 25,
                                                    buttonWidth: 170,
                                                    buttonBorderRaduis: 15,
                                                    buttonTextColor:
                                                        BaseColorTheme
                                                            .whiteTextColor,
                                                    buttonFontWeight:
                                                        BaseFontWeights.medium,
                                                    buttonFontSize: 10,
                                                    onPressed: () {
                                                      Get.to(
                                                        CertificatePage(),
                                                        arguments: {
                                                          'certificateUrl':
                                                              garageAgreement
                                                                      ?.certificate ??
                                                                  ''
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  CommonButton(
                                                    btnText: 'View Agreement',
                                                    buttonColor: BaseColorTheme
                                                        .seeAllTextColor,
                                                    buttonHeight: 25,
                                                    buttonWidth: 130,
                                                    buttonBorderRaduis: 15,
                                                    buttonTextColor:
                                                        BaseColorTheme
                                                            .whiteTextColor,
                                                    buttonFontWeight:
                                                        BaseFontWeights.medium,
                                                    buttonFontSize: 10,
                                                    onPressed: () async {
                                                      if (garageAgreement
                                                              ?.agreement !=
                                                          null) {
                                                        try {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Downloading agreement...')),
                                                          );
      
                                                          // Call the download function
                                                          await _downloadFile(
                                                              garageAgreement!
                                                                  .agreement!,
                                                              'agreement.pdf');
      
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Agreement downloaded successfully')),
                                                          );
                                                        } catch (e) {
                                                          print(
                                                              'Download failed: $e');
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'Failed to download agreement: $e')),
                                                          );
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Agreement not available')),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )),
                                            ]
                                          : [
                                              DataCell(Text('No Data')),
                                              DataCell(Text('No Data')),
                                              DataCell(Text('No Data')),
                                              DataCell(Text('No Data')),
                                              DataCell(Text('No Data')),
                                              DataCell(Text('No Data')),
                                              DataCell(
                                                  Text('No Agreement Available')),
                                            ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 25.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
