import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getTrainingsByUserType_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/training_screens/assign_staff_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/manage_training_services.dart';
import 'package:niterra/utils/size.dart';

class ManageTrainingsPage extends StatefulWidget {
  ManageTrainingsPage({super.key});

  @override
  State<ManageTrainingsPage> createState() => _ManageTrainingsPageState();
}

class _ManageTrainingsPageState extends State<ManageTrainingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final ManageTrainingServices _manageTrainingServices=  ManageTrainingServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<TrainingByUserType> trainings = [];
  List<TrainingByUserType> filteredTrainings = [];
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  String? currentSearch;
  int? loggedCountryId;
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
    if (loggedUserid != null && loggedCountryId !=null && userTypeId !=null && cityId !=null) {
      _fetchTrainingsByUserTypeId();
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
        loggedCountryId = int.tryParse(userDetails['countryId'] ?? '0');
        userTypeId = int.tryParse(userDetails['userTypeId'] ?? '0');
        cityId = int.tryParse(userDetails['cityId'] ?? '0');
      });

      print("Logged User ID: $loggedUserid , Logged CountryId: $loggedCountryId, Logged UserTypeId: $userTypeId, Logged cityId: $cityId");
      if (loggedUserid != null && loggedCountryId !=null && userTypeId !=null && cityId !=null) {
        await _fetchTrainingsByUserTypeId();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchTrainingsByUserTypeId() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedTranings = await _manageTrainingServices.fetchTrainingsByUserType(userTypeId!,cityId!,loggedUserid!);

      setState(() {
        trainings = fetchedTranings;
        filteredTrainings = fetchedTranings;
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

  void _onRowsPerPageChanged(int rows) {
    setState(() {
      rowsPerPage = rows;
      currentPage = 0;
     // _updateDisplayedData();
    });
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTrainings = trainings;
      } else {
        filteredTrainings = trainings.where((training) {
          final lowerQuery = query.toLowerCase();
          return (training.trainingName?.toLowerCase().contains(lowerQuery) ?? false) ||
              (training.trainingDate?.toLowerCase().contains(lowerQuery) ?? false) ||
              (training.country?.toLowerCase().contains(lowerQuery) ?? false) ||
              (training.city?.toLowerCase().contains(lowerQuery) ?? false) ||
              (training.venue?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < trainings.length) {
        setState(() {
          currentPage++;
         // _updateDisplayedData();
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
    final int totalPages = (filteredTrainings.length / rowsPerPage).ceil();
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
                          'MANAGE TRAININGS',
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
                                height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 24.0),
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
                                    dataRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 52.0),
                                    columns: const [
                                      DataColumn(label: Text('Sl No')),
                                      DataColumn(label: Text('Training Name')),
                                      DataColumn(label: Text('Training Date')),
                                      DataColumn(label: Text('Training Time')),
                                      DataColumn(label: Text('Country')),
                                      DataColumn(label: Text('City')),
                                      DataColumn(label: Text('Venue')),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: filteredTrainings
                                        .skip(currentPage * rowsPerPage)
                                        .take(rowsPerPage)
                                        .map((training) {
                                      final index = filteredTrainings.indexOf(training) + 1;
                                      //final trainingDetails = entry.value;
                                      String buttonText = '';
                                      Color buttonColor = Colors.grey;
                                      double buttonWidth = 80.0;

                                      switch (training.assignStatus) {
                                        case 0:
                                          buttonText = 'Assign Staff';
                                          buttonColor = BaseColorTheme.primaryGreenColor;
                                          buttonWidth = 110.0;
                                          break;
                                        case 1:
                                          buttonText = 'Staff Assigned';
                                          buttonColor = BaseColorTheme.approvedColor;
                                          buttonWidth = 140.0;
                                          break;
                                      }
                                      return DataRow(cells: [
                                        DataCell(Text('$index')),
                                        DataCell(Text(training.trainingName ?? '')),
                                        DataCell(Text(training.trainingDate ?? '')),
                                        DataCell(Text(training.trainingTime ?? '')),
                                        DataCell(Text(training.country ?? '')),
                                        DataCell(Text(training.city ?? '')),
                                        DataCell(Text(training.venue ?? '')),
                                        DataCell(
                                            CommonButton(
                                              btnText: buttonText,
                                              buttonColor: buttonColor,
                                              buttonHeight: 25,
                                              buttonWidth: buttonWidth,
                                              buttonBorderRaduis: 15,
                                              buttonTextColor: BaseColorTheme.whiteTextColor,
                                              buttonFontWeight: BaseFontWeights.medium,
                                              buttonFontSize: 10,
                                              onPressed: (){
                                                switch(training.assignStatus){
                                                  case 0:
                                                    Get.to(() => AssignStaffPage(trainingDetails: training));
                                                    break;
                                                  case 1:
                                                    //
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
