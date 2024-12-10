import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getStockDataByClaimId_model.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/cliam_pages_services.dart';
import 'package:niterra/utils/size.dart';

class DistributorScreen extends StatefulWidget {
  final int claimId;

  DistributorScreen({required this.claimId});

  @override
  _DistributorScreenState createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<DistributorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ClaimServices _claimServices = ClaimServices();
  Map<String, TextEditingController> controllers = {};
  List<StockDataByClaim> distributorData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDistributorData();
  }

  Future<void> _fetchDistributorData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _claimServices.fetchStockDataByClaim(widget.claimId);
      setState(() {
        distributorData = data;
        isLoading = false;

        for (var distributor in distributorData) {
          controllers[distributor.name] = TextEditingController();
        }
      });
    } catch (e) {
      print('Error fetching availability with distributors $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GarageAppBar(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          showBackIcon: true,
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
                      context: context, portionWidthValue: 17.0),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 40.23),
                      ),
                      const Text(
                        'CHECK AVAILABILITY',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: BaseColorTheme.subHeadingTextColor,
                          fontSize: 20.0,
                          fontWeight: BaseFontWeights.semiBold,
                        ),
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
                                  context: context, portionHeightValue: 17.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 17.0),
                              ),
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
                                    fontSize: 12.0,
                                  ),
                                  dataTextStyle: const TextStyle(
                                    color: BaseColorTheme.blackColor,
                                    fontWeight: BaseFontWeights.regular,
                                    fontSize: 12.0,
                                  ),
                                  border: TableBorder.all(
                                      color: BaseColorTheme.tableLineColor),
                                  headingRowHeight:
                                      ScreenUtils.getResponsiveHeight(
                                          context: context,
                                          portionHeightValue: 36.0),
                                  dataRowHeight: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 52.0),
                                  columns: const [
                                    DataColumn(label: Text('Distributor')),
                                    DataColumn(label: Text('Stock Status')),
                                    DataColumn(label: Text('Quantity Available')),
                                    DataColumn(
                                        label: Text('Next Available Date')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: distributorData.map((distributor) {
                                    return DataRow(cells: [
                                      DataCell(Text(distributor.name)),
                                      DataCell(Text(distributor.stockstatus)),
                                      DataCell(Text(distributor.qtyinstock)),
                                      DataCell(
                                          Text(distributor.availabledate ?? '')),
                                      DataCell(TextField(
                                        controller: controllers[distributor.name],
                                        decoration: InputDecoration(
                                          hintText: 'Max: 6',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight:
                                                  BaseFontWeights.regular),
                                          isDense: true,
                                          fillColor:
                                              BaseColorTheme.whiteTextColor,
                                          filled: true,
                                          border: null,
                                        ),
                                        keyboardType: TextInputType.number,
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 40.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 17.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonButton(
                                    btnText: 'Request Admin For Stock',
                                    buttonColor: BaseColorTheme.seeAllTextColor,
                                    buttonHeight: ScreenUtils.getResponsiveHeight(
                                        context: context,
                                        portionHeightValue: 25.0),
                                    buttonWidth: ScreenUtils.getResponsiveWidth(
                                        context: context, portionWidthValue: 190),
                                    buttonBorderRaduis: 15,
                                    buttonTextColor:
                                        BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.medium,
                                    buttonFontSize: 12,
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context,
                                        portionWidthValue: 10.0),
                                  ),
                                  CommonButton(
                                    btnText: 'Confirm',
                                    buttonColor: BaseColorTheme.seeAllTextColor,
                                    buttonHeight: ScreenUtils.getResponsiveHeight(
                                        context: context,
                                        portionHeightValue: 25.0),
                                    buttonWidth: ScreenUtils.getResponsiveWidth(
                                        context: context, portionWidthValue: 95),
                                    buttonBorderRaduis: 15,
                                    buttonTextColor:
                                        BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.medium,
                                    buttonFontSize: 12,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20),
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
