import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/consumer_screens/consumer_registration_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/consumer_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:niterra/models/garage_models/getConsumerbyCountry_model.dart';

class ConsumerRequestsScreen extends StatefulWidget {
  ConsumerRequestsScreen({super.key});

  @override
  _ConsumerRequestsScreenState createState() => _ConsumerRequestsScreenState();
}

class _ConsumerRequestsScreenState extends State<ConsumerRequestsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ConsumerApiService _consumerApiService = ConsumerApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ConsumerbyCountryModel> consumers = [];
  List<ConsumerbyCountryModel> filteredConsumers = [];
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
      _fetchConsumersByCountrylist();
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
        await _fetchConsumersByCountrylist();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchConsumersByCountrylist() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedConsumers = await _consumerApiService
          .fetchConsumersByCountrylist(loggedCountryId!);



      setState(() {
        consumers = fetchedConsumers;
        filteredConsumers = List.from(consumers); // Initialize filtered data
      });
    } catch (e) {
      print("Error occurred while fetching consumers: $e");

      setState(() {
        isLoading = false;
      });

      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching consumers: $e')),
        );
      });
    }
  }

  // void _updateDisplayedData() {
  //   final startIndex = currentPage * rowsPerPage;
  //   final endIndex = startIndex + rowsPerPage;
  //
  //   setState(() {
  //     displayedData = consumers.sublist(
  //       startIndex,
  //       endIndex > consumers.length ? consumers.length : endIndex,
  //     );
  //   });
  // }

  // void _onPageChanged(int page) {
  //   setState(() {
  //     currentPage = page;
  //     currentPage = 0;
  //     //_updateDisplayedData();
  //   });
  // }

  void _onRowsPerPageChanged(int rows) {
    setState(() {
      rowsPerPage = rows;
      currentPage = 0;
    //  _updateDisplayedData();
    });
  }

  void _onSearch(String query) {
    setState(() {
      currentSearch = query;
      if (query.isEmpty) {
        filteredConsumers = List.from(consumers); // Reset to all data
      } else {
        filteredConsumers = consumers.where((consumer) {
          final lowerQuery = query.toLowerCase();
          return (consumer.name?.toLowerCase().contains(lowerQuery) ?? false) ||
              (consumer.email?.toLowerCase().contains(lowerQuery) ?? false) ||
              (consumer.phone?.toLowerCase().contains(lowerQuery) ?? false) ||
              (consumer.city?.toLowerCase().contains(lowerQuery) ?? false) ||
              (consumer.address?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
      }
      currentPage = 0; // Reset pagination
    });
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < consumers.length) {
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
    final displayedConsumers = filteredConsumers.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();
    final totalPages = (filteredConsumers.length / rowsPerPage).ceil();
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
                      'CONSUMER REQUESTS',
                      style: TextStyle(
                        color: BaseColorTheme.subHeadingTextColor,
                        fontSize: 20.0,
                        fontWeight: BaseFontWeights.semiBold,
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
                                    Get.to(ConsumerRegistrationPage());
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
                              const SizedBox(width: 8),
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
                                  context: context, portionWidthValue: 16.0),),
                              const Text(
                                "Entries Search",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: BaseColorTheme.unselectedIconColor,
                                    fontWeight: BaseFontWeights.medium),
                              ),
                              SizedBox(width: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 16.0),),
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
                                  DataColumn(label: Text('Email')),
                                  DataColumn(label: Text('Phone')),
                                  DataColumn(label: Text('City')),
                                  DataColumn(label: Text('Address')),
                                  DataColumn(label: Text('Status')),
                                ],
                                rows: displayedConsumers.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final consumer = entry.value;
                                  String buttonText = '';
                                  Color buttonColor = Colors.grey;
                                  double buttonWidth = 80.0;
      
                                  switch (consumer.cstatus) {
                                    case 'Approved':
                                      buttonText = 'Approved Request';
                                      buttonColor = BaseColorTheme.approvedColor;
                                      buttonWidth = 145.0;
                                      break;
                                    case 'Request Pending':
                                      buttonText = 'Request Pending';
                                      buttonColor = BaseColorTheme.submittedBtnColor;
                                      buttonWidth = 145.0;
                                      break;
                                  }
                                  return DataRow(cells: [
                                    DataCell(Text('${currentPage * rowsPerPage + index + 1}')),
                                    DataCell(Text(consumer.name ?? '')),
                                    DataCell(Text(consumer.email ?? '')),
                                    DataCell(Text(consumer.phone ?? '')),
                                    DataCell(Text(consumer.city ?? '')),
                                    DataCell(Text(consumer.address ?? '')),
                                    DataCell(
                                      CommonButton(
                                          btnText: buttonText,
                                          buttonColor: buttonColor,
                                          buttonHeight: 25,
                                          buttonWidth: buttonWidth,
                                          buttonBorderRaduis: 15,
                                          buttonTextColor: BaseColorTheme.whiteTextColor,
                                          buttonFontWeight: BaseFontWeights.semiBold,
                                          buttonFontSize: 10,
                                        onPressed: (){},
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
                                    ? () => setState(() => currentPage--)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text('${currentPage + 1} / $totalPages'),
                              IconButton(
                                onPressed: (currentPage + 1) * rowsPerPage < filteredConsumers.length
                                    ? () => setState(() => currentPage++)
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
