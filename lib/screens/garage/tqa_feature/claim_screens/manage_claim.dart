import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getClaimByGarageId.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/checkPartNo_availability.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/claim_details.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/claim_registeration_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/cliam_pages_services.dart';
import 'package:niterra/utils/size.dart';

class ManageClaimScreen extends StatefulWidget {
  ManageClaimScreen({super.key});

  @override
  State<ManageClaimScreen> createState() => _ManageClaimScreenState();
}

class _ManageClaimScreenState extends State<ManageClaimScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ClaimServices _claimServices = ClaimServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ClaimByGarage> claims = [];
  List<ClaimByGarage> filteredClaims = []; // To store filtered results
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  String? currentSearch;
  String? status;
  int? loggedUserid;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedUserid != null) {
      _fetchClaimsByGarageId();
    }
    _scrollController.addListener(_onScroll);
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
        await _fetchClaimsByGarageId();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchClaimsByGarageId() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedClaims =
          await _claimServices.fetchClaimsByGarageId(loggedUserid!);
      setState(() {
        claims = fetchedClaims;
        filteredClaims = claims; // Initially, show all claims
      });
    } catch (e) {
      print("Error occurred while fetching claims by loggedUser ID: $e");

      setState(() {
        isLoading = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $e')),
        );
      });
    }
  }

  // void _updateDisplayedData() {
  //   final startIndex = currentPage * rowsPerPage;
  //   final endIndex = startIndex + rowsPerPage;
  //
  //   setState(() {
  //     displayedData = claims.sublist(
  //       startIndex,
  //       endIndex > claims.length ? claims.length : endIndex,
  //     );
  //   });
  // }

  // void _onPageChanged(int page) {
  //   setState(() {
  //     currentPage = page;
  //     _updateDisplayedData();
  //   });
  // }

  void _onRowsPerPageChanged(int rows) {
    setState(() {
      rowsPerPage = rows;
      currentPage = 0; // Reset to the first page
    });
  }

  void _onSearch(String query) {
    setState(() {
      currentPage = 0; // Reset pagination to the first page
      if (query.isEmpty) {
        filteredClaims = claims; // Show all claims if the query is empty
      } else {
        final searchQuery = query.toLowerCase();
        filteredClaims = claims.where((claim) {
          return (claim.name?.toLowerCase().contains(searchQuery) ?? false) ||
              (claim.phone?.toLowerCase().contains(searchQuery) ?? false) ||
              (claim.vehicleModel?.toLowerCase().contains(searchQuery) ?? false) ||
              (claim.partNo?.toLowerCase().contains(searchQuery) ?? false) ||
              (claim.claimId?.toString().toLowerCase().contains(searchQuery) ?? false) ||
              (claim.productType?.toLowerCase().contains(searchQuery) ?? false) ||
              (claim.plateNo?.toLowerCase().contains(searchQuery) ?? false) || // Plate No
              (claim.claimDate?.toLowerCase().contains(searchQuery) ?? false); // Claim Date
        }).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < claims.length) {
        setState(() {
          currentPage++;
          //  _updateDisplayedData();
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedClaims = filteredClaims
        .skip(currentPage * rowsPerPage)
        .take(rowsPerPage)
        .toList();

    final totalPages = (filteredClaims.length / rowsPerPage).ceil();
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
                          'MANAGE CLAIM',
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ScreenUtils.getResponsiveWidth(
                                                context: context,
                                                portionWidthValue: 17.0)),
                                    child: CommonButton(
                                      buttonColor: BaseColorTheme.buttonBgColor,
                                      btnText: 'Add New +',
                                      buttonBorderRaduis: 10.0,
                                      buttonFontSize: 12.0,
                                      buttonFontWeight: BaseFontWeights.medium,
                                      buttonHeight: 22.0,
                                      buttonTextColor:
                                          BaseColorTheme.whiteTextColor,
                                      buttonWidth: 117.0,
                                      onPressed: () {
                                        Get.to(ClaimRegisterationPage());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 10.0),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context,
                                        portionWidthValue: 17.0),
                                  ),
                                  const Text(
                                    "Show",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: BaseColorTheme.unselectedIconColor,
                                        fontWeight: BaseFontWeights.medium),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    height: 32.0,
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context,
                                        portionWidthValue: 47.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: BaseColorTheme.borderColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButton<int>(
                                      value: rowsPerPage,
                                      items: [5, 10, 15]
                                          .map((e) => DropdownMenuItem<int>(
                                              value: e, child: Text('$e')))
                                          .toList(),
                                      onChanged: (value) =>
                                          _onRowsPerPageChanged(value!),
                                      borderRadius: BorderRadius.circular(15.0),
                                      underline: Container(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context,
                                        portionWidthValue: 16.0),
                                  ),
                                  const Text(
                                    "Entries Search",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: BaseColorTheme.unselectedIconColor,
                                        fontWeight: BaseFontWeights.medium),
                                  ),
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context,
                                        portionWidthValue: 16.0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 32.0,
                                      width: ScreenUtils.getResponsiveWidth(
                                          context: context,
                                          portionWidthValue: 117.0),
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: _onSearch,
                                        decoration: InputDecoration(
                                          hintText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color:
                                                  BaseColorTheme.searchLineColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color:
                                                  BaseColorTheme.searchLineColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color:
                                                  BaseColorTheme.searchLineColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context,
                                        portionWidthValue: 17.0),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 38.0),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 17.0),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateColor.resolveWith((states) =>
                                            BaseColorTheme.tableHeadingBgColor),
                                    dataRowColor: MaterialStateColor.resolveWith(
                                        (states) =>
                                            BaseColorTheme.tableRowBgColor),
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
                                    dataRowHeight:
                                        ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 116.0),
                                    columns: const [
                                      DataColumn(label: Text('Sl No')),
                                      DataColumn(label: Text('Consumer Details')),
                                      DataColumn(label: Text('Vehicle Details')),
                                      DataColumn(label: Text('Product Details')),
                                      DataColumn(label: Text('Claim Details')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: displayedClaims.asMap().entries.map((entry) {
                                      final index = currentPage * rowsPerPage + entry.key + 1;
                                      final claimDetails = entry.value;
                                      String claimStatusText = '';
                                      String deliveryStatusText = '';
                                      Color claimButtonColor = Colors.grey;
                                      Color deliveryButtonColor = Colors.grey;

                                      Widget actionButtons = const SizedBox();

                                      switch (claimDetails.claimStatus) {
                                        case 0:
                                          claimStatusText = 'Claim Submitted';
                                          claimButtonColor = BaseColorTheme.claimSubmittedColor;
                                          break;
                                        case 1:
                                          claimStatusText = 'Claim Approved';
                                          claimButtonColor = BaseColorTheme.approvedColor;
                                          if (claimDetails.deliveryStatus !=
                                              null) {
                                            switch (claimDetails.deliveryStatus) {
                                              case 0:
                                                deliveryStatusText =
                                                    'Check Part No Availability';
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight: BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: deliveryStatusText,
                                                  buttonColor: BaseColorTheme.partnoColor,
                                                  buttonWidth: double.infinity,
                                                  onPressed: () {
                                                    Get.to(DistributorScreen(claimId: claimDetails.claimId));
                                                  },
                                                );
                                                break;
                                              case 1:
                                                deliveryStatusText = 'Part No Request Sent to the Admin';
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight: BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: deliveryStatusText,
                                                  buttonColor: BaseColorTheme.seeAllTextColor,
                                                  buttonWidth: double.infinity,
                                                  onPressed: () {
                                                    //Get.to(DistributorScreen(claimId: claimDetails.claimId));
                                                  },
                                                );
                                                break;
                                              case 2:
                                                deliveryStatusText = 'Part No Request Confirmed with distributor';
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight: BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: deliveryStatusText,
                                                  buttonColor: BaseColorTheme.partnoColor,
                                                  buttonWidth: double.infinity,
                                                  onPressed: () {
                                                    //Get.to(DistributorScreen(claimId: claimDetails.claimId));
                                                  },
                                                );
                                              case 3:
                                                deliveryStatusText = 'Stock Delivered by Distributor';
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight:
                                                      BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: 'Confirm Stock',
                                                  buttonColor: BaseColorTheme.submittedBtnColor,
                                                  buttonWidth: 140,
                                                  onPressed: () {
                                                    // Action here
                                                  },
                                                );
                                                break;
                                              case 4:
                                                deliveryStatusText = 'Complete Replacement';
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight: BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: 'Complete Replacement',
                                                  buttonColor: BaseColorTheme.yellowLineColor,
                                                  buttonWidth: 160,
                                                  onPressed: () {
                                                    // Action here
                                                  },
                                                );
                                                break;
                                              case 6:
                                                deliveryStatusText = 'Pat No request sent to the Distributor';
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight: BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: deliveryStatusText,
                                                  buttonColor: BaseColorTheme.yellowLineColor,
                                                  buttonWidth: double.infinity,
                                                  onPressed: () {
                                                    // Action here
                                                  },
                                                );
                                                break;
                                            }
                                          }
                                          break;
                                        case 2:
                                          claimStatusText = 'Claim Rejected';
                                          claimButtonColor = BaseColorTheme.buttonBgColor;
                                          break;
                                        case 3:
                                          claimStatusText = 'Resubmit Requested';
                                          claimButtonColor = BaseColorTheme.yellowLineColor;
                                          if (claimDetails.resubmitStatus !=
                                              null) {
                                            switch (claimDetails.resubmitStatus) {
                                              case 0:
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme
                                                      .whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight:
                                                      BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: 'Resubmit Claim',
                                                  buttonColor: BaseColorTheme
                                                      .yellowLineColor,
                                                  buttonWidth: 140,
                                                  onPressed: () {
                                                    // Action here
                                                  },
                                                );
                                                break;
                                              case 1:
                                                actionButtons = CommonButton(
                                                  buttonTextColor: BaseColorTheme
                                                      .whiteTextColor,
                                                  buttonHeight: 25,
                                                  buttonFontWeight:
                                                      BaseFontWeights.medium,
                                                  buttonFontSize: 10,
                                                  buttonBorderRaduis: 15,
                                                  btnText: 'Claim Resubmitted',
                                                  buttonColor: BaseColorTheme
                                                      .yellowLineColor,
                                                  buttonWidth: 140,
                                                  onPressed: () {
                                                    // Action here
                                                  },
                                                );
                                                break;
                                            }
                                          }
                                          break;
                                        case 4:
                                          claimStatusText = 'Verification Requested';
                                          claimButtonColor = BaseColorTheme.subHeadingTextColor;
                                          break;
                                        case 5:
                                          claimStatusText =
                                              'Verification Completed';
                                          claimButtonColor = BaseColorTheme.subHeadingTextColor;
                                          break;
                                        case 6:
                                          claimStatusText =
                                              'Replacement Completed';
                                          claimButtonColor = BaseColorTheme.subHeadingTextColor;
                                          break;
                                      }
                                      return DataRow(cells: [
                                        DataCell(Text('$index')),
                                        DataCell(Text(
                                            'Name : ${claimDetails.name}\nPhone : ${claimDetails.phone}')),
                                        DataCell(Text(
                                            'Vehicle Model : ${claimDetails.vehicleModel}\nPlate No : ${claimDetails.plateNo}')),
                                        DataCell(Text(
                                            'Prduct Type : ${claimDetails.productType}\nPart No : ${claimDetails.partNo}\nWarranty Expiry : ${claimDetails.expiryDate}')),
                                        DataCell(
                                          Text(
                                              'Claim ID : ${claimDetails.claimId}\nClaim Date : ${claimDetails.claimDate}\nQty to claim : ${claimDetails.quantityClaim}\nDiagnosis : ${claimDetails.diagnosis}'),
                                        ),
                                        DataCell(CommonButton(
                                          btnText: claimStatusText,
                                          buttonColor: claimButtonColor,
                                          buttonHeight: 25,
                                          buttonWidth: double.infinity,
                                          buttonBorderRaduis: 15,
                                          buttonTextColor:
                                              BaseColorTheme.whiteTextColor,
                                          buttonFontWeight:
                                              BaseFontWeights.medium,
                                          buttonFontSize: 10,
                                          onPressed: () {},
                                        )),
                                        DataCell(
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (actionButtons != const SizedBox()) ...[
                                                actionButtons,
                                                SizedBox(height: 5),
                                              ],
                                              CommonButton(
                                                btnText: "View Claim",
                                                buttonColor:
                                                    BaseColorTheme.viewClaim,
                                                buttonHeight: 25,
                                                buttonWidth: ScreenUtils
                                                    .getResponsiveWidth(
                                                        context: context,
                                                        portionWidthValue: 105),
                                                buttonBorderRaduis: 15,
                                                buttonTextColor:
                                                    BaseColorTheme.whiteTextColor,
                                                buttonFontWeight:
                                                    BaseFontWeights.medium,
                                                buttonFontSize: 10,
                                                onPressed: () {
                                                  Get.to(() => ClaimDetailsPage(
                                                      claimId:
                                                          claimDetails.claimId)); // Debugging purpose
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: currentPage > 0
                                        ? () => setState(() {
                                      currentPage--;
                                    })
                                        : null,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  TextButton(
                                    onPressed: null,
                                    child: Text(
                                      '${currentPage + 1} / $totalPages',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: currentPage < totalPages - 1
                                        ? () => setState(() {
                                      currentPage++;
                                    })
                                        : null,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
