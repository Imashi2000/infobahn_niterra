import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getCampaign_model.dart';
import 'package:niterra/models/garage_models/saveEnrollCampaignRequest_model.dart';
import 'package:niterra/models/garage_models/saveEnrollCampaignResponse_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/manage_campaign_screens/campaign_list_page.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/claim_details.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/campaign_services.dart';
import 'package:niterra/utils/size.dart';

class CampaignEnrollPage extends StatefulWidget {
  final Campaign campaignDetails;

  CampaignEnrollPage({required this.campaignDetails});

  @override
  _CampaignEnrollPageState createState() => _CampaignEnrollPageState();
}

class _CampaignEnrollPageState extends State<CampaignEnrollPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CampaignServices _campaignServices = CampaignServices();
  final TextEditingController _remarkController = TextEditingController();

  Campaign? campaignDetails;
  bool isLoading = true;
  int? loggedUserid;
  String? uploadedFile;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    campaignDetails = widget.campaignDetails;
  }

  Future<void> _initializeUserData() async {
    try {
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails");
      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
      });
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }
  Future<void> _pickFile() async {
    try {
      // Use FilePicker to select a file
      final result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Access the file path
        final filePath = result.files.single.path;

        setState(() {
          uploadedFile = filePath; // Store the selected file path
        });

        print('File selected: $filePath'); // Log the selected file path
      } else {
        // User canceled the picker
        print('No file selected.');
      }
    } catch (e) {
      print('Error selecting file: $e'); // Log any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select file: $e')),
      );
    }
  }
  Future<void> _enrollInCampaign() async {
    if (_formKey.currentState?.validate() != true || loggedUserid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }
    final EnrollCampaignRequest request = EnrollCampaignRequest(
      action: "enrollCampaign",
      campaignId: campaignDetails!.campaignId.toString(),
      userId: loggedUserid.toString(),
      remark: _remarkController.text,
    );
    try {
      setState(() {
        isLoading = true;
      });
      final SaveEnrollCampaignResponse response = await _campaignServices.enrollCampaign(request);
      setState(() {
        isLoading = false;
      });
      if (response.status == "success") {
        CommonLoaders.successSnackBar(title: 'Success',message: response.message, duration: 4);
        Get.to(CampaignListPage());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CommonLoaders.errorSnackBar(title: 'Error',message : 'Enrollment Failed, Try Again', duration: 4);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: GarageAppBar(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          showBackIcon: true,
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
                          fontWeight: BaseFontWeights.semiBold,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 30.23),
                      ),
                      const Text(
                        'ENROLL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: BaseColorTheme.subHeadingTextColor,
                          fontSize: 20.0,
                          fontWeight: BaseFontWeights.semiBold,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 280),
                        child: CommonButton(
                          btnText: 'List All',
                          buttonColor: BaseColorTheme.buttonBgColor,
                          buttonHeight: 22,
                          buttonWidth: double.infinity,
                          buttonBorderRaduis: 10,
                          buttonTextColor: BaseColorTheme.whiteTextColor,
                          buttonFontWeight: BaseFontWeights.medium,
                          buttonFontSize: 12,
                          onPressed: (){
                            Get.to(CampaignListPage());
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
                                CustomTextField(
                                  label: 'Campaign Name',
                                  hinttext: campaignDetails?.campaignName,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                CustomTextField(
                                  label: 'Start Date',
                                  hinttext: campaignDetails?.startDate,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                CustomTextField(
                                  label: 'End Date',
                                  hinttext: campaignDetails?.endDate,
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Upload Image',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtils.getResponsiveHeight(
                                          context: context, portionHeightValue: 20.0),
                                    ),
                                    Row(
                                      children: [
                                        CommonButton(
                                          btnText: 'Choose File',
                                          buttonColor: BaseColorTheme.textfieldShadowColor,
                                          buttonHeight: 25, buttonWidth: 117,
                                          buttonBorderRaduis: 0,
                                          buttonTextColor: BaseColorTheme.blackColor,
                                          buttonFontWeight: BaseFontWeights.regular,
                                          buttonFontSize: 12,
                                          onPressed: _pickFile,),
                                        SizedBox(width: 10),
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            uploadedFile != null ? uploadedFile!.split('/').last : 'No file chosen', // Display selected file name
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 0.7,
                                      color: BaseColorTheme.unselectedIconColor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 20.0),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Remark',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtils.getResponsiveHeight(
                                          context: context, portionHeightValue: 10.0),
                                    ),
                                    TextField(
                                      controller: _remarkController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: BaseColorTheme.selectedIconColor,
                                            width: 0.5
                                          )
                                        ), // Default border
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: BaseColorTheme.textFormFillColor, // Set the border color to green
                                            width: 2.0, // Optional: Set the border width
                                          ),
                                        ),
                                        focusColor: BaseColorTheme.selectedIconColor,
                                        hintText: 'Enter your remark',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: BaseFontWeights.regular
                                        )
                                      ),
                                      cursorColor: BaseColorTheme.selectedIconColor,
                                      maxLines: null, // Allows the text field to expand vertically as needed
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 30.0),
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
                                      buttonTextColor:  BaseColorTheme.whiteTextColor,
                                      buttonFontWeight: BaseFontWeights.regular,
                                      buttonFontSize: 12,
                                      onPressed: () {
                                        Get.to(CampaignListPage());
                                      },
                                    ),
                                    CommonButton(
                                      btnText: 'Enroll',
                                      buttonColor: BaseColorTheme.primaryGreenColor,
                                      buttonHeight: 25,
                                      buttonWidth: 100,
                                      buttonBorderRaduis: 15,
                                      buttonTextColor:  BaseColorTheme.whiteTextColor,
                                      buttonFontWeight: BaseFontWeights.regular,
                                      buttonFontSize: 12,
                                      onPressed:_enrollInCampaign
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: ScreenUtils.getResponsiveHeight(
                                      context: context, portionHeightValue: 10.0),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}
