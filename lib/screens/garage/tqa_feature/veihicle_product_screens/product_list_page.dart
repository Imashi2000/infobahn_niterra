import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getProductsByGarageId_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/claim_registeration_page.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/manage_claim.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/product_registration.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/vehicle_registration.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/viewMore_byGarage_page.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/view_more_details_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/product_registration_services.dart';
import 'package:niterra/utils/size.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() =>
      _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProductRegistrationServices _productRegistrationServices = ProductRegistrationServices();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ProductsByGarageId> products = [];
  List<ProductsByGarageId> filteredProducts = [];
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
      _fetchProductsByGarageId();
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
        await _fetchProductsByGarageId();
      }

    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchProductsByGarageId() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedProducts = await _productRegistrationServices.fetchProductsByGarageId(loggedUserid!);
      setState(() {
        products = fetchedProducts;
        filteredProducts = products;
      });
    } catch (e) {
      print("Error occurred while fetching products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  // void _updateDisplayedData() {
  //   final startIndex = currentPage * rowsPerPage;
  //   final endIndex = (startIndex + rowsPerPage).clamp(0, products.length); // Ensure valid range
  //
  //   setState(() {
  //     displayedData = products.sublist(startIndex, endIndex); // Create a paginated view
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
      currentPage = 0; // Reset to the first page
    });
  }



  void _onSearch(String query) {
    setState(() {
      currentPage = 0; // Reset to the first page
      if (query.isEmpty) {
        filteredProducts = products; // Show all products if the query is empty
      } else {
        filteredProducts = products.where((product) {
          final searchQuery = query.toLowerCase();
          return (product.name?.toLowerCase().contains(searchQuery) ?? false) ||
              (product.phone?.toLowerCase().contains(searchQuery) ?? false) ||
              (product.vehiclemodel?.toLowerCase().contains(searchQuery) ?? false) ||
              (product.plateno?.toLowerCase().contains(searchQuery) ?? false) ||
              (product.producttype?.toLowerCase().contains(searchQuery) ?? false) ||
              (product.partno?.toLowerCase().contains(searchQuery) ?? false);
        }).toList();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < products.length) {
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
    final displayedProducts = filteredProducts
        .skip(currentPage * rowsPerPage)
        .take(rowsPerPage)
        .toList();

    final totalPages = (filteredProducts.length / rowsPerPage).ceil();

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
                      'PRODUCTS',
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
                                  buttonHeight: 22.0,
                                  buttonTextColor: BaseColorTheme.whiteTextColor,
                                  buttonWidth: 117.0,
                                  onPressed: () {
                                    Get.to(ProductRegistrationPage());
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
                                headingRowColor: WidgetStateColor.resolveWith(
                                        (states) => BaseColorTheme.tableHeadingBgColor),
                                dataRowColor: WidgetStateColor.resolveWith(
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
                                dataRowHeight: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 90.0),
                                border: TableBorder.all(
                                    color: BaseColorTheme.tableLineColor),
                                columns: const [
                                  DataColumn(label: Text('Sl No')),
                                  DataColumn(label: Text('Consumer Details')),
                                  DataColumn(label: Text('Vehicle Details')),
                                  DataColumn(label: Text('Product Details')),
                                  DataColumn(label: Text('Quantity')),
                                  DataColumn(label: Text('Installation Date')),
                                  DataColumn(label: Text('Warranty Expiry')),
                                  DataColumn(label: Text('Action')),
                                ],
                                rows: displayedProducts.asMap().entries.map((entry) {
                                  final index = currentPage * rowsPerPage + entry.key + 1;
                                  final product_details = entry.value;
                                  String buttonText ='';
                                  Color buttonColor = Colors.grey;
                                  double buttonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 80);

                                  switch (product_details.claimstatus) {
                                    case 'Claim Submitted':
                                      buttonText = 'Claim Submitted';
                                      buttonColor = BaseColorTheme.claimSubmittedColor;
                                      buttonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 140);
                                      break;
                                    case 'Submit Claim':
                                      buttonText = 'Submit Claim';
                                      buttonColor = BaseColorTheme.yellowLineColor;
                                      buttonWidth = ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 140);
                                      break;
                                  }

                                  return DataRow(cells: [
                                    DataCell(Text('$index')),
                                    DataCell(Text('Name : ${product_details.name}\nPhone: ${product_details.phone}')),
                                    DataCell(Text('Vehicle Model : ${product_details.vehiclemodel}\nPlate No : ${product_details.plateno}')),
                                    DataCell(Text('Prduct Type : ${product_details.producttype}\nPart No : ${product_details.partno}')),
                                    DataCell(Text(product_details.quantity.toString())),
                                    DataCell(Text(product_details.installdate)),
                                    DataCell(
                                        CommonButton(
                                          btnText: product_details.expirydate,
                                          buttonColor: BaseColorTheme.primaryGreenColor,
                                          buttonHeight: 25,
                                          buttonWidth: 110,
                                          buttonBorderRaduis: 15,
                                          buttonTextColor: BaseColorTheme.whiteTextColor,
                                          buttonFontWeight: BaseFontWeights.medium,
                                          buttonFontSize: 10,
                                          onPressed: (){},
                                        )),
                                    DataCell(
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
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
                                              Get.to(ManageClaimScreen());
                                            },
                                          ),
                                          CommonButton(
                                            btnText: "View Details",
                                            buttonColor: BaseColorTheme.viewClaim,
                                            buttonHeight: 25,
                                            buttonWidth: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 105),
                                            buttonBorderRaduis: 15,
                                            buttonTextColor: BaseColorTheme.whiteTextColor,
                                            buttonFontWeight: BaseFontWeights.medium,
                                            buttonFontSize: 10,
                                            onPressed: (){
                                              Get.to(() => ViewMoreDetailsGaragePage(userProductId: product_details.userproductid));
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
            ],
          ),
        ),
      ),
    );
  }
}

