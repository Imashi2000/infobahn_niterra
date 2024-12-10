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
import 'package:niterra/models/garage_models/getCampaign_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/manage_campaign_screens/campaign_enroll_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/campaign_services.dart';
import 'package:niterra/utils/size.dart';

class CampaignListPage extends StatefulWidget {
  const CampaignListPage({super.key});

  @override
  State<CampaignListPage> createState() => _CampaignListPageState();
}

class _CampaignListPageState extends State<CampaignListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 final CampaignServices _campaignServices = CampaignServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Campaign> campaigns = [];
  List<Campaign> filteredCampaigns = [];
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  String? currentSearch;
  int? loggedUserid;
  int? userTypeId;
  int? cityId;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedUserid != null) {
      _fetchCampaigns();
    }
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      //print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
        userTypeId = int.tryParse(userDetails['userTypeId'] ?? '0');
        cityId = int.tryParse(userDetails['cityId'] ?? '0');
      });

      //print("Logged User ID: $loggedUserid , Logged UserTypeId: $userTypeId, Logged cityId: $cityId");
      if (loggedUserid != null && userTypeId !=null && cityId !=null) {
        await _fetchCampaigns();
      }
    } catch (e) {
      //print('Error in _initializeUserData: $e');
      CommonLoaders.errorSnackBar(title: 'Error retrieving user details',message: '$e', duration: 4);
    }
  }

  Future<void> _fetchCampaigns() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedCampaigns = await _campaignServices.fetchCampaigns(userTypeId!,cityId!,loggedUserid!);
      //List<TrainingByUserType> filteredTrainings = fetchedTranings;
      setState(() {
        campaigns = fetchedCampaigns;
        filteredCampaigns = campaigns;
      });
    } catch (e) {
      //print("Error occurred while fetching trainings by loggedUser usertype: $e");

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
  //     displayedData = trainingTracker.sublist(
  //       startIndex,
  //       endIndex > trainingTracker.length ? trainingTracker.length : endIndex,
  //     );
  //   });
  // }
  //
  // void _onPageChanged(int page) {
  //   setState(() {
  //     currentPage = page;
  //     _updateDisplayedData();
  //   });
  // }

  void _onRowsPerPageChanged(int rows) {
    setState(() {
      rowsPerPage = rows;
      currentPage = 0;
      //   _updateDisplayedData();
    });
  }

  void _onSearch(String query) {
    setState(() {
      currentSearch = query.isEmpty ? null : query.toLowerCase();
      currentPage = 0; // Reset to first page

      if (currentSearch == null) {
        filteredCampaigns = campaigns; // Reset to all campaigns
      } else {
        filteredCampaigns = campaigns.where((campaign) {
          return (campaign.campaignName.toLowerCase().contains(currentSearch!) ||
              campaign.startDate.toLowerCase().contains(currentSearch!) ||
              campaign.endDate.toLowerCase().contains(currentSearch!) ||
              campaign.status.toLowerCase().contains(currentSearch!));
        }).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < campaigns.length) {
        setState(() {
          currentPage++;
          //_updateDisplayedData();
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
    final int totalPages = (filteredCampaigns.length / rowsPerPage).ceil();
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: GarageAppBar(
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          drawer: const NavigationDrawerScreen(),
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
                  padding:  EdgeInsets.symmetric(
                      horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
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
                              fontWeight: BaseFontWeights.semiBold),
                        ),
                        SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 40.23),
                        ),
                        const Text(
                          'MANAGE CAMPAIGN',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: BaseColorTheme.subHeadingTextColor,
                              fontSize: 20.0,
                              fontWeight: BaseFontWeights.semiBold),
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
                                spreadRadius: 0,),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 9.0),
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
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 10.0),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context, portionWidthValue: 25.0),
                                  ),
                                  const Text(
                                    "Show",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: BaseColorTheme.unselectedIconColor,
                                        fontWeight: BaseFontWeights.medium),
                                  ),
                                  SizedBox(width: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 8.0),
                                  ),
                                  Container(
                                    height: 32.0,
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context, portionWidthValue: 47.0),
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
                                  SizedBox(width: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 16.0),
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
                                        context: context, portionWidthValue: 16.0),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 32.0,
                                      width: 117.0,
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: _onSearch,
                                        decoration: InputDecoration(
                                          hintText: '',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: BaseColorTheme.searchLineColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: BaseColorTheme.searchLineColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: BaseColorTheme.searchLineColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtils.getResponsiveWidth(
                                        context: context, portionWidthValue: 17.0),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                              ),
                              Padding(
                                padding:  EdgeInsets.symmetric(
                                    horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: WidgetStateColor.resolveWith(
                                            (states) => BaseColorTheme.tableHeadingBgColor),
                                    dataRowColor: WidgetStateColor.resolveWith(
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
                                    headingRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 36.0),
                                    dataRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 70.0),
                                    columns: const [
                                      DataColumn(label: Text('Sl No')),
                                      DataColumn(label: Text('Campaign Name')),
                                      DataColumn(label: Text('Start Date')),
                                      DataColumn(label: Text('End Date')),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: filteredCampaigns.skip(currentPage * rowsPerPage).take(rowsPerPage).toList().asMap().entries.map((entry) {
                                      final index = currentPage * rowsPerPage + entry.key + 1;
                                      final campaignDetails = entry.value;
                                      String statusText = '';
                                      Color claimButtonColor = Colors.grey;
      
                                      switch (campaignDetails.status) {
                                        case 'Already enrolled':
                                          statusText = 'Already enrolled';
                                          claimButtonColor = BaseColorTheme.yellowLineColor;
                                          break;
                                        case 'Enroll':
                                          statusText = 'Enroll';
                                          claimButtonColor = BaseColorTheme.approvedColor;
                                          break;
                                        case 'Campaign Finished':
                                          statusText = 'Campaign Finished';
                                          claimButtonColor = BaseColorTheme.approvedColor;
                                          break;
                                      }
                                      return DataRow(cells: [
                                        DataCell(Text('$index')),
                                        DataCell(Text(campaignDetails.campaignName)),
                                        DataCell(Text(campaignDetails.startDate)),
                                        DataCell(Text(campaignDetails.endDate)),
                                        DataCell(CommonButton(
                                          btnText: statusText,
                                          buttonColor: claimButtonColor,
                                          buttonHeight: 25,
                                          buttonWidth: double.infinity,
                                          buttonBorderRaduis: 15,
                                          buttonTextColor: BaseColorTheme.whiteTextColor,
                                          buttonFontWeight: BaseFontWeights.medium,
                                          buttonFontSize: 10,
                                          onPressed: () {
                                            if(statusText == 'Enroll'){
                                              Get.to(CampaignEnrollPage(campaignDetails: campaignDetails));
                                            }
                                          },
                                        )),
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
                                    onPressed: currentPage + 1 < totalPages
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