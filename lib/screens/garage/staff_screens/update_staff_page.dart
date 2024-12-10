import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/dropdown_field.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/common/widgets/text_field.dart';
import 'package:niterra/models/garage_models/getStaffByGarageId_model.dart';
import 'package:niterra/models/garage_models/updateStaffRequest_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/models/landing_models/designation_model.dart';
import 'package:niterra/screens/garage/staff_screens/manage_staff_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/manage_staff_services.dart';
import 'package:niterra/services/landing_services/signup_services.dart';
import 'package:niterra/utils/size.dart';

class UpdateStaffPage extends StatefulWidget {
  final StaffByGarage staffDetails;

  const UpdateStaffPage({Key? key, required this.staffDetails}) : super(key: key);


  @override
  _UpdateStaffPageState createState() => _UpdateStaffPageState();
}

class _UpdateStaffPageState extends State<UpdateStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ManageStaffServices _staffServices = ManageStaffServices();
  final ApiService apiService = ApiService();

  late String staffName;
  late String staffPhone;
  late String staffEmail;
  String? selectedDesignation;
  List<Designation> designations = [];
  int? loggedUserid ;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
    _fetchDesignations();
  }

  Future<void> _initializeUserData() async {
    try {
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails");

      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
      });

      print("Logged User ID: $loggedUserid");
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  void _initializeData() {
    staffName = widget.staffDetails.staffName!;
    staffPhone = widget.staffDetails.staffPhone!;
    staffEmail = widget.staffDetails.staffEmail!;
    selectedDesignation = widget.staffDetails.designation;
  }

  Future<void> _fetchDesignations() async {
    try {
      List<Designation> fetchedDesignations = await apiService.fetchDesignation();
      setState(() {
        // Filter out the designation with designationId == 1
        designations = fetchedDesignations.where((designation) => designation.designationId != 1).toList();
      });
    } catch (e) {
      print("Error fetching designations: $e");
    }
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) {
      print("Validation failed.");
      CommonLoaders.errorSnackBar(
          title: 'Error', message: 'Please fill out all required fields.',duration: 4);
      return;
    }

    print("Form validation passed");

    final selectedDesignationId = designations
        .firstWhere((designation) => designation.designation == selectedDesignation)
        .designationId;

    final updateModel = UpdateStaffRequestModel(
      staffId: widget.staffDetails.staffId,
      userid: loggedUserid ?? 0,
      staffName: staffName,
      staffEmail: staffEmail,
      staffPhone: staffPhone,
      designationId: selectedDesignationId,
    );

    try {
      final response = await _staffServices.updateStaff(updateModel);

      if (response.status == 'success') {
        CommonLoaders.successSnackBar(
            title: 'Success', message: response.message, duration: 4);
        Get.to(() => ManageStaffPage());
      } else {
        CommonLoaders.errorSnackBar(
            title: 'Error', message: response.message, duration: 4);
      }
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update staff: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GarageAppBar(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: NavigationDrawerScreen(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtils.getResponsiveWidth(
              context: context, portionWidthValue: 12.0),
          horizontal: ScreenUtils.getResponsiveHeight(
              context: context, portionHeightValue: 12.0),
        ),
        child: BottomBar(
          onChanged: (BottomBarEnum type){
            setState(() {
              Get.to(HomePage());
            });
          },
        ),
      ),
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
                    'STAFF REGISTRATION',
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
                      onPressed: (){
                        Get.to(ManageStaffPage());
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
                            TextFieldForm(
                              label: 'Staff Name',
                              hint: 'Enter Staff Name',
                              value: staffName,
                              onChanged: (value) {
                                setState(() {
                                  staffName = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20.0),
                            ),
                            TextFieldForm(
                              label: 'Staff Phone',
                              hint: 'Enter Staff Phone Number',
                              value: staffPhone,
                              onChanged: (value) {
                                setState(() {
                                  staffPhone = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20.0),
                            ),
                            TextFieldForm(
                              label: 'Staff Email',
                              hint: 'Enter Staff Email',
                              value: staffEmail,
                              onChanged: (value) {
                                setState(() {
                                  staffEmail = value;
                                });
                              },
                            ),
                            DropdownFieldBox(
                              label: 'Designation',
                              hint: 'Select Designation',
                              items: designations.map((designation) => designation.designation).toList(),
                              value: selectedDesignation,
                              onChanged: (value) {
                                setState(() {
                                  selectedDesignation = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20.0),
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
                                    Get.to(ManageStaffPage());
                                  },
                                ),
                                CommonButton(
                                  btnText: 'Update',
                                  buttonColor: BaseColorTheme.primaryGreenColor,
                                  buttonHeight: 25,
                                  buttonWidth: 100,
                                  buttonBorderRaduis: 15,
                                  buttonTextColor:  BaseColorTheme.whiteTextColor,
                                  buttonFontWeight: BaseFontWeights.regular,
                                  buttonFontSize: 12,
                                  onPressed: () {
                                    _submitUpdate(); // Call the method instead of passing the reference
                                  },
                                ),
                              ],
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
    );
  }
}