import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getTrainingTracker_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/certificate_page.dart';
import 'package:niterra/services/garage_services/training_tracker_services.dart';
import 'package:niterra/utils/size.dart';

class TrainingTrackerPage extends StatefulWidget {
  TrainingTrackerPage({super.key});

  @override
  State<TrainingTrackerPage> createState() => _TrainingTrackerPageState();
}

class _TrainingTrackerPageState extends State<TrainingTrackerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TrainingTrackerService _trackerService = TrainingTrackerService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<TrainingTracker> trainingTracker = [];
  List<TrainingTracker> filteredTrainingTracker = [];
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  String? currentSearch;
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
      _fetchTrainingTracker();
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
      if (loggedUserid != null) {
        await _fetchTrainingTracker();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchTrainingTracker() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedTraningTracker = await _trackerService.fetchTrainingTracker(loggedUserid!);
     // List<TrainingTracker> filteredTrainingTracker = fetchedTraningTracker;
      setState(() {
        trainingTracker = fetchedTraningTracker;
        filteredTrainingTracker = trainingTracker;
      });
    } catch (e) {
      print("Error occurred while fetching trainings by loggedUser usertype: $e");

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
        filteredTrainingTracker = trainingTracker;
      } else {
        filteredTrainingTracker = trainingTracker.where((training) {
          return (training.staffName?.toLowerCase().contains(currentSearch!) ?? false) ||
              (training.trainingName?.toLowerCase().contains(currentSearch!) ?? false) ||
              (training.trainingDate?.toLowerCase().contains(currentSearch!) ?? false) ||
              (training.trainingTime?.toLowerCase().contains(currentSearch!) ?? false) ||
              (training.trainingStatus?.toLowerCase().contains(currentSearch!) ?? false);
        }).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < trainingTracker.length) {
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
    final int totalPages = (filteredTrainingTracker.length / rowsPerPage).ceil();
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
                          'TRAINING TRACKER',
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
                                    headingRowColor: MaterialStateColor.resolveWith(
                                            (states) => BaseColorTheme.tableHeadingBgColor),
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
                                    headingRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 36.0),
                                    dataRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 70.0),
                                    columns: const [
                                      DataColumn(label: Text('Sl No')),
                                      DataColumn(label: Text('Staff Details')),
                                      DataColumn(label: Text('Training Name')),
                                      DataColumn(label: Text('Training Date')),
                                      DataColumn(label: Text('Training Time')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: filteredTrainingTracker.skip(currentPage * rowsPerPage).take(rowsPerPage).map((training) {
                                      final index = filteredTrainingTracker.indexOf(training) + 1;
                                      String StatusText = '';
                                      String deliveryStatusText = '';
                                      Color claimButtonColor = Colors.grey;
                                      Color deliveryButtonColor = Colors.grey;
                                      double claimButtonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 80);
                                      double deliveryButtonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 80);


                                      switch (training.trainingStatus) {
                                        case 'Assigned':
                                          StatusText = 'Assigned';
                                          claimButtonColor = BaseColorTheme.yellowLineColor;
                                          claimButtonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 100);
                                          break;
                                        case 'Completed':
                                          StatusText = 'Completed';
                                          claimButtonColor = BaseColorTheme.approvedColor;
                                          claimButtonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 100);
                                          break;
                                      }

                                      return DataRow(cells: [
                                        DataCell(Text('$index')),
                                        DataCell(Text(
                                            'Name : ${training.staffName}\nPhone : ${training.staffPhone}\nEmail : ${training.staffEmail}')),
                                        DataCell(Text(training.trainingName)),
                                        DataCell(Text(training.trainingDate)),
                                        DataCell(Text(training.trainingTime)),
                                        DataCell(CommonButton(
                                          btnText: StatusText,
                                          buttonColor: claimButtonColor,
                                          buttonHeight: 25,
                                          buttonWidth: claimButtonWidth,
                                          buttonBorderRaduis: 15,
                                          buttonTextColor: BaseColorTheme.whiteTextColor,
                                          buttonFontWeight: BaseFontWeights.medium,
                                          buttonFontSize: 10,
                                          onPressed: () {},
                                        )),
                                        DataCell(
                                          training.certificateStatus == 'Certificate not issued'
                                              ? CommonButton(
                                            btnText: 'Certificate not issued',
                                            buttonColor: BaseColorTheme.buttonBgColor,
                                            buttonHeight: 25,
                                            buttonWidth: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 150),
                                            buttonBorderRaduis: 15,
                                            buttonTextColor: BaseColorTheme.whiteTextColor,
                                            buttonFontWeight: BaseFontWeights.medium,
                                            buttonFontSize: 10,
                                            onPressed: () {},
                                          )
                                              : training.certificateStatus == ''
                                              ? Container() // If the status is an empty string, show nothing
                                              : CommonButton(
                                            btnText: 'View Certificate',
                                            buttonColor: BaseColorTheme.subHeadingTextColor,
                                            buttonHeight: 25,
                                            buttonWidth: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 130),
                                            buttonBorderRaduis: 15,
                                            buttonTextColor: BaseColorTheme.whiteTextColor,
                                            buttonFontWeight: BaseFontWeights.medium,
                                            buttonFontSize: 10,
                                            onPressed: () {
                                              Get.to(
                                                CertificatePage(),
                                                arguments: {'certificateUrl': training.certificateStatus},
                                              );
                                            },
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
