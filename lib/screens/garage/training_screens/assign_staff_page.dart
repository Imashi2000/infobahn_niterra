import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getStaffAssigned_model.dart';
import 'package:niterra/models/garage_models/getStaffToAssign_model.dart';
import 'package:niterra/models/garage_models/getTrainingsByUserType_model.dart';
import 'package:niterra/models/garage_models/saveStaffAssigned_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/claim_details.dart';
import 'package:niterra/screens/garage/training_screens/manage_trainings.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/manage_training_services.dart';
import 'package:niterra/utils/size.dart';

class AssignStaffPage extends StatefulWidget {
  final TrainingByUserType trainingDetails;

  const AssignStaffPage({Key? key, required this.trainingDetails}) : super(key: key);
  @override
  _AssignStaffPageState createState() =>
      _AssignStaffPageState();
}

class _AssignStaffPageState extends State<AssignStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ManageTrainingServices _manageTrainingServices = ManageTrainingServices();

  TrainingByUserType? trainingDetails;
  bool isLoading = true;
  List<StaffAssigned> assignedStaff = [];
  List<StaffToAssign> stafftoAssign = [];
  Set<int> selectedStaffIds = {};
  int? loggedUserid;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    trainingDetails = widget.trainingDetails;
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedUserid != null) {
      _fetchStaffDetails();
    }
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
      });

      print("Logged User ID: $loggedUserid");
      if (loggedUserid != null && loggedUserid != 0) {
        await _fetchStaffDetails();
      }

    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchStaffDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch both assigned staff and staff available for assignment
      final assigned = await _manageTrainingServices.fetchStaffAssigned(widget.trainingDetails.trainingId);
      final toAssign = await _manageTrainingServices.fetchStaffToAssign(loggedUserid!);

      setState(() {
        assignedStaff = assigned;
        stafftoAssign = toAssign;
        selectedStaffIds = assigned.map((staff) => staff.staffid).toSet(); // Pre-select already assigned staff
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching staff details: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleSubmit() async {
    // Only include newly selected staff that are not already assigned
    final newSelectedStaffIds = selectedStaffIds.difference(
      assignedStaff.map((staff) => staff.staffid).toSet(),
    );

    print('New Selected Staff IDs: $newSelectedStaffIds'); // Debugging

    if (newSelectedStaffIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No new staff selected for assignment')),
      );
      return;
    }

    final request = AssignTrainingRequest(
      action: "assignTraining",
      staffIds: newSelectedStaffIds.toList(),
      trainingId: widget.trainingDetails.trainingId.toString(),
      userId: loggedUserid.toString(),
    );

    try {
      final response = await _manageTrainingServices.submitAssignment(request);

      if (response.status == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        Get.off(ManageTrainingsPage()); // Navigate to ManageTrainingsPage
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.message}')),
        );
      }
    } catch (e) {
      print('Error during submission: $e'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
                      'ASSIGN STAFF',
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
                          Get.to(ManageTrainingsPage());
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
                                label: 'Training Name',
                                hinttext: trainingDetails?.trainingName,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              CustomTextField(
                                label: 'Training Date',
                                hinttext: trainingDetails?.trainingDate,
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              Container(
                                width: double.infinity, // Adjust to match other widgets
                                child: MultiLineTextField(
                                  label: 'Assigned Staff',
                                  text: assignedStaff.map((staff) => staff.staffname).join('    '),
                                  fillColor: BaseColorTheme.textFormFillColor, // Optional background color
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtils.getResponsiveHeight(
                                    context: context, portionHeightValue: 20.0),
                              ),
                              const Text(
                                'Staff to Assign',
                                style: TextStyle(
                                  fontWeight: BaseFontWeights.semiBold,
                                  fontSize: 14,
                                  color: BaseColorTheme.blackColor,
                                ),
                              ),
                              ...stafftoAssign.map(
                                    (staff) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: selectedStaffIds.contains(staff.staffid),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedStaffIds.add(staff.staffid);
                                            } else {
                                              selectedStaffIds.remove(staff.staffid);
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        staff.staffname,
                                        style: const TextStyle(
                                          fontSize: 12, // Adjust the font size here
                                          fontWeight: FontWeight.w500,
                                          color: BaseColorTheme.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).toList(),
      
      
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
                                      Get.to(ManageTrainingsPage());
                                    },
                                  ),
                                  CommonButton(
                                    btnText: 'Submit',
                                    buttonColor: BaseColorTheme.primaryGreenColor,
                                    buttonHeight: 25,
                                    buttonWidth: 100,
                                    buttonBorderRaduis: 15,
                                    buttonTextColor:  BaseColorTheme.whiteTextColor,
                                    buttonFontWeight: BaseFontWeights.regular,
                                    buttonFontSize: 12,
                                    onPressed:(){
                                      _handleSubmit();
                                    },
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
            ],
          ),
        ),
      ),
    );
  }
}

class MultiLineTextField extends StatelessWidget {
  final String label;
  final String? text;
  final Color fillColor;
  final TextStyle? textStyle;

  const MultiLineTextField({
    super.key,
    required this.label,
    this.text,
    this.fillColor = BaseColorTheme.textFormFillColor,// Default fill color
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Default label color
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text ?? '', // Display the multi-line text
            style: textStyle ??
                const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black, // Default text color
                ),
          ),
        ),
      ],
    );
  }
}