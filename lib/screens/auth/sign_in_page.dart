import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/common/widgets/sign_up_button.dart';
import 'package:niterra/common/widgets/sign_up_text.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/providers/sign_up_providers.dart';
import 'package:niterra/screens/auth/reset_password_page.dart';
import 'package:niterra/screens/auth/sign_up_page.dart';
import 'package:niterra/screens/garage/dashboard_page.dart';
import 'package:niterra/services/landing_services/signup_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  final bool fromAccountPage;
  const SignInPage({super.key, this.fromAccountPage = false});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    //_checkLoggedInStatus();
  }

  // Future<void> _checkLoggedInStatus() async {
  //   final userDetails = await UserPreferences.getUserDetails();
  //
  //   if (widget.fromAccountPage) {
  //     // If coming from Account page
  //     if (userDetails['userId'] != null) {
  //       Get.off(() => GarageDashboardScreen()); // Navigate to Dashboard
  //     }
  //   } else {
  //     // If user is logged in and not coming from Account page
  //     if (userDetails['userId'] != null) {
  //       Get.off(() => GarageDashboardScreen());
  //     }
  //   }
  // }
  Future<void> _loginUser() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Call the login API
        final response = await ApiService().userLogin(
          _emailOrPhoneController.text.trim(),
          _passwordController.text.trim(),
        );

        if (response.status == "success" && response.data != null) {
          final user = response.data!.first;

          // Save to SharedPreferences
          await UserPreferences.saveUserDetails(
            user.userId,
            user.countryId,
            user.userTypeId,
            user.cityId,
          );

          // Save to Provider
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUserDetails(user.userId, user.countryId, user.userTypeId,user.cityId);

          CommonLoaders.successSnackBar(title:'Success',message: response.message, duration: 4);
          Get.to(() => GarageDashboardScreen());

        } else {
          CommonLoaders.errorSnackBar(title:'Error, Try Again', message:response.message,duration: 4);
        }
      } catch (e) {
        CommonLoaders.errorSnackBar(title: 'Login failed: $e', duration: 4);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: LandingAppBar(
          showBackArrow: true,
          leadingImage: 'assets/images/tp.png',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.getResponsiveWidth(
                  context: context, portionWidthValue: AppSpace.bodyPadding),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 51.0),
                  ),
                  const Text(
                    'Take advantage of our exclusive deals!',
                    style: TextStyle(
                      color: BaseColorTheme.unselectedIconColor,
                      fontSize: 14.0,
                      fontWeight: BaseFontWeights.regular,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 20.0),
                  ),
                  const Text(
                    'Sign in',
                    style: TextStyle(
                        color: BaseColorTheme.primaryGreenColor,
                        fontSize: 24.0,
                        fontWeight: BaseFontWeights.semiBold),
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 38.0),
                  ),
                  TextFieldFormWithBorder(
                    label: 'Email / Phone',
                    hint: 'Valid Email / Phone with country code',
                    value: _emailOrPhoneController.text,
                    onChanged: (value) {
                      setState(() {
                        _emailOrPhoneController.text = value;
                      });
                    },
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email or phone number';
                      }
                      // Regex for validating email
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      // Regex for validating phone (simple check for digits)
                      final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                      if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
                        return 'Enter a valid email or phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 15.0),
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
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 9.0),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the Forgot Password page
                        Get.to(() => const ForgotPasswordPage());
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: BaseColorTheme.selectedIconColor,
                          fontSize: 15.0,
                          fontWeight: BaseFontWeights.light,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtils.getResponsiveHeight(
                        context: context, portionHeightValue: 23.0),
                  ),
                  SignUpButton(
                    btnText: isLoading ? 'Signing In...' : 'SIGN IN',
                    btnColor: BaseColorTheme.primaryRedColor,
                    sectionFirstText: 'Don’t have an account?',
                    sectionSecondText: 'Sign up',
                    navigateToPage: const SignUpPage(),
                    sectionSecondColor: BaseColorTheme.primaryGreenColor,
                    onPressed: _loginUser,
      
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

