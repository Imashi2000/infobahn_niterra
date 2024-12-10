import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/dropdown_field.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/common/widgets/text_field.dart';
import 'package:niterra/models/garage_models/getBrand_model.dart';
import 'package:niterra/models/garage_models/getPdtdetailbyPartno_model.dart';
import 'package:niterra/models/garage_models/getPlateNoByGarageId_model.dart';
import 'package:niterra/models/garage_models/getProductTypeSub_model.dart';
import 'package:niterra/models/garage_models/getRetailerbyCountry_model.dart';
import 'package:niterra/models/garage_models/getVehiclebyPlateno_model.dart';
import 'package:niterra/models/garage_models/get_all_part_no_model.dart';
import 'package:niterra/models/garage_models/get_partno_by_productType_model.dart';
import 'package:niterra/models/garage_models/get_product_category_model.dart';
import 'package:niterra/models/garage_models/get_product_type_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/product_list_page.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/save_product_page.dart';
import 'package:niterra/services/garage_services/product_registration_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProductRegistrationPage extends StatefulWidget {
  const ProductRegistrationPage({super.key});

  @override
  _ProductRegistrationPageState createState() =>
      _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProductRegistrationService _service = ProductRegistrationService();
  TextEditingController _vehicleModelController = TextEditingController();

  List<PlateNumberByGarage> plateNumbers = [];
  List<BrandModel> brands = [];
  List<AllPartNoModel> allpartno = [];
  List<PartNoByProductTypeModel> partNumbers = [];
  ProductCategoryModel? selectedProductCategory;
  List<ProductCategoryModel> productCategory = [];
  List<ProductTypeModel> productType = [];
  List<RetailerData> purchasePlaces = [];
  List<ProductTypeSubModel> productTypesSub = [];
  List<ProductDetailsByPartNo> productDetails = [];
  VehicleByPlateNo? vehiclemodel;
  ProductTypeModel? selectedProductType;
  BrandModel? selectedBrand;
  String? selectedPartNo;
  String? selectedPurchasePlace;
  String? selectedPlateNumber;
  String? odometer;
  String? qty = "";
  String? installationDate;
  String? selectedProductTypeSub;

  String? loggedInUserId;
  int? countryId;
  String? otherRetailer;
  File? _selectedProductImage;
  File? _selectedInvoiceImage;

  bool isBrandSelectedFirst = false;
  bool isProductCategoryAvailable = false;
  bool isProductTypeAvailable = false;
  bool isPartNoAvailable = true;
  bool isBrandAvaliable = true;

  @override
  void initState() {
    super.initState();
    _initializeAndFetchData();
    installationDate = DateTime.now().toIso8601String().split('T')[0];
  }

  Future<void> _initializeAndFetchData() async {
    try {
      await _initializeUserData();

      if (countryId != null && loggedInUserId != null) {
        await _fetchPlateNumbersByGarageId();
        await _fetchRetailers();
      }

      await _fetchAllPartNos();
      await _fetchBrands();
      await _fetchProductTypeSub();
    } catch (e) {
      print('Error in _initializeAndFetchData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing data: $e')),
      );
    }
  }


  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedInUserId = userDetails['userId']; // Correct key is 'userId'
        countryId = int.tryParse(
            userDetails['countryId'] ?? '0'); // Correct key is 'countryId'
      });

      print("Initialized -> LoggedInUserId: $loggedInUserId, CountryId: $countryId");

    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchPlateNumbersByGarageId() async {
    try {
      final plates = await ProductRegistrationServices()
          .fetchPlateNumbersByGarageId(loggedInUserId!);
      setState(() {
        plateNumbers = plates;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load plate numbers: $e')),
      );
    }
  }

  Future<void> _fetchVehicleModelByPlateId(String plateno) async {
    try {
      final vehicle = await ProductRegistrationServices().fetchModelbyPlateNo(plateno);
      if (mounted) {
        setState(() {
          vehiclemodel = vehicle; // Store the fetched object
          _vehicleModelController.text = vehicle.vehiclemodel; // Update the controller
          print('Vehicle Model: ${vehiclemodel?.vehiclemodel}'); // Debug log
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load vehicle model: $e'),
          ),
        );
      }
    }
  }



  Future<void> _fetchBrands() async {
    try {
      final brandList = await ProductRegistrationServices().fetchBrands();
      setState(() {
        brands = brandList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load brands: $e')),
      );
    }
  }

  Future<void> _fetchAllPartNos() async {
    try {
      final part_no = await ProductRegistrationServices().fetchAllPartNos();
      setState(() {
        allpartno = part_no;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load part numbers: $e')),
      );
    }
  }

  Future<void> _fetchProductCategory(int brandId) async {
    try {
      final categories = await ProductRegistrationServices()
          .fetchProductCategoryByBrandId(brandId);
      setState(() {
        productCategory = categories;
        isProductCategoryAvailable = true;
        isProductTypeAvailable = false;

        selectedProductCategory = null; // Reset selected category
        productType = [];
        selectedProductType = null; // Reset selected product type
        partNumbers = [];
        selectedPartNo = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product categories: $e')),
      );
    }
  }

  Future<void> _fetchProductType(int categoryId) async {
    try {
      final types = await ProductRegistrationServices()
          .fetchProductTypeByCategoryId(categoryId);
      setState(() {
        productType = types;
        isProductTypeAvailable = true;
        isPartNoAvailable = false;
        selectedProductType = null; // Reset selected product type
        partNumbers = [];
        selectedPartNo = null; // Reset selected part number
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product types: $e')),
      );
    }
  }

  Future<void> _fetchProductTypeSub() async {
    try {
      final subList = await ProductRegistrationServices().fetchProductTypeSub();
      setState(() {
        productTypesSub = subList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product types: $e')),
      );
    }
  }

  Future<void> _fetchPartNoByProductTypeId(int productTypeId) async {
    try {
      final parts = await ProductRegistrationServices()
          .fetchPartNoByProductTypeId(productTypeId);
      setState(() {
        partNumbers = parts;
        selectedPartNo = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load part numbers by product type: $e')),
      );
    }
  }

  Future<void> _fetchRetailers() async {
    try {
      final purchase_places = await ProductRegistrationServices()
          .fetchRetailersByCountryId(
          countryId!); // Replace with actual country ID
      setState(() {
        purchasePlaces = purchase_places;
      });
    } catch (e) {
      print("Error fetching retailers: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch retailers')),
      );
    }
  }

  Future<void> _fetchProductDetailsByPartNo(String partNo) async {
    try {
      final details = await ProductRegistrationServices().fetchProductDetailsByPartNo(partNo);

      setState(() {
        selectedBrand = BrandModel(
          brand: details.brand,
          brandid: details.brandid,
        );
        selectedProductCategory = ProductCategoryModel(
            pdtcategory: details.pdtcategory,
            pdtcategoryid: details.pdtcategoryid,
            disclaimer: details.disclaimer
        );
        selectedProductType = ProductTypeModel(
          pdttype: details.pdttype,
          pdttypeid: details.pdttypeid,
        );
        isBrandAvaliable = false;
        isProductCategoryAvailable = false;
        isProductTypeAvailable = false;
      });

      if(details.disclaimer.isNotEmpty){
        CommonLoaders.warningSnackBar(title: 'Disclaimer',message: details.disclaimer, duration: 5);
      }

    } catch (e) {
      print('Failed to fetch product details by part number: $e');
    }
  }

  void _handlePartNoSelection(String partNo) {
    setState(() {
      selectedPartNo = partNo;

      // Find the part number object from the allpartno list
      final selectedPartObject = allpartno.firstWhere(
            (part) => part.partno == partNo, // Handle cases where no matching part is found
      );

      if (selectedPartObject != null) {
        final partNoId = selectedPartObject.productid; // Get the part ID
        print('Selected PartNo ID: $partNoId');

        // Disable other fields
        isBrandAvaliable = false;
        isProductCategoryAvailable = false;
        isProductTypeAvailable = false;

        // Fetch product details using the part number ID
        _fetchProductDetailsByPartNo(partNoId.toString());
      } else {
        print('Part number not found in the list');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected part number not found')),
        );
      }
    });
  }


  void _handleBrandSelection(BrandModel brand) {
    setState(() {
      selectedBrand = brand;
      isBrandSelectedFirst = true;

      isProductCategoryAvailable = true;
      isProductTypeAvailable = false;
      // Reset other fields
      _resetDynamicFields();
    });
    _fetchProductCategory(brand.brandid);
  }


  void _resetDynamicFields() {
    setState(() {
      selectedBrand = null;
      productCategory = [];
      selectedProductCategory = null;
      productType = [];
      selectedProductType = null;
      partNumbers = [];
      selectedPartNo = null;
      isProductCategoryAvailable = false;
      isProductTypeAvailable = false;
      isPartNoAvailable = false;
    });
  }

  @override
  void dispose() {
    _vehicleModelController.dispose();
    super.dispose();
  }


  Future<void> pickProductImage() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        _selectedProductImage = file;
      });
    }
  }

  Future<void> pickInvoiceImage() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        _selectedInvoiceImage = file;
      });
    }
  }

  Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String username = 'NiterraMobile';
        String password = 'ha@jhashHhg*&63';
        String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

        var request = http.MultipartRequest(
          'POST',
          Uri.parse("https://trustedprog.com/api/saveProduct.php"),
        );

        // Add Authorization Header
        request.headers['Authorization'] = basicAuth;

        // Add Fields
        request.fields.addAll({
          'action': 'saveProduct',
          'vehicleid': plateNumbers
              .firstWhere((plate) => plate.plateNo == selectedPlateNumber)
              .vehicleId
              .toString(),
          'productid': allpartno
              .firstWhere((part) => part.partno == selectedPartNo)
              .productid
              .toString(),
          'producttypeid': selectedProductType?.pdttypeid.toString() ?? '0',
          'productsubid': selectedProductTypeSub ?? '0',
          'partnoqty': qty ?? '0',
          'purchaseplace': selectedPurchasePlace == 'Others'
              ? ""
              : purchasePlaces
              .firstWhere((place) => place.displayRetailerName == selectedPurchasePlace)
              .userid
              .toString(),
         'otheretailer': selectedPurchasePlace == 'Others' ? otherRetailer ?? "" : "",
          'odometer': odometer ?? '',
          'garageid': loggedInUserId ?? '0',
        });

        // Add Files
        if (_selectedProductImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'productimg',
            _selectedProductImage!.path,
            contentType: MediaType('image', _getFileExtension(_selectedProductImage!)),
          ));
        }

        if (_selectedInvoiceImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'invoiceimg',
            _selectedInvoiceImage!.path,
            contentType: MediaType('image', _getFileExtension(_selectedInvoiceImage!)),
          ));
        }

        // Debug Logs
        print('Request Fields: ${request.fields}');
        print('Request Headers: ${request.headers}');
        print('Product Image Path: ${_selectedProductImage?.path}');
       print('Invoice Image Path: ${_selectedInvoiceImage?.path}');

        var response = await request.send();


        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseData);

          if (jsonResponse['status'] == 'success') {
            CommonLoaders.successSnackBar(title:'Sucess',message: 'Product Saved Successfully', duration: 4);
            Get.to(const ProductListPage());
          } else {
            print(jsonResponse);
            throw Exception(jsonResponse['message']);
          }
        } else {
          final errorData = await response.stream.bytesToString();
          print('Error Response: $errorData');
          throw Exception('Failed with status code: ${response.statusCode}, details: $errorData');
        }
      } catch (e) {
        print('Error saving product: $e');
        CommonLoaders.errorSnackBar(title: 'Error',message: "Error in saving Products $e", duration: 4);
      }
    }
  }

// Helper Function
  String _getFileExtension(File file) {
    return file.path.split('.').last.toLowerCase();
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
                      context: context, portionWidthValue: 17.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 8.0),
                    ),
                    const Text(
                      'DASHBOARD',
                      style: TextStyle(
                        color: BaseColorTheme.garageHeadingTextColor,
                        fontSize: 22.0,
                        fontWeight: BaseFontWeights.semiBold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 40.23),
                    ),
                    const Text(
                      'PRODUCT REGISTRATION',
                      style: TextStyle(
                        color: BaseColorTheme.subHeadingTextColor,
                        fontSize: 20.0,
                        fontWeight: BaseFontWeights.semiBold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 29.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 280),
                      child: CommonButton(
                        btnText: 'List All',
                        buttonColor: BaseColorTheme.buttonBgColor,
                        buttonHeight: 22,
                        buttonWidth: 90,
                        buttonBorderRaduis: 10,
                        buttonTextColor: BaseColorTheme.whiteTextColor,
                        buttonFontWeight: BaseFontWeights.medium,
                        buttonFontSize: 12,
                        onPressed: () {
                          Get.to(ProductListPage());
                        },
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 29.0),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                const Text(
                                  'Vehicle Details',
                                  style: TextStyle(
                                    color: BaseColorTheme.subHeadingTextColor,
                                    fontSize: 19.0,
                                    fontWeight: BaseFontWeights.semiBold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 15.0),
                                ),
                                DropdownFieldBox(
                                  label: 'Plate Number',
                                  hint: 'Select Plate Number',
                                  items: plateNumbers.map((plate) => plate.plateNo).toList(),
                                  value: selectedPlateNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPlateNumber = value; // Set the selected plate number
                                    });
      
                                    // Find the selected plate object to get its ID
                                    final selectedPlateObject = plateNumbers.firstWhere(
                                          (plate) => plate.plateNo == value, // Default if not found
                                    );
      
                                    if (selectedPlateObject.vehicleId != null) {
                                      // Use the selected plate's ID
                                      print('Selected Plate ID: ${selectedPlateObject.vehicleId}');
      
                                      // Fetch vehicle model using the plate ID
                                      _fetchVehicleModelByPlateId(selectedPlateObject.vehicleId.toString());
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invalid plate number selected.')),
                                      );
                                    }
                                  },
                                ),
      
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                TextFieldForm(
                                  label: 'Vehicle Model',
                                  hint: '',
                                  controller: _vehicleModelController,
                                  onChanged: (_) {},
                                  enabled: false,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                const Text(
                                  'Product Details',
                                  style: TextStyle(
                                    color: BaseColorTheme.subHeadingTextColor,
                                    fontSize: 19.0,
                                    fontWeight: BaseFontWeights.semiBold,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 15.0),
                                ),
                                (!isBrandSelectedFirst)
                                    ? DropdownFieldBox(
                                  label: 'Part No',
                                  hint: 'Select Part No',
                                  items: allpartno.map((part) => part.partno).toList(),
                                  value: selectedPartNo,
                                  onChanged: isPartNoAvailable
                                      ? (value) {
                                    if (value != null) {
                                      _handlePartNoSelection(value);
                                    }
                                  }
                                      : null,
                                )
                                    : Container(),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                DropdownFieldBox(
                                  label: 'Brand',
                                  hint: 'Select Brand',
                                  items: brands.map((brand) => brand.brand).toList(),
                                  value: selectedBrand?.brand,
                                  onChanged: isBrandAvaliable
                                      ? (value) {
                                    final brand =
                                    brands.firstWhere((b) => b.brand == value);
                                    _handleBrandSelection(brand);
      
                                  }
                                      : null,
      
                                ),
                                DropdownFieldBox(
                                  label: 'Product Category',
                                  hint: 'Select Product Category',
                                  items: productCategory
                                      .map((cat) => cat.pdtcategory)
                                      .toList(),
                                  value: selectedProductCategory?.pdtcategory,
                                  onChanged: (value) {
                                    final category = productCategory.firstWhere(
                                            (c) => c.pdtcategory == value);
                                    setState(() {
                                      selectedProductCategory = category;
                                      productType = [];
                                      selectedProductType =
                                      null; // Reset product type
                                      partNumbers = [];
                                      selectedPartNo = null;
                                    });
                                    _fetchProductType(category.pdtcategoryid);
                                    if (category.disclaimer.isNotEmpty) {
                                      CommonLoaders.warningSnackBar(
                                        title: 'Disclaimer',
                                        message: category.disclaimer,
                                        duration: 5,
                                      );
                                    }
                                  },
                                ),
                                DropdownFieldBox(
                                  label: 'Product Type',
                                  hint: 'Select Product Type',
                                  items: productType.map((type) => type.pdttype).toList(),
                                  value: selectedProductType?.pdttype,
                                  onChanged: (value) {
                                    final type = productType.firstWhere((t) => t.pdttype == value);
                                    setState(() {
                                      selectedProductType = type;
                                      selectedPartNo = null; // Reset PartNo
                                      isPartNoAvailable = true;
                                    });
      
                                    print('Selected Product Type: ${type.pdttype}'); // Debug log
                                    _fetchPartNoByProductTypeId(type.pdttypeid);
                                  },
                                ),
                                if (selectedProductType?.pdttype == 'Metal GP')
                                  DropdownFieldBox(
                                    label: 'Product Type sub-types',
                                    hint: 'Select a subtype',
                                    items: productTypesSub
                                        .map((sub) => sub.protypesub)
                                        .toSet()
                                        .toList(), // Ensure unique items
                                    value: productTypesSub.any((sub) => sub.protypesubid.toString() == selectedProductTypeSub)
                                        ? productTypesSub
                                        .firstWhere(
                                          (sub) => sub.protypesubid.toString() == selectedProductTypeSub,
                                    )
                                        .protypesub
                                        : null, // Set to null if no match is found
                                    onChanged: (value) {
                                      setState(() {
                                        // Find the selected subtype and update its ID
                                        final subtype = productTypesSub.firstWhere(
                                              (sub) => sub.protypesub == value,
                                          orElse: () => ProductTypeSubModel(protypesub: '', protypesubid: 0), // Fallback
                                        );
                                        selectedProductTypeSub = subtype.protypesubid.toString();
                                      });
                                    },
                                  ),
                                (isBrandSelectedFirst)
                                    ? DropdownFieldBox(
                                  label: 'Part No',
                                  hint: 'Select Part No',
                                  items: partNumbers.map((parts) => parts.partno).toList(),
                                  value: selectedPartNo,
                                  onChanged: isPartNoAvailable
                                      ? (value) {
                                    setState(() {
                                      selectedPartNo = value; // Assign the selected value directly
                                    });
                                  }
                                      : null,
                                )
                                    : Container(),
      
      
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                TextFieldForm(
                                  label: 'Qty of Part No',
                                  hint: 'Enter Quantity',
                                  value: qty ?? '', // Default to an empty string
                                  onChanged: (value) {
                                    setState(() {
                                      qty = value; // Capture the user input
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                ),
      
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                DropdownFieldBox(
                                  label: 'Place of Purchase',
                                  hint: 'Select purchase Type',
                                  items: [
                                    ...purchasePlaces
                                        .map((places) =>
                                    places.displayRetailerName)
                                        .toList(),
                                    'Others', // Add the 'Others' option
                                  ],
                                  value: selectedPurchasePlace,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPurchasePlace = value;
                                      String disclaimerMessage = '';
                                      if (value == 'Others') {
                                        disclaimerMessage = 'Visit the same garage or any other trusted garage in your country for the claim of this product.';
                                      } else {
                                        final place = purchasePlaces.firstWhere(
                                              (place) => place.displayRetailerName == value,
                                        );
                                        disclaimerMessage = place.disclaimer.isNotEmpty
                                            ? place.disclaimer
                                            : 'Visit the same garage or any other trusted garage in your country for the claim of this product.';
                                      }
      
                                      // Show the disclaimer message
                                      CommonLoaders.warningSnackBar(
                                        title: 'Disclaimer for Claim',
                                        message: disclaimerMessage,
                                        duration: 5,
                                      );
                                    });
                                  },
                                ),
                                if (selectedPurchasePlace == 'Others')
                                  TextFieldForm(
                                    label: '',
                                    hint: 'Enter retailer name',
                                    value:
                                    otherRetailer, // Use a separate variable for this field
                                    onChanged: (value) {
                                      otherRetailer =
                                          value; // Store the custom input
                                    },
                                  ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
      
                                TextFieldForm(
                                  label: 'Odometer',
                                  hint: 'Enter Odometer Reading',
                                  value: odometer,
                                  onChanged: (value) {
                                    odometer = value;
                                  },
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                TextFieldForm(
                                  label: 'Installation date',
                                  hint: 'YYYY-MM-DD',
                                  value: installationDate,
                                  onChanged: (_){},
                                  enabled: false,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                _buildFilePickerRow(
                                  label: 'Product Image',
                                  fileName: _selectedProductImage?.path,
                                  onPick: pickProductImage,
                                ),
                                const SizedBox(height: 8),
                                _buildFilePickerRow(
                                  label: 'Invoice Image',
                                  fileName: _selectedInvoiceImage?.path,
                                  onPick: pickInvoiceImage,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CommonButton(
                                    btnText: 'Submit',
                                    buttonColor:
                                    BaseColorTheme.dropdownBoderColor,
                                    buttonHeight: 25,
                                    buttonWidth: 90,
                                    buttonBorderRaduis: 0,
                                    buttonTextColor:
                                    BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.regular,
                                    buttonFontSize: 12,
                                    onPressed: _submitForm,
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 34.0),
                                ),
                              ]),
                        ),
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

  Widget _buildFilePickerRow({
    required String label,
    required String? fileName,
    required VoidCallback onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CommonButton(
              btnText: 'Choose File',
              buttonColor: BaseColorTheme.textfieldShadowColor,
              buttonHeight: 25,
              buttonWidth: 117,
              buttonBorderRaduis: 0,
              buttonTextColor: BaseColorTheme.blackColor,
              buttonFontWeight: BaseFontWeights.regular,
              buttonFontSize: 12,
              onPressed: onPick,
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 2,
              child: Text(fileName != null
                  ? fileName.split('/').last
                  : 'No file chosen'),
            ),
          ],
        ),
        const Divider(thickness: 1, color: Colors.black54),
      ],
    );
  }

}