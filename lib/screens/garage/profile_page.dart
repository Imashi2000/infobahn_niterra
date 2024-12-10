import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/common/widgets/sign_up_text.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/models/landing_models/get_user_response_model.dart';
import 'package:niterra/models/landing_models/updatePasswordRequest_model.dart';
import 'package:niterra/models/landing_models/updateProfileRequest_model.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/landing_services/signup_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GetUserResponse? userResponse;
  bool isLoading = true;
  int? loggedUserid;
  int? userTypeId;
  File? _profileImage; // Store the picked image
  final ImagePicker _picker = ImagePicker();

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final userDetails = await UserPreferences.getUserDetails();
      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
        userTypeId = int.tryParse(userDetails['userTypeId'] ?? '0');
      });

      if (loggedUserid != null && userTypeId != null) {
        await _fetchUserDetails();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchUserDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedUser = await _apiService.getUser(loggedUserid!);
      setState(() {
        userResponse = fetchedUser;
        _updateControllers();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    }
  }
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _updateControllers() {
    if (userResponse != null) {
      nameController.text = userResponse?.name ?? '';
      surnameController.text = userResponse?.surname ?? '';
      phoneController.text = userResponse?.phone ?? '';
      emailController.text = userResponse?.email ?? '';
      companyNameController.text = userResponse?.companyName ?? '';
      designationController.text = userResponse?.designation.designation ?? '';
      countryController.text = userResponse?.country ?? '';
      cityController.text = userResponse?.city ?? '';
    }
  }

  void _updateProfile() async {

      final request = UpdateProfileRequest(
        action: "updateProfile",
        userId: loggedUserid.toString(),
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        garageName: companyNameController.text.trim(),
        userType: userTypeId.toString(),
      );

      try {
        final response = await _apiService.updateProfile(request);

       CommonLoaders.successSnackBar(title: 'Success', message: response.message,duration: 4);
        await _fetchUserDetails();
      } catch (e) {
        CommonLoaders.errorSnackBar(title: 'Error',message: 'Failed to update Profile', duration: 4);
      }
    }


  void _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdatePasswordRequest(
        action: "updatePassword",
        userId: loggedUserid.toString(),
        password: passwordController.text.trim(),
      );

      try {
        final response = await _apiService.updatePassword(request);

        CommonLoaders.successSnackBar(title: 'Success',message: response.message, duration: 4);
        await _fetchUserDetails();

        // Clear the password fields
        passwordController.clear();
        confirmPasswordController.clear();
      } catch (e) {
       CommonLoaders.errorSnackBar(title: 'Error', message: 'Failed to update password',duration: 4);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GarageAppBar(
        isDetailsPage: true,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const NavigationDrawerScreen(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtils.getResponsiveWidth(
                context: context, portionWidthValue: 12.0),
            horizontal: ScreenUtils.getResponsiveHeight(
                context: context, portionHeightValue: 12.0)),
        child: BottomBar(
          onChanged: (BottomBarEnum type) {
            setState(() {
              Get.to(HomePage());
            });
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                      'Profile',
                      style: TextStyle(
                          color: BaseColorTheme.primaryGreenColor,
                          fontSize: 20.0,
                          fontWeight: BaseFontWeights.semiBold),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 20.0),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 4.0),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!) as ImageProvider
                                  : const AssetImage('assets/images/user.png'),
                            ),
                            const Icon(
                              Icons.camera_alt,
                              color: Colors.green,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(
                          context: context, portionHeightValue: 20.0),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFieldWithBorder(
                              'First Name', nameController, TextInputType.text,true),
                          _buildTextFieldWithBorder(
                              'Surname', surnameController, TextInputType.text,true),
                          Row(
                            children: [
                              Expanded(child:  _buildTextFieldWithBorder(
                                  'Country', countryController, TextInputType.text,false),),
                              const SizedBox(width: 10),
                              Expanded(child: _buildTextFieldWithBorder('City', cityController,
                                  TextInputType.text,false),),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child:  _buildTextFieldWithBorder(
                                  'Phone', phoneController, TextInputType.phone,true),),
                              const SizedBox(width: 10),
                              Expanded(child: _buildTextFieldWithBorder('Email', emailController,
                                  TextInputType.emailAddress,true),),
                            ],
                          ),
                          if (userTypeId == 6)
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFieldWithBorder('Garage Name',
                                      companyNameController, TextInputType.text,true),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildTextFieldWithBorder('Designation',
                                      designationController, TextInputType.text,false),
                                ),
                              ],
                            ),
                          if (userTypeId == 7)
                            _buildTextFieldWithBorder(
                                'Company Name', companyNameController, TextInputType.text,true),

                          CommonButton(
                              btnText: 'Update',
                              buttonColor: BaseColorTheme.primaryGreenColor,
                              buttonHeight: 34,
                              buttonWidth: double.infinity,
                              buttonBorderRaduis: 15,
                              buttonTextColor: BaseColorTheme.whiteTextColor,
                              buttonFontWeight: BaseFontWeights.extraBold,
                              buttonFontSize: 16,
                            onPressed: _updateProfile,
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 27.0),
                          ),
                          const Text(
                            'Update Password',
                            style: TextStyle(
                                color: BaseColorTheme.primaryGreenColor,
                                fontSize: 20.0,
                                fontWeight: BaseFontWeights.semiBold),
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 20.0),
                          ),
                          TextFieldFormWithBorder(
                            label: "Password",
                            hint: "Enter your password",
                            value: "",
                            isPasswordField: true,
                            onChanged: (value) {
                              passwordController.text = value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) => value!.isEmpty ? "Password cannot be empty" : null,
                          ),

                          // Confirm Password
                          TextFieldFormWithBorder(
                            label: "Confirm Password",
                            hint: "Re-enter your password",
                            value: "",
                            isPasswordField: true,
                            isConfirmPasswordField: true,
                            passwordController: passwordController,
                            onChanged: (value) {
                              confirmPasswordController.text = value;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (value != passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          CommonButton(
                            btnText: 'Update',
                            buttonColor: BaseColorTheme.primaryGreenColor,
                            buttonHeight: 34,
                            buttonWidth: double.infinity,
                            buttonBorderRaduis: 15,
                            buttonTextColor: BaseColorTheme.whiteTextColor,
                            buttonFontWeight: BaseFontWeights.extraBold,
                            buttonFontSize: 16,
                            onPressed: _updatePassword,
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 27.0),
                          ),
                          const Text(
                            'Delete Account',
                            style: TextStyle(
                                color: BaseColorTheme.primaryGreenColor,
                                fontSize: 20.0,
                                fontWeight: BaseFontWeights.semiBold),
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 20.0),
                          ),
                          CommonButton(
                            btnText: 'Delete Account',
                            buttonColor: BaseColorTheme.buttonBgColor,
                            buttonHeight: 34,
                            buttonWidth: double.infinity,
                            buttonBorderRaduis: 15,
                            buttonTextColor: BaseColorTheme.whiteTextColor,
                            buttonFontWeight: BaseFontWeights.extraBold,
                            buttonFontSize: 16,
                            onPressed: () async {
                              const url = 'https://auctionsplatform.ae/delete-account';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              } else {
                                CommonLoaders.errorSnackBar(
                                  title: 'Error',
                                  message: 'Could not open the URL.',
                                  duration: 4,
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 65.0),
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

  Widget _buildTextFieldWithBorder(
      String label, TextEditingController controller, TextInputType type,bool? enabled) {
    return TextFieldFormWithBorder(
      enabled: enabled,
      label: label,
      value: controller.text,
      hint: 'Enter $label',
      onChanged: (value) {
        controller.text = value;
      },
      keyboardType: type,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companyNameController.dispose();
    designationController.dispose();
    cityController.dispose();
    countryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
