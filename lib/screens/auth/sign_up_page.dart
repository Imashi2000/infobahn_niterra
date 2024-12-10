import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/common/widgets/sign_up_button.dart';
import 'package:niterra/common/widgets/sign_up_dropdown.dart';
import 'package:niterra/common/widgets/sign_up_text.dart';
import 'package:niterra/models/landing_models/city_model.dart';
import 'package:niterra/models/landing_models/country.dart';
import 'package:niterra/models/landing_models/designation_model.dart';
import 'package:niterra/models/landing_models/save_user_response_model.dart';
import 'package:niterra/models/landing_models/sign_up_model.dart';
import 'package:niterra/screens/auth/sign_in_page.dart';
import 'package:niterra/services/landing_services/signup_services.dart';
import 'package:niterra/utils/size.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _snameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _otherDesignationController = TextEditingController();

  String? selectedValue;
  ApiService apiService = ApiService();
  String? selectedCountry;
  List<Designation> designations = [];
  List<Country> countries = [];
  List<City> cities = [];
  String? selectedCity;
  String? selectedPhoneCode;
  bool isLoading = true;
  String? selectedDesignation;
  String? selectedPrefix;
  int? selectedUserTypeId;
  bool isRetailer = false;
  bool isOtherDesignation = false;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchDesignations(); 
  }

  void _toggleRetailer(bool value) {
    setState(() {
      isRetailer = value;
      if (isRetailer) {
        _companyNameController.clear();
        _designationController.clear();
      }
    });
  }

  Future<void> _saveUser() async {
    
    if (_formKey.currentState!.validate()) {

      if (selectedCountry == null || selectedUserTypeId == null) {
        CommonLoaders.errorSnackBar(title: 'Fill all the mandatory fields', duration: 4);
        return;
      }

      String fullPhoneNumber = '${selectedPhoneCode?.replaceFirst('+', '')}${_phoneController.text.trim()}';
      String? garageName = selectedUserTypeId == 6 ? _companyNameController.text.trim() : '';
      String? retailerName = selectedUserTypeId == 7 ? _companyNameController.text.trim() : '';
      String? designation = (selectedDesignation == "Other") ? _otherDesignationController.text.trim() : '';
      String? designationId = (selectedDesignation != null && selectedDesignation != "Other")
          ? designations.firstWhere((d) => d.designation == selectedDesignation).designationId.toString()
          : null;

      final SignUpModel user = SignUpModel(
        action: 'saveUser',
        prefix: selectedPrefix ?? 'Mr',
        fname: _fnameController.text.trim(),
        sname: _snameController.text.trim(),
        userType: selectedUserTypeId.toString(),
        garageName: garageName ?? '',
        retailerName: retailerName ?? '',
        designationId: designationId,
        designation: designation ?? '',
        countryReg: selectedCountry ?? '',
        cityReg: selectedCity ?? '',
        address: _addressController.text.trim(),
        phone: fullPhoneNumber,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      try {
        final SaveUserResponse response = await apiService.saveUser(user);

        if (response.status == 'success') {
          CommonLoaders.successSnackBar(title:'Success',message: response.message, duration: 4);
          Get.to(const SignInPage());
          _clearForm();
          _formKey.currentState!.reset();


        } else {
          CommonLoaders.errorSnackBar(title:'Error', message: response.message, duration: 4);
        }
      } catch (e) {
        CommonLoaders.errorSnackBar(title: 'Error saving user: $e', duration: 4);
      }
    } else {
      print('Form validation failed');
    }
  }

  void _clearForm() {

    _fnameController.clear();
    _snameController.clear();
    _companyNameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
    _designationController.clear();
    _otherDesignationController.clear();

    setState(() {
      selectedCountry = null;
      selectedCity = null;
      selectedDesignation = null;
      selectedUserTypeId = null;
      selectedPhoneCode = null;
      selectedPrefix = null;
      isRetailer = false;
      isOtherDesignation = false;
    });
  }




  _fetchCountries() async {
    try {
      // Fetch countries directly from the API
      List<Country> fetchedCountries = await apiService.fetchCountries();

      // Update the local state
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

  Future<void> _fetchDesignations() async {
    try {
      List<Designation> fetchedDesignations =
          await apiService.fetchDesignation();
      setState(() {
        designations = fetchedDesignations;
        designations.add(Designation(designationId: 0, designation: 'Other'));
      });
    } catch (e) {
      print("Error fetching designations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Selected City: $selectedCity');
    print('City Items: ${cities.map((c) => c.cityName).toList()}');

    print('Selected Designation: $selectedDesignation');
    print(
        'Designation Items: ${designations.map((d) => d.designation).toList()}');

    return SafeArea(
      child: Scaffold(
          appBar: LandingAppBar(
            showBackArrow: true,
            leadingImage: 'assets/images/tp.png',
          ),
          body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getResponsiveWidth(
                    context: context, portionWidthValue: AppSpace.bodyPadding),
              ),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 27.0),
                  ),
                  const Text(
                    'Join Trusted Program',
                    style: TextStyle(
                        color: BaseColorTheme.primaryGreenColor,
                        fontSize: 24.0,
                        fontWeight: BaseFontWeights.semiBold),
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 10.0),
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 20.0),
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Name
                          const Text(
                            'First Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: BaseFontWeights.bold,
                                height: 1.375),
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          _buildUserNameField(context),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 30.0),
                          ),
                          // Surname
                          TextFieldFormWithBorder(
                            label: 'Surname',
                            hint: 'Enter your surname',
                            value: _snameController.text,
                            onChanged: (value) {
                              setState(() {
                                _snameController.text = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          // User Type
                          DropdownFieldBoxWithBorder<int>(
                            label: 'User Type',
                            hint: 'Select User Type',
                            items: [
                              const DropdownMenuItem<int>(
                                value: 6, // Static value for "Garage"
                                child: Text('Garage'),
                              ),
                              const DropdownMenuItem<int>(
                                value: 7, // Static value for "Retailer"
                                child: Text('Retailer'),
                              ),
                            ],
                            value: selectedUserTypeId, // Binds the selected value
                            onChanged: (newValue) {
                              setState(() {
                                selectedUserTypeId = newValue;
                                _toggleRetailer(newValue == 7);
                              });
                            },
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          if (selectedUserTypeId == 6)
                            TextFieldFormWithBorder(
                              label: 'Garage Name',
                              hint: 'Enter your garage name',
                              value: _companyNameController.text,
                              onChanged: (value) {
                                setState(() {
                                  _companyNameController.text = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                            ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          if (selectedUserTypeId ==6)
                            DropdownFieldBoxWithBorder<String>(
                              label: 'Designation',
                              hint: 'Select Designation',
                              value: selectedDesignation,
                              items: designations
                                  .map((designation) => DropdownMenuItem<String>(
                                        value: designation.designation,
                                        child: Text(designation.designation),
                                      ))
                                  .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDesignation = newValue;
                                });
                              },
                            ),

                          if (selectedDesignation  == "Other")
                            TextFieldFormWithBorder(
                              label: 'Other Designation',
                              hint: 'Enter designation',
                              value: _otherDesignationController.text,
                              onChanged: (value) =>
                                  _otherDesignationController.text = value,
                            ),

                          if (isRetailer)
                            TextFieldFormWithBorder(
                              label: 'Company Name',
                              hint: 'Enter your company name',
                              value: _companyNameController.text,
                              onChanged: (value) {
                                setState(() {
                                  _companyNameController.text = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                            ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),

                          const Text(
                            'Address',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: BaseFontWeights.bold,
                                height: 1.375),
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 4.0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: BaseColorTheme.borderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _addressController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null, // Unlimited lines, scrollable as needed
                              decoration: const InputDecoration(
                                hintText: 'Enter your address',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12.0),
                                hintStyle: TextStyle(
                                  color: BaseColorTheme.unselectedIconColor,
                                  fontSize: 14.0,
                                ),
                              ),
                              onChanged: (value) {
                                // Handle dynamic changes to the input
                                setState(() {
                                  _addressController.text = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 30.0),
                          ),
                          // Country
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
                                final selectedCountryData = countries.firstWhere(
                                  (c) => c.countryId.toString() == newValue,
                                );
                                selectedPhoneCode =
                                    '+${selectedCountryData.phonecode}';
                                cities = []; // Reset cities when country changes
                                selectedCity = null;
                              });
                              // Fetch cities for the selected country
                              _fetchCities(newValue!);
                            },
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
                                print('City Selected: $selectedCity');
                              });
                            },
                          ),

                          // Address
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          // Phone
                          const Text(
                            'Phone',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: BaseFontWeights.bold,
                                height: 1.375),
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 8.0),
                          ),
                          _buildPhoneField(context),
                          //
                          // Email
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 30.0),
                          ),
                          TextFieldFormWithBorder(
                            label: 'Email',
                            hint: 'Enter your email address',
                            value: _emailController.text,
                            onChanged: (value) {
                              setState(() {
                                _emailController.text = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(value!)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          // Password
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          TextFieldFormWithBorder(
                            label: 'Password',
                            hint: 'Enter Password',
                            isPasswordField: true,
                            value: _passwordController.text,
                            onChanged: (value) {
                              setState(() {
                                _passwordController.text = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              final passwordRegex = RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
                              if (!passwordRegex.hasMatch(value!)) {
                                return 'Password must be 8 characters, include uppercase, number, and symbol';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          TextFieldFormWithBorder(
                            label: 'Confirm Password',
                            hint: 'Re-enter Password',
                            isPasswordField: true,
                            isConfirmPasswordField: true,
                            passwordController: _passwordController,
                            value: _confirmPasswordController.text,
                            onChanged: (value) {
                              setState(() {
                                _confirmPasswordController.text = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 20),
                          SignUpButton(
                            btnText: 'SIGN UP',
                            btnColor: BaseColorTheme.primaryRedColor,
                            sectionFirstText: 'Already have an account?',
                            sectionSecondText: 'Sign In',
                            navigateToPage: const SignInPage(),
                            sectionSecondColor: BaseColorTheme.primaryGreenColor,
                            onPressed: _saveUser,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )))),
    );
  }

  Container _buildUserNameField(BuildContext context) {
    return Container(
      height: ScreenUtils.getResponsiveHeight(
          context: context, portionHeightValue: 52.0),
      child: TextFormField(
        controller: _fnameController, // Link the controller
        decoration: InputDecoration(
          hintText: 'Full Name',
          contentPadding: EdgeInsets.zero,
          hintStyle: const TextStyle(
              color: BaseColorTheme.unselectedIconColor,
              fontSize: 12.0,
              fontWeight: BaseFontWeights.regular), // Hint text style
          filled: true, // Fill the background
          fillColor: Colors.white, // Background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0), // Circular border
            borderSide: const BorderSide(
              color: BaseColorTheme.borderColor, // Border color
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0), // Circular border
            borderSide: const BorderSide(
              color: BaseColorTheme.borderColor, // Border color when enabled
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0), // Circular border
            borderSide: const BorderSide(
              color: BaseColorTheme.borderColor, // Border color when focused
              width: 2.0,
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: selectedPrefix ?? 'Mr', // Use selectedPrefix
                  items: ['Mr', 'Mrs', 'Miss']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: const TextStyle(
                                  fontSize: 12.0,
                                  color: BaseColorTheme.unselectedIconColor),
                            ),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPrefix = newValue; // Save selected prefix
                    });
                  },
                  underline: const SizedBox(), // Remove underline
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: BaseColorTheme.iconGrayColor,
                  ), // Dropdown icon
                ),
                // Vertical divider between dropdown and name field
                const VerticalDivider(
                  color: BaseColorTheme.lineColor,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                ),
              ],
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
          }
          return null;
        },
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
                selectedPhoneCode = newValue!;
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
              controller: _phoneController,
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
