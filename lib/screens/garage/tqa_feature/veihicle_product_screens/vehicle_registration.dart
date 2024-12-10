import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
import 'package:niterra/models/garage_models/getConsumerDropdown_model.dart';
import 'package:niterra/models/garage_models/getVehicleModel.dart';
import 'package:niterra/models/garage_models/getVehicle_model.dart';
import 'package:niterra/models/garage_models/getvehicle_manufacturer_model.dart';
import 'package:niterra/models/garage_models/saveVehicleRequest_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/product_registration.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/vehicle_list_page.dart';
import 'package:niterra/services/garage_services/vehicle_registration_services.dart';
import 'package:niterra/utils/size.dart';

class VehicleRegistrationForm extends StatefulWidget {
  @override
  _VehicleRegistrationFormState createState() =>
      _VehicleRegistrationFormState();
}

class _VehicleRegistrationFormState extends State<VehicleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Form field values
  List<ConsumerDropdownModel> _consumers = [];
  String? selectedConsumer;
  List<VehicleModel> vehicleTypes = [];
  VehicleModel? selectedVehicleType;
  List<VehicleManufacturerModel> manufacturers = [];
  VehicleManufacturerModel? selectedManufacturer;
  List<ModelTypes> models = [];
  String? selectedModel;

  String? modelYear;
  String? plateNumber;
  String? engineCode;
  String? odometer;
  String? mileage;
  String? othermodel;
  String? vinNumber;
  String? loggedUserid;
  int? loggedCountryId ;
  File? _selectedVinImage;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedCountryId != null) {
      _fetchConsumersbyCountry();
    }
    _fetchVehicleTypes();
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedUserid = userDetails['userId']; // Correct key is 'userId'
        loggedCountryId = int.tryParse(userDetails['countryId'] ?? '0'); // Correct key is 'countryId'
      });

      print("Logged User ID: $loggedUserid, Country ID: $loggedCountryId");

      // Fetch consumers if the country ID is valid
      if (loggedCountryId != null && loggedCountryId != 0) {
        await _fetchConsumersbyCountry();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchConsumersbyCountry() async {
    print("Fetching consumers for country ID: $loggedCountryId");
    try {
      if (loggedCountryId == null) {
        throw Exception("Logged country ID is null");
      }
      final consumers = await VehicleRegistrationServices().fetchConsumersByCountry(loggedCountryId!);
      setState(() {
        _consumers = consumers;
      });
    } catch (e) {
      print("Error fetching consumers: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch consumers: $e')),
      );
    }
  }

  Future<void> _fetchVehicleTypes() async {
    try {
      final vehicles = await VehicleRegistrationServices().fetchVehicleTypes();
      setState(() {
        vehicleTypes = vehicles;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch vehicles: $e')),
      );
    }
  }

  Future<void> _fetchManufacturers(int vehtypeId) async {
    try {
      final fetchedManufacturers = await VehicleRegistrationServices().fetchManufacturersByType(vehtypeId);
      setState(() {
        manufacturers = fetchedManufacturers;// Reset manufacturer selection
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch manufacturers: $e')),
      );
    }
  }

  Future<void> _fetchModels(int vehmakeId) async {
    try {
      print("Fetching models for Manufacturer ID: $vehmakeId"); // Log the input ID
      final fetchedModels = await VehicleRegistrationServices().fetchModelsByManufacturer(vehmakeId);
      print("Fetched Models: $fetchedModels"); // Log fetched data
      setState(() {
        models = fetchedModels;
        selectedModel = null; // Reset model selection
      });
    } catch (e) {
      print("Error fetching models: $e"); // Log errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch models: $e')),
      );
    }
  }

  Future<void> pickVinImage() async {
    final file = await pickFile();
    if (file != null) {
      setState(() {
        _selectedVinImage = file;
      });
    }
  }

  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                      'VEHICLE REGISTRATION',
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
                          buttonHeight: 25,
                          buttonWidth: 90,
                          buttonBorderRaduis: 10,
                          buttonTextColor: BaseColorTheme.whiteTextColor,
                          buttonFontWeight: BaseFontWeights.medium,
                          buttonFontSize: 12,
                      onPressed: (){
                            Get.to(VehicleListPage());
                      },),
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
                              DropdownFieldBox(
                                label: 'Consumer',
                                hint: 'Select Consumer',
                                items: _consumers.map((consumer) => consumer.displayName).toList(),
                                value: selectedConsumer,
                                onChanged: (value) {
                                  setState(() {
                                    selectedConsumer = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              DropdownFieldBox(
                                label: 'Vehicle Type',
                                hint: 'Select Vehicle Type',
                                items: vehicleTypes.map((vehicleType) => vehicleType.vehtype).toList(),
                                value: selectedVehicleType?.vehtype,
                                onChanged: (value) {
                                  final selectedType = vehicleTypes.firstWhere(
                                        (type) => type.vehtype == value,
                                  );
                                  setState(() {
                                    selectedVehicleType = selectedType;
                                    selectedManufacturer = null;
                                    manufacturers.clear();
                                    selectedModel = null;
                                    models.clear();
                                  });
                                  _fetchManufacturers(selectedType.vehtype_id); // Fetch manufacturers
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              DropdownFieldBox(
                                label: 'Manufacturer',
                                hint: 'Select Manufacturer',
                                items: manufacturers.map((manufacturer) => manufacturer.vehmake).toList(),
                                value: selectedManufacturer?.vehmake,
                                onChanged: (value) {
                                  final selectedManufacture = manufacturers.firstWhere(
                                        (manufacturer) => manufacturer.vehmake == value, // Match by name
                                  );
                                  setState(() {
                                    selectedManufacturer = selectedManufacture;
                                    selectedModel = null;
                                    models.clear();
                                  });
                                  print("Selected Manufacturer ID: ${selectedManufacture.vehmakeId}"); // Log ID
                                  _fetchModels(selectedManufacture.vehmakeId); // Pass correct ID
                                },
                              ),


                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              DropdownFieldBox(
                                label: 'Model',
                                hint: 'Select Model',
                                items: models.map((model) => model.vehmodel).toList(),
                                value: selectedModel,
                                onChanged: (value) {
                                  setState(() {
                                    selectedModel = value;
                                  });
                                },
                              ),
                              if(selectedModel=='Other Model')
                                TextFieldForm(
                                  label: 'Other Vehicle Model *',
                                  hint: 'Enter Vehicle Model',
                                  value: othermodel,
                                  onChanged: (value) {
                                    othermodel = value;
                                  },
                                ),

                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              TextFieldForm(
                                label: 'Model Year',
                                hint: 'Enter Model Year',
                                value: modelYear,
                                onChanged: (value) {
                                  modelYear = value;
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              TextFieldForm(
                                label: 'Plate Number',
                                hint: 'Enter Vehicle Plate No',
                                value: plateNumber,
                                onChanged: (value) {
                                  plateNumber = value;
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              TextFieldForm(
                                label: 'Engine Code',
                                hint: 'Enter Engine Code',
                                value: engineCode,
                                onChanged: (value) {
                                  engineCode = value;
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
                                label: 'Annual Mileage',
                                hint: 'Enter Annual Mileage',
                                value: mileage,
                                onChanged: (value) {
                                  mileage = value;
                                },
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              _buildFilePickerRow(
                                label: 'VIN Image',
                                fileName: _selectedVinImage?.path,
                                onPick: pickVinImage,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              TextFieldForm(
                                label: 'VIN No / Frame No',
                                hint: 'Enter VIN Number',
                                value: vinNumber,
                                onChanged: (value) {
                                  vinNumber = value;
                                },
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CommonButton(
                                    btnText: 'Next',
                                    buttonColor: BaseColorTheme.dropdownBoderColor,
                                    buttonHeight: 25,
                                    buttonWidth: 80,
                                    buttonBorderRaduis: 0,
                                    buttonTextColor:  BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.regular,
                                    buttonFontSize: 12,
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      _formKey.currentState?.save();

                                      try {
                                        // Find the selected consumer's ID
                                        final selectedConsumerModel = _consumers.firstWhere(
                                              (consumer) => consumer.displayName == selectedConsumer,
                                        );

                                        // Parse odometer and mileage values
                                        final int parsedOdometer = int.tryParse(odometer?.toString() ?? "0") ?? 0;
                                        final int parsedMileage = int.tryParse(mileage?.toString() ?? "0") ?? 0;

                                        // Validate odometer and mileage values
                                        if (parsedOdometer <= 0 || parsedMileage <= 0) {
                                          throw Exception('Odometer or Mileage must be greater than 0');
                                        }

                                        final String? vehMake = (selectedModel == 'Other Model')
                                            ? selectedManufacturer?.vehmakeId.toString()
                                            : null;

                                        String username = 'NiterraMobile';
                                        String password = 'ha@jhashHhg*&63';
                                        String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

                                        var request = http.MultipartRequest(
                                          'POST',
                                          Uri.parse("https://trustedprog.com/api/saveVehicle.php"),
                                        );

                                        // Add Authorization Header
                                        request.headers['Authorization'] = basicAuth;

                                        request.fields.addAll({
                                          'action': 'saveVehicle',
                                          'userid': loggedUserid ?? "",
                                          'consumerid':selectedConsumerModel.consumerid.toString(),
                                          'vehmake':vehMake ?? "",
                                          'vehmodelid':  models
                                              .firstWhere((model) => model.vehmodel == selectedModel).vehmodel_id.toString(),
                                          'othermodel':(selectedModel == 'Other Model') ? othermodel ?? "" : "",
                                          'modelyr': modelYear ?? "",
                                          'plateno': plateNumber ?? "",
                                          'enginecode':engineCode ?? "",
                                          'odometer':odometer ?? '',
                                          'mileage':mileage ?? '',
                                          'vinno': vinNumber ?? "",
                                        });
                                        // Add Files
                                        if (_selectedVinImage != null) {
                                          request.files.add(await http.MultipartFile.fromPath(
                                            'vinimg',
                                            _selectedVinImage!.path,
                                            contentType: MediaType('image', _getFileExtension(_selectedVinImage!)),
                                          ));
                                        }

                                        print('Request Fields: ${request.fields}');
                                        print('Request Headers: ${request.headers}');
                                        print('VIN Image Path: ${_selectedVinImage?.path}');

                                        var response = await request.send();

                                        if (response.statusCode == 200) {
                                          final responseData = await response.stream.bytesToString();
                                          final jsonResponse = json.decode(responseData);

                                          if (jsonResponse['status'] == 'success') {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('vehicle saved successfully!')),
                                            );
                                            Get.to(VehicleListPage());
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
                                        print('Error saving vehicle: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 34.0),
                              ),
                            ],
                          ),
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
  String _getFileExtension(File file) {
    return file.path.split('.').last.toLowerCase();
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