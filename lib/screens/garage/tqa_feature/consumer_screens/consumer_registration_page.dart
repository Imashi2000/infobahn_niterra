import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/common/widgets/sign_up_dropdown.dart';
import 'package:niterra/common/widgets/sign_up_text.dart';
import 'package:niterra/models/garage_models/SaveConsumer_response_model.dart';
import 'package:niterra/models/garage_models/saveConsumer_request_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/models/landing_models/city_model.dart';
import 'package:niterra/models/landing_models/country.dart';
import 'package:niterra/screens/garage/tqa_feature/consumer_screens/consumer_list_table.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/consumer_services.dart';
import 'package:niterra/services/landing_services/signup_services.dart';
import 'package:niterra/utils/size.dart';

class ConsumerRegistrationPage extends StatefulWidget {
  const ConsumerRegistrationPage({super.key});

  @override
  State<ConsumerRegistrationPage> createState() =>
      _ConsumerRegistrationPageState();
}

class _ConsumerRegistrationPageState extends State<ConsumerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _consumerNameController = TextEditingController();
  final TextEditingController _consumerSurnameController =
      TextEditingController();
  final TextEditingController _consumerAddressController =
      TextEditingController();
  final TextEditingController _consumerPhoneController =
      TextEditingController();
  final TextEditingController _consumerEmailController =
      TextEditingController();

  ConsumerApiService consumerApiService = ConsumerApiService();
  ApiService apiService = ApiService();
  String? selectedCountry;
  List<Country> countries = [];
  List<City> cities = [];
  String? selectedCity;
  String? selectedPhoneCode;
  bool isLoading = true;
  String? loggedUserid;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure `_fetchCountries` is called only once
    if (countries.isEmpty) {
      _fetchCountries();
    }
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedUserid = userDetails['userId'];
      });

      print("Logged User ID: $loggedUserid");
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _saveConsumer() async {
    // print('Save Consumer button clicked');

    // Validate the form
    if (_formKey.currentState!.validate()) {
      // print('Save Consumer triggered');

      // Check for null or empty dropdown values
      if (selectedCountry == null) {
        //print('Required dropdowns are not selected');
        CommonLoaders.errorSnackBar(
            title: 'Failed Save Consumer',
            message: 'Please fill all required fields.',
            duration: 4);
        return;
      }

      // Combine phone code and number (without '+')
      String fullPhoneNumber =
          '${selectedPhoneCode?.replaceFirst('+', '')}${_consumerPhoneController.text.trim()}';

      // Create user model
      final SaveConsumerRequest consumer = SaveConsumerRequest(
        action: 'saveConsumer',
        addedBy: loggedUserid ?? "",
        name: _consumerNameController.text.trim(),
        surname: _consumerSurnameController.text.trim(),
        country: selectedCountry ?? '',
        city: selectedCity ?? '',
        address: _consumerAddressController.text.trim(),
        contact: fullPhoneNumber,
        email: _consumerEmailController.text.trim(),
      );

      try {
        print('Making API request with: ${consumer.toJson()}');
        final SaveConsumerResponse response =
            await consumerApiService.saveConsumer(consumer);

        if (response.status == 'success') {
          print('Save Successful: ${response.message}');
          CommonLoaders.successSnackBar(
              title: 'Success', message: response.message, duration: 4);
          Get.to(ConsumerRequestsScreen());
          _formKey.currentState!.reset();
          // Reset the form and selections
          setState(() {
            _consumerNameController.clear();
            _consumerSurnameController.clear();
            _consumerAddressController.clear();
            _consumerPhoneController.clear();
            _consumerEmailController.clear();
            selectedCountry = null;
            selectedCity = null;
            selectedPhoneCode = null;
          });
        } else {
          print('Save Failed: ${response.message}');
          CommonLoaders.errorSnackBar(
              title: 'Failed to save consumer',
              message: response.message,
              duration: 4);
        }
      } catch (e) {
        print('Error saving consumer: $e');
        CommonLoaders.errorSnackBar(
            title: 'Error saving consumer: $e', duration: 4);
      }
    } else {
      print('Form validation failed');
    }
  }

  _fetchCountries() async {
    try {
      List<Country> fetchedCountries = await apiService.fetchCountries();
      setState(() {
        countries = fetchedCountries; // Set fetched countries
        if (countries.isNotEmpty) {
          selectedPhoneCode =
              '+${countries[0].phonecode}'; // Set initial phone code
        }
        isLoading = false; // Stop the loading spinner
      });
    } catch (e) {
      // Handle any errors
      setState(() {
        isLoading = false; // Stop the loading spinner
      });
      print("Error fetching countries: $e");
    }
  }

  Future<void> _fetchCities(String countryId) async {
    if (selectedCountry == countryId && cities.isNotEmpty) {
      print('Cities already fetched for this country, skipping API call.');
      return;
    }
    try {
      List<City> fetchedCities = await apiService.fetchCities(countryId);
      setState(() {
        cities = fetchedCities; // Update the list of cities
        selectedCity = null; // Reset the selected city
      });
      print(
          'Fetched Cities: ${cities.map((c) => c.cityName).toList()}'); // Debugging
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Selected City: $selectedCity');
    print('City Items: ${cities.map((c) => c.cityName).toList()}');

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
                  width: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.cover,
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
                            color: BaseColorTheme.headingTextColor,
                            fontSize: 22.0,
                            fontWeight: BaseFontWeights.semiBold),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 32.0),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 27.0),
                      ),
                      const Text(
                        'ADD CONSUMER',
                        style: TextStyle(
                            color: BaseColorTheme.subHeadingTextColor,
                            fontSize: 20.0,
                            fontWeight: BaseFontWeights.semiBold),
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
                                color: Color.fromRGBO(218, 218, 218, 0.5),
                                offset: Offset(0, 4),
                                blurRadius: 4)
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20.0),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonButton(
                                    buttonColor: BaseColorTheme.buttonBgColor,
                                    btnText: 'List All',
                                    buttonBorderRaduis: 10.0,
                                    buttonFontSize: 12.0,
                                    buttonFontWeight: BaseFontWeights.medium,
                                    buttonHeight: 25.0,
                                    buttonTextColor:
                                        BaseColorTheme.whiteTextColor,
                                    buttonWidth: 90.0,
                                    onPressed: () {
                                      Get.to(ConsumerRequestsScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 15),
                              ),
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 20.0),
                                      ),
                                      TextFieldFormWithBorder(
                                        label: 'Consumer Name',
                                        hint: 'Enter Name',
                                        value: _consumerNameController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _consumerNameController.text =
                                                value;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      // Surname
                                      TextFieldFormWithBorder(
                                        label: 'Consumer Surname',
                                        hint: 'Enter Surname',
                                        value: _consumerSurnameController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _consumerSurnameController.text =
                                                value;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      DropdownFieldBoxWithBorder<String>(
                                        value: selectedCountry,
                                        label: 'Country',
                                        hint: 'Select Country',
                                        items: countries.map((country) {
                                          return DropdownMenuItem<String>(
                                            value: country.countryId.toString(),
                                            child: Text(country.country),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCountry = newValue!;
                                            // Update phone code dynamically
                                            final selectedCountryData =
                                                countries.firstWhere(
                                              (c) =>
                                                  c.countryId.toString() ==
                                                  newValue,
                                            );
                                            selectedPhoneCode =
                                                '+${selectedCountryData.phonecode}';
                                            cities =
                                                []; // Reset cities when country changes
                                            selectedCity = null;
                                          });
                                          // Fetch cities for the selected country
                                          _fetchCities(newValue!);
                                        },
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      DropdownFieldBoxWithBorder<String>(
                                        value: selectedCity,
                                        label: 'City',
                                        hint: 'Select City',
                                        items: cities.isNotEmpty
                                            ? cities.map((city) {
                                                return DropdownMenuItem<String>(
                                                  value: city.cityId.toString(),
                                                  child: Text(city.cityName),
                                                );
                                              }).toList()
                                            : [], // Handle empty items
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCity =
                                                newValue; // Update the selected city
                                            print(
                                                'City Selected: $selectedCity');
                                          });
                                        },
                                      ),
                                      // Address
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      // Phone
                                      const Text(
                                        'Phone',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: BaseColorTheme.greyTextColor,
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight:
                                                BaseFontWeights.semiBold,
                                            height: 1.375),
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 8.0),
                                      ),
                                      _buildPhoneField(context),
                                      // Email
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      TextFieldFormWithBorder(
                                        label: 'Email',
                                        hint: 'Enter email address',
                                        value: _consumerEmailController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _consumerEmailController.text =
                                                value;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          final emailRegex =
                                              RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                          if (!emailRegex.hasMatch(value!)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),

                                      const Text(
                                        'Address',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: BaseColorTheme.greyTextColor,
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            letterSpacing: 0,
                                            fontWeight:
                                                BaseFontWeights.semiBold,
                                            height: 1.375),
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 4.0),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: BaseColorTheme.borderColor,
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white,
                                        ),
                                        child: TextField(
                                          controller:
                                              _consumerAddressController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines:
                                              null, // Unlimited lines, scrollable as needed
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your address',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.all(12.0),
                                            hintStyle: TextStyle(
                                              color: BaseColorTheme
                                                  .unselectedIconColor,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            // Handle dynamic changes to the input
                                            setState(() {
                                              _consumerAddressController.text =
                                                  value;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 10.0),
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 20.0),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CommonButton(
                                            btnText: 'Submit',
                                            buttonBorderRaduis: 15,
                                            buttonColor: BaseColorTheme
                                                .primaryGreenColor,
                                            buttonFontSize: 12,
                                            buttonFontWeight:
                                                BaseFontWeights.semiBold,
                                            buttonHeight: 25,
                                            buttonTextColor:
                                                BaseColorTheme.whiteTextColor,
                                            buttonWidth: 100,
                                            onPressed: _saveConsumer,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(
                                            context: context,
                                            portionHeightValue: 30.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 30.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildPhoneField(BuildContext context) {
    return Container(
      height: ScreenUtils.getResponsiveHeight(
        context: context,
        portionHeightValue: 48.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: BaseColorTheme.borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedPhoneCode,
            hint: const Text(
              'Phone Code',
              style: TextStyle(
                color: BaseColorTheme.unselectedIconColor,
                fontSize: 12.0,
                fontWeight: BaseFontWeights.regular,
              ),
            ),
            items: countries.map((country) {
              return DropdownMenuItem<String>(
                value: '+${country.phonecode}',
                child: Text(
                  '+${country.phonecode}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedPhoneCode = newValue;
              });
            },
            underline: const SizedBox(), // Remove underline
            icon: const Icon(
              Icons.arrow_drop_down_sharp,
              color: BaseColorTheme.iconGrayColor,
            ),
          ),
          const VerticalDivider(
            color: BaseColorTheme.lineColor,
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Expanded(
            child: TextFormField(
              controller: _consumerPhoneController,
              decoration: const InputDecoration(
                hintText: '1234 56 789',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                hintStyle: TextStyle(
                  color: BaseColorTheme.unselectedIconColor,
                  fontSize: 12.0,
                  fontWeight: BaseFontWeights.regular,
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'must contain only digits';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
