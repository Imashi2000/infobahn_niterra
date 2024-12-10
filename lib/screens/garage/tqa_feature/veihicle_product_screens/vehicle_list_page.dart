import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getVehicleByCountry_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/vehicle_registration.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/view_product_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/vehicle_registration_services.dart';
import 'package:niterra/utils/size.dart';

class VehicleListPage extends StatefulWidget {
  VehicleListPage({super.key});

  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final VehicleRegistrationServices _vehicleRegistrationServices = VehicleRegistrationServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<VehicleByCountry> vehicles = [];
  List<VehicleByCountry> filteredVehicles = [];
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  String? currentSearch;
  int? loggedCountryId;
  bool isUserDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedCountryId != null) {
      _fetchVehiclesByCountrylist();
    }
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedCountryId = int.tryParse(
            userDetails['countryId'] ?? '0'); // Correct key is 'countryId'
      });

      print("Country ID: $loggedCountryId");

      // Fetch consumers if the country ID is valid
      if (loggedCountryId != null && loggedCountryId != 0) {
        await _fetchVehiclesByCountrylist();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchVehiclesByCountrylist() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedVehicles = await _vehicleRegistrationServices.fetchVehiclesByCountry(loggedCountryId!);

      setState(() {
        vehicles = fetchedVehicles;
        filteredVehicles = List.from(vehicles);
      });
    } catch (e) {
      print("Error occurred while fetching vehicles: $e");

      setState(() {
        isLoading = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching vehicles: $e')),
        );
      });
    }
  }
  void _navigateToProductList(int vehicleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewProductPage(vehicleId: vehicleId), // Pass vehicleId
      ),
    );
  }

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
     // _updateDisplayedData();
    });
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredVehicles = List.from(vehicles); // Reset to all data
      } else {
        final lowerQuery = query.toLowerCase();
        filteredVehicles = vehicles.where((vehicle) {
          return (vehicle.consumerName?.toLowerCase().contains(lowerQuery) ?? false) ||
              (vehicle.email?.toLowerCase().contains(lowerQuery) ?? false) ||
              (vehicle.phone?.toLowerCase().contains(lowerQuery) ?? false) ||
              (vehicle.vehiclemodel?.toLowerCase().contains(lowerQuery) ?? false) ||
              (vehicle.plateno?.toLowerCase().contains(lowerQuery) ?? false) ||
              (vehicle.mileage?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
      currentPage = 0; // Reset pagination
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        (currentPage + 1) * rowsPerPage < filteredVehicles.length) {
      setState(() {
        currentPage++;
      });
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
    final displayedVehicles = filteredVehicles.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();
    final totalPages = (filteredVehicles.length / rowsPerPage).ceil();
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
                      context: context, portionWidthValue: 17.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DASHBOARD',
                      style: TextStyle(
                        color: BaseColorTheme.headingTextColor,
                        fontSize: 22.0,
                        fontWeight: BaseFontWeights.semiBold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 32.0),
                    ),
                    const Text(
                      'VEHICLES',
                      style: TextStyle(
                        color: BaseColorTheme.subHeadingTextColor,
                        fontSize: 20.0,
                        fontWeight: BaseFontWeights.semiBold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 37.0),
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
                                context: context, portionHeightValue: 10.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 17.0),),
                                child: CommonButton(
                                  buttonColor: BaseColorTheme.buttonBgColor,
                                  btnText: 'Add New +',
                                  buttonBorderRaduis: 10.0,
                                  buttonFontSize: 12.0,
                                  buttonFontWeight: BaseFontWeights.medium,
                                  buttonHeight: 25.0,
                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                  buttonWidth: 117.0,
                                  onPressed: () {
                                    Get.to(VehicleRegistrationForm());
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
                                    context: context, portionWidthValue: 17.0),
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
                              SizedBox(width: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 16.0),
                              ),
                              Expanded(
                                child: Container(
                                  height: 32.0,
                                  width: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 117.0),
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
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20.0)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 17.0),
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
                                  fontSize: 12.0,
                                ),
                                dataTextStyle: const TextStyle(
                                  color: BaseColorTheme.blackColor,
                                  fontWeight: BaseFontWeights.regular,
                                  fontSize: 12.0,
                                ),
                                border: TableBorder.all(
                                    color: BaseColorTheme.tableLineColor),
                                columns: const [
                                  DataColumn(label: Text('Sl No')),
                                  DataColumn(label: Text('Consumer Name')),
                                  DataColumn(label: Text('Consumer Email')),
                                  DataColumn(label: Text('Consumer Phone')),
                                  DataColumn(label: Text('Vehicle Model')),
                                  DataColumn(label: Text('Number Plate')),
                                  DataColumn(label: Text('Annual Mileage')),
                                  DataColumn(label: Text('Action')),
                                ],
                                rows: displayedVehicles.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final consumer = entry.value;

                                  return DataRow(cells: [
                                    DataCell(Text('${currentPage * rowsPerPage + index + 1}')),
                                    DataCell(Text(consumer.consumerName ?? '')),
                                    DataCell(Text(consumer.email ?? '')),
                                    DataCell(Text(consumer.phone ?? '')),
                                    DataCell(Text(consumer.vehiclemodel ?? '')),
                                    DataCell(Text(consumer.plateno ?? '')),
                                    DataCell(Text(consumer.mileage ?? '')),
                                    DataCell(
                                        CommonButton(
                                          btnText: "View Products",
                                          buttonColor: BaseColorTheme.submittedBtnColor,
                                          buttonHeight: 25,
                                          buttonWidth: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 115),
                                          buttonBorderRaduis: 15,
                                          buttonTextColor: BaseColorTheme.whiteTextColor,
                                          buttonFontWeight: BaseFontWeights.semiBold,
                                          buttonFontSize: 10,
                                          onPressed: (){
                                            _navigateToProductList(consumer.uservehicleid);
                                          },
                                        )
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
                                onPressed: (currentPage + 1) * rowsPerPage < filteredVehicles.length
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
            ],
          ),
        ),
      ),
    );
  }
}