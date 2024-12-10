import 'package:flutter/material.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/auth_section.dart';
import 'package:niterra/common/widgets/sign_up_button.dart';
import 'package:niterra/screens/auth/sign_in_page.dart';
import 'package:niterra/services/landing_services/signup_services.dart';
import 'package:niterra/utils/size.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await ApiService().resetPassword(_inputController.text.trim());

        if (response.status == "success") {
         CommonLoaders.successSnackBar(title: 'Success',message: response.message, duration: 4);
          // Optionally navigate back to login screen
          Navigator.pop(context);
        } else {
          CommonLoaders.errorSnackBar(title: 'Error',message: response.message, duration: 4);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset failed: $e')),
        );
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: BaseColorTheme.blackColor),
          title: Text(
            'Forgot Password',
            style: TextStyle(
              color: BaseColorTheme.primaryGreenColor,
              fontWeight: BaseFontWeights.semiBold,
              fontSize: 18,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your registered email or phone number to reset your password.',
                  style: TextStyle(
                    color: BaseColorTheme.greyTextColor,
                    fontSize: 14,
                    fontWeight: BaseFontWeights.regular,
                  ),
                ),
                SizedBox(height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0)),
                TextFormField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    labelText: 'Email / Phone',
                    hintText: 'Enter your email or phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or phone';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30.0)),
                SignUpButton(
                  btnText: isLoading ? 'Processing...' : 'RESET PASSWORD',
                  btnColor: BaseColorTheme.primaryRedColor,
                  sectionFirstText: '',
                  sectionSecondText: '',
                  sectionSecondColor: BaseColorTheme.primaryGreenColor,
                  onPressed: _resetPassword,
                  navigateToPage:SignInPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
