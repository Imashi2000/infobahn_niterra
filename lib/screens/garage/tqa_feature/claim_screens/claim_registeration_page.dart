import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/dropdown_field.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getPartnoByVehicleId_model.dart';
import 'package:niterra/models/garage_models/getPlatenoByCountry_model.dart';
import 'package:niterra/models/garage_models/getProductDetailbyUserproductId_model.dart';
import 'package:niterra/models/garage_models/getVehiclebyPlateno_model.dart';
import 'package:niterra/models/garage_models/saveClaimRequest_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/manage_claim.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/cliam_pages_services.dart';
import 'package:niterra/services/garage_services/product_registration_services.dart';
import 'package:niterra/utils/size.dart';

class ClaimRegisterationPage extends StatefulWidget {
  ClaimRegisterationPage({super.key});

  @override
  State<ClaimRegisterationPage> createState() => _ClaimRegisterationPageState();
}

class _ClaimRegisterationPageState extends State<ClaimRegisterationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _vehicleModelController = TextEditingController();
  TextEditingController _productTypeController = TextEditingController();
  TextEditingController _installDateController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _qtyInstalledController = TextEditingController();
  TextEditingController _qtyClaimController = TextEditingController();
  TextEditingController _odometerController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> selectedImages = []; // Store picked images

  bool isChecked = false;
  String? loggedInUserId;
  int? countryId;
  String? claimRequestDate;
  String? disclaimerMessage;
  int disclaimerStatus = 0;

  List<PlateNumberByCountry> plateNumbers = [];
  List<PartNoByVehicle> partNumbers=[];
  List<Diagnosis> diagnosisList = [];

  String? selectedPlateNumber;
  VehicleByPlateNo? vehiclemodel;
  String? selectedPartNo;
  String? selectedDiagnosis;


  ClaimResponse? claimDetails;

  @override
  void initState() {
    super.initState();
    _initializeAndFetchData();
    claimRequestDate = DateTime.now().toIso8601String().split('T')[0];
  }

  Future<void> _initializeAndFetchData() async {
    try {
      await _initializeUserData();

      if (countryId != null && loggedInUserId != null) {
        await _fetchPlateNumbersByCountry();
      }
    } catch (e) {
      print('Error in _initializeAndFetchData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing data: $e')),
      );
    }
  }

  Future<void> _initializeUserData() async {
    try {
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedInUserId = userDetails['userId'];
        countryId = int.tryParse(userDetails['countryId'] ?? '0');
      });

      print(
          "Initialized -> LoggedInUserId: $loggedInUserId, CountryId: $countryId");
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchPlateNumbersByCountry() async {
    try {
      final plates =
          await ClaimServices().fetchPlateNumbersByCountryId(countryId!);
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
      final vehicle =
          await ProductRegistrationServices().fetchModelbyPlateNo(plateno);
      if (mounted) {
        setState(() {
          vehiclemodel = vehicle; // Store the fetched object
          _vehicleModelController.text =
              vehicle.vehiclemodel; // Update the controller
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

  Future<void> _fetchPartNobyVehicleId(int vehicleId) async {
    try {
      final partnos = await ClaimServices().fetchPartNoByVehicle(vehicleId);
      print('Fetched Part Numbers: $partnos'); // Log the fetched part numbers
      if (mounted) {
        setState(() {
          partNumbers = partnos; // Update the part numbers list
        });
      }
    } catch (e) {
      print('Error fetching part numbers: $e'); // Log errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load part numbers: $e')),
        );
      }
    }
  }


  Future<void> _fetchClaimDetails(int productid) async {
    print('Fetching Claim Details for Product ID: $productid');
    try {
      final details = await ClaimServices().fetchClaimDetails(productid);
      print('Claim Details Response: $details');
      setState(() {
        claimDetails = details;

        // Update the controllers with claim details
        _productTypeController.text = details.productDetail.productType;
        _installDateController.text = details.productDetail.installDate;
        _expiryDateController.text = details.productDetail.expiryDate;
        _qtyInstalledController.text = details.productDetail.partNoQty.toString();
        diagnosisList = details.diagnosis;
        disclaimerMessage = details.disclaimer;

      });
    } catch (e) {
      print('Error fetching claim details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load claim details: $e')),
      );
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedImages = await _imagePicker.pickMultiImage();
      if (pickedImages != null) {
        if (pickedImages.length < 3 || pickedImages.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a minimum of 3 and a maximum of 5 images.'),
            ),
          );
        } else {
          setState(() {
            selectedImages = pickedImages; // Update the selected images
          });
        }
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  List<String> _getImageNames() {
    // Extract the image names from the file paths
    return selectedImages.map((image) => image.name).toList();
  }

  void _submitClaim() async {
    // Validate required fields
    if (selectedPlateNumber == null || selectedPartNo == null || selectedDiagnosis == null) {
      CommonLoaders.errorSnackBar(title: 'Error',message: 'Please complete all required fields.', duration: 4);
      return;
    }

    if (selectedImages.length < 3 || selectedImages.length > 5) {
      CommonLoaders.errorSnackBar(title: 'Error',message: 'Please select a minimum of 3 and a maximum of 5 images.', duration: 4);
      return;
    }

    // Retrieve the correct vehicleId, productId, diagnosisId
    final vehicleId = plateNumbers
        .firstWhere((plate) => plate.plateno == selectedPlateNumber)
        .vehicleid;

    final productId = partNumbers
        .firstWhere((part) => part.partno == selectedPartNo)
        .userproductid;

    final diagnosisId = diagnosisList
        .firstWhere((diag) => diag.diagnosis == selectedDiagnosis)
        .diagnosisId;

    final claimQty = int.tryParse(_qtyInstalledController.text) ?? 0;
    final odometer = int.tryParse(_odometerController.text) ?? 0;

    final request = SaveClaimRequest(
      action: "saveClaim",
      vehicleId: vehicleId,
      productId: productId,
      claimQty: claimQty,
      diagnosis: diagnosisId,
      odometer: odometer,
      garageId: int.parse(loggedInUserId ?? '0'),
      confirmStatus: disclaimerStatus,
     // images: _getImageNames(),
    );

    try {
      final response = await ClaimServices().saveClaim(request);

      if (response.status == 'success') {
       CommonLoaders.successSnackBar(title: 'Success',message: response.message, duration: 4);
        Get.to(ManageClaimScreen());
      } else {
       CommonLoaders.errorSnackBar(title: 'Error',message: response.message, duration: 4);
      }
    } catch (e) {
      CommonLoaders.errorSnackBar(title: 'Error', message: '$e',duration: 4);
    }
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
                          context: context, portionHeightValue: 47),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CommonButton(
                          buttonColor: BaseColorTheme.buttonBgColor,
                          btnText: 'List All',
                          buttonBorderRaduis: 10.0,
                          buttonFontSize: 12.0,
                          buttonFontWeight: BaseFontWeights.medium,
                          buttonHeight: 25.0,
                          buttonTextColor: BaseColorTheme.whiteTextColor,
                          buttonWidth: 90,
                          onPressed: () {
                            Get.to(ManageClaimScreen());
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 10),
                    ),
                    Container(
                      decoration: BoxDecoration(
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
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 16),
                              ),
                              DropdownFieldBox(
                                label: 'Plate Number',
                                hint: 'Select Plate Number',
                                items: plateNumbers
                                    .map((plate) => plate.plateno)
                                    .toList(),
                                value: selectedPlateNumber,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPlateNumber = value; // Set the selected plate number
                                    selectedPartNo = null;
                                    partNumbers.clear();
                                    _vehicleModelController.clear();
                                    selectedDiagnosis = null;
                                    diagnosisList.clear();
                                    _productTypeController.clear();
                                    _installDateController.clear();
                                    _expiryDateController.clear();
                                    _qtyInstalledController.clear();
                                  });

                                  // Find the selected plate object to get its ID
                                  final selectedPlateObject =
                                      plateNumbers.firstWhere(
                                    (plate) =>
                                        plate.plateno ==
                                        value, // Default if not found
                                  );

                                  if (selectedPlateObject.vehicleid != null) {
                                    // Use the selected plate's ID
                                    print(
                                        'Selected Plate ID: ${selectedPlateObject.vehicleid}');

                                    // Fetch vehicle model using the plate ID
                                    _fetchVehicleModelByPlateId(
                                        selectedPlateObject.vehicleid.toString());
                                    _fetchPartNobyVehicleId(selectedPlateObject.vehicleid);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Invalid plate number selected.')),
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Vehicle',
                                controller: _vehicleModelController,
                                enabled: false,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              DropdownFieldBox(
                                label: 'Part No',
                                hint: 'Select Part Number',
                                items: partNumbers.map((part) => part.partno).toList(),
                                value: selectedPartNo,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPartNo = value; // Update the selected part number

                                    _productTypeController.clear();
                                    _installDateController.clear();
                                    _expiryDateController.clear();
                                    _qtyInstalledController.clear();
                                  });
                                  final selectedPartNoObject = partNumbers.firstWhere(
                                          (part) => part.partno == value);
                                  if (selectedPartNoObject != null) {
                                    print('Selected Part No Object: ${selectedPartNoObject.userproductid}');
                                    _fetchClaimDetails(selectedPartNoObject.userproductid);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid part number selected.')),
                                    );
                                  }
                                },
                              ),

                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Product Type',
                                controller: _productTypeController,
                                enabled: false,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Installation Date',
                                controller: _installDateController,
                                enabled: false,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Warranty Expiry',
                                controller: _expiryDateController,
                                enabled: false,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Qty Installed',
                                controller: _qtyInstalledController,
                                enabled: false,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Qty to be Claimed',
                                hinttext: 'Qty to be claimed',
                                fillColor: BaseColorTheme.whiteTextColor,
                                controller: _qtyClaimController,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              DropdownFieldBox(
                                label: 'Damage Diagnosis',
                                hint: 'Select Diagnosis',
                                items: diagnosisList.map((diagnosis) => diagnosis.diagnosis).toList(),
                                value: selectedDiagnosis,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDiagnosis = value;
                                    print('Selected Diagnosis: $selectedDiagnosis');
                                  });
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Odometer Reading',
                                hinttext: 'Enter Odometer Reading',
                                fillColor: BaseColorTheme.whiteTextColor,
                                controller: _odometerController,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              CustomTextField(
                                label: 'Claim Request Date',
                                controller: TextEditingController(text: claimRequestDate), // Initialize with current date
                                enabled: false, // Disable editing for this field
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 30),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Upload Damaged Product Image',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(
                                        context: context,
                                        portionHeightValue: 20.0),
                                  ),
                                  Row(
                                    children: [
                                      CommonButton(
                                        btnText: 'Choose Files',
                                        buttonColor: BaseColorTheme.textfieldShadowColor,
                                        buttonHeight: 25,
                                        buttonWidth: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 120),
                                        buttonBorderRaduis: 0,
                                        buttonTextColor: BaseColorTheme.blackColor,
                                        buttonFontWeight: BaseFontWeights.regular,
                                        buttonFontSize: 12,
                                        onPressed: _pickImages,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        selectedImages.isNotEmpty ? '${selectedImages.length} files selected' : 'No file chosen',
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(
                                        context: context, portionHeightValue: 10),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 10),
                              ),
                              const Text(
                                '* Minimum 3 and maximum 5 images\n'
                                '* Upload clear images in order to avail warranty\n'
                                '* Image should be similar to the sample image shown above',
                                style: TextStyle(
                                    color: BaseColorTheme.primaryGreenColor,
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              if (claimDetails?.sampleImages.isNotEmpty ?? false) ...[
                                const Text(
                                  'Sample Images',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 120, // Set height for the image gallery
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: claimDetails!.sampleImages.length,
                                    itemBuilder: (context, index) {
                                      final sampleImg = claimDetails!.sampleImages[index].sampleImg;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            sampleImg,
                                            width: 100, // Set width for each image
                                            height: 100, // Set height for each image
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.broken_image, color: Colors.grey),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20), // Add spacing before the next section
                              ],
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked, // Bind the state variable
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked =
                                            value ?? false; // Update the state
                                      });
                                      if(isChecked){
                                        CommonLoaders.disclaimerSnackBar(title: disclaimerMessage!,
                                            onConfirm: (){
                                         setState(() {
                                           disclaimerStatus = 1;
                                           isChecked =true;
                                         });
                                         print('Disclaimer confirmed. Status: $disclaimerStatus');
                                        });
                                      }else{
                                        setState(() {
                                          disclaimerStatus = 0;
                                        });
                                        print('Disclaimer not confirmed. Status: $disclaimerStatus');
                                      }
                                    },
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'I agree to the terms and conditions',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 10),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonButton(
                                    btnText: 'Back',
                                    buttonColor: BaseColorTheme.buttonBgColor,
                                    buttonHeight: 25,
                                    buttonWidth: 80,
                                    buttonBorderRaduis: 15,
                                    buttonTextColor:
                                        BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.medium,
                                    buttonFontSize: 12,
                                    onPressed: () {
                                      Get.to(ManageClaimScreen());
                                    },
                                  ),
                                  CommonButton(
                                    btnText: 'Register Claim',
                                    buttonColor: BaseColorTheme
                                        .feedbackTableHeadingBgColor,
                                    buttonHeight: 25,
                                    buttonWidth: 133,
                                    buttonBorderRaduis: 0,
                                    buttonTextColor:
                                        BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.medium,
                                    buttonFontSize: 12,
                                    onPressed: () {
                                      _submitClaim();
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color fillColor;
  final String? hinttext;
  final bool? enabled;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.fillColor = BaseColorTheme.textFormFillColor,
    this.hinttext,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            fillColor: fillColor,
            filled: true,
            hintText: hinttext,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: BaseFontWeights.regular,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? hinttext;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.onChanged,
    this.hinttext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: BaseFontWeights.regular,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
