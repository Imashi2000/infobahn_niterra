import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getStaffByGarageId_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/staff_screens/staff_registration_page.dart';
import 'package:niterra/screens/garage/staff_screens/update_staff_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/manage_staff_services.dart';
import 'package:niterra/utils/size.dart';

class ManageStaffPage extends StatefulWidget {
  ManageStaffPage({super.key});

  @override
  State<ManageStaffPage> createState() => _ManageStaffPageState();
}

class _ManageStaffPageState extends State<ManageStaffPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ManageStaffServices _manageStaffServices = ManageStaffServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<StaffByGarage> staff = [];
 // List<StaffByGarage> displayedData = [];
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
      _fetchStaffByGarageId();
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
        await _fetchStaffByGarageId();
      }

    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchStaffByGarageId() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedStaff = await _manageStaffServices.fetchStaffByGarageId(loggedUserid!);
      setState(() {
        staff = fetchedStaff;
       // _updateDisplayedData();
      });
    } catch (e) {
      print("Error occurred while fetching staff by loggedUser ID: $e");

      setState(() {
        isLoading = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching staff: $e')),
        );
      });
    }
  }

  // void _updateDisplayedData() {
  //   final startIndex = currentPage * rowsPerPage;
  //   final endIndex = startIndex + rowsPerPage;
  //
  //   setState(() {
  //     displayedData = staff.sublist(
  //       startIndex,
  //       endIndex > staff.length ? staff.length : endIndex,
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
      currentSearch = query.isEmpty ? null : query;
      currentPage = 0;
    });
    _fetchStaffByGarageId();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < staff.length) {
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
    final int totalPages = (staff.length / rowsPerPage).ceil();
    return Scaffold(
        key: _scaffoldKey,
        appBar: GarageAppBar(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: NavigationDrawerScreen(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 12.0),
              horizontal: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 12.0)
          ),
          child: BottomBar(
            onChanged: (BottomBarEnum type){
              setState(() {
                Get.to(HomePage());
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
                        'MANAGE STAFF',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.symmetric(
                                      horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
                                  ),
                                  child: CommonButton(
                                    buttonColor: BaseColorTheme.buttonBgColor,
                                    btnText: 'Add New +',
                                    buttonBorderRaduis: 10.0,
                                    buttonFontSize: 12.0 ,
                                    buttonFontWeight:BaseFontWeights.medium ,
                                    buttonHeight: 22.0,
                                    buttonTextColor: BaseColorTheme.whiteTextColor,
                                    buttonWidth: 117.0 ,
                                    onPressed: (){
                                      Get.to(StaffRegistrationPage());
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                              height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0),
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
                                    DataColumn(label: Text('Staff Name')),
                                    DataColumn(label: Text('Staff Email')),
                                    DataColumn(label: Text('Staff Phone')),
                                    DataColumn(label: Text('Designation')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows:  staff
                                      .skip(currentPage * rowsPerPage)
                                      .take(rowsPerPage)
                                      .toList() // Convert to a List
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = currentPage * rowsPerPage + entry.key + 1;
                                    final staffDetails = entry.value;
                                    return DataRow(cells: [
                                      DataCell(Text('$index')),
                                      DataCell(Text(staffDetails.staffName ?? '')),
                                      DataCell(Text(staffDetails.staffEmail ?? '')),
                                      DataCell(Text(staffDetails.staffPhone ?? '')),
                                      DataCell(Text(staffDetails.designation ?? '')),
                                      DataCell(
                                          CommonButton(
                                        btnText: 'Active',
                                        buttonColor: BaseColorTheme.approvedColor,
                                        buttonHeight: 25,
                                        buttonWidth: 80,
                                        buttonBorderRaduis: 15,
                                        buttonTextColor: BaseColorTheme.whiteTextColor,
                                        buttonFontWeight: BaseFontWeights.medium,
                                        buttonFontSize: 10,
                                        onPressed: (){},
                                      )),
                                      DataCell(Icon(Icons.edit_note_outlined),
                                      onTap: (){
                                        Get.to(() => UpdateStaffPage(staffDetails: staffDetails));
                                      }),
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
                                    '${currentPage + 1} / ${(staff.length / rowsPerPage).ceil()}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  onPressed: (currentPage + 1) * rowsPerPage < staff.length
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
        ));
  }
}
