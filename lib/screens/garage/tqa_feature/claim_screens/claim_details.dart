import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getClaimByGarageId.dart';
import 'package:niterra/models/garage_models/getClaimsByClaimId.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/manage_claim.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/cliam_pages_services.dart';
import 'package:niterra/utils/size.dart';

class ClaimDetailsPage extends StatefulWidget {
  final int claimId;
  const ClaimDetailsPage({Key? key, required this.claimId}) : super(key: key);

  @override
  State<ClaimDetailsPage> createState() => _ClaimRegisterationPageState();
}

class _ClaimRegisterationPageState extends State<ClaimDetailsPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ClaimServices _claimServices = ClaimServices();
  ClaimDetailsByClaimId? claimDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();// Fetch claim details on page load
    _fetchClaimDetails();
  }

  Future<void> _fetchClaimDetails() async {
    try {
      final details = await _claimServices.fetchClaimDetailsById(widget.claimId);
      setState(() {
        claimDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                  padding:  EdgeInsets.symmetric(
                      horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
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
                              fontWeight: BaseFontWeights.semiBold),
                        ),
                        SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 40.23),
                        ),
                        const Text(
                          'CLAIM DETAILS',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              color: BaseColorTheme.subHeadingTextColor,
                              fontSize: 20.0,
                              fontWeight: BaseFontWeights.semiBold),
                        ),
                        SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15),
                        ),
      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CommonButton(
                              buttonColor: BaseColorTheme.buttonBgColor,
                              btnText: 'List All',
                              buttonBorderRaduis: 10.0,
                              buttonFontSize: 12.0 ,
                              buttonFontWeight:BaseFontWeights.medium ,
                              buttonHeight: 22.0,
                              buttonTextColor: BaseColorTheme.whiteTextColor,
                              buttonWidth: 90 ,
                              onPressed: (){
                                Get.to(ManageClaimScreen());
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 10),
                        ),
      
                        Container(
                          decoration: BoxDecoration(
                            color: BaseColorTheme.whiteTextColor,
                            boxShadow: const [
                              BoxShadow(
                                color: BaseColorTheme.textfieldShadowColor,
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 10),
                                  ),
                                  Text('Consumer Details',
                                  style: TextStyle(fontSize: 18,
                                  fontWeight: BaseFontWeights.bold,
                                  color: BaseColorTheme.primaryGreenColor),
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  CustomTextField(label: 'Name',
                                  //hinttext: claimDetails?.,
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  CustomTextField(label: 'Phone',
                                 // hinttext: claimDetails?.phone,
                                    ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  //const CustomTextField(label: 'Email'),
                                  // SizedBox(
                                  //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  // ),
                                  Text('Vehicle Details',
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: BaseFontWeights.bold,
                                        color: BaseColorTheme.primaryGreenColor),
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  CustomTextField(label: 'Plate No',
                                  hinttext: claimDetails?.plateNo,),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  //CustomTextField(label: 'VIN No/Frame No',),
                                  // SizedBox(
                                  //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  // ),
                                 CustomTextField(label: 'Vehicle Model',
                                 hinttext: claimDetails?.vehicleModel,),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  Text('Product Details',
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: BaseFontWeights.bold,
                                        color: BaseColorTheme.primaryGreenColor),
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                   CustomTextField(label: 'Part No',
                                  hinttext: claimDetails?.partNo,),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  CustomTextField(label: 'Product Type',hinttext: claimDetails?.productType,),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  // CustomTextField(label: 'Installation Date',),
                                  // SizedBox(
                                  //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  // ),
                                  Text('Claim Details',
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: BaseFontWeights.bold,
                                        color: BaseColorTheme.primaryGreenColor),
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  CustomTextField(label: 'Qty to claim',
                                  hinttext: claimDetails?.quantityClaim.toString(),),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  CustomTextField(label: 'Diagnosis',
                                  hinttext: claimDetails?.diagnosis,),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  ),
                                  // CustomTextField(label: 'Odometer Reading'),
                                  // SizedBox(
                                  //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  // ),
                                  // const CustomTextField(label: 'Claim Request Date'),
                                  // SizedBox(
                                  //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  // ),
                                  // const CustomTextField(label: 'Reason'),
                                  // SizedBox(
                                  //   height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 30),
                                  // ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Claim Images',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 10),
                                      ),
                                      Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: [
                                          _buildClaimImage('assets/images/203430.jpg'),
                                          _buildClaimImage('assets/images/NGK-CR8EK-001.jpg'),
                                          _buildClaimImage('assets/images/NGK-DPR8EA-9-001.jpg'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 75),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CommonButton(
                                        btnText: 'Back',
                                        buttonColor: BaseColorTheme.buttonBgColor,
                                        buttonHeight: 25,
                                        buttonWidth: 80,
                                        buttonBorderRaduis: 15,
                                        buttonTextColor: BaseColorTheme.whiteTextColor,
                                        buttonFontWeight: BaseFontWeights.medium,
                                        buttonFontSize: 12,
                                        onPressed: (){
                                          Get.to(ManageClaimScreen());
                                        },),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
  Widget _buildClaimImage(String imagePath) {
    return Container(
      width: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 160),
      height: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 100),
      child: ClipRRect(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
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
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.fillColor = BaseColorTheme.textFormFillColor,
    this.hinttext,
    this.enabled = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold,
          color: BaseColorTheme.blackColor),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            fillColor: fillColor,
            filled: true,
            hintText: hinttext,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: BaseFontWeights.semiBold,
              fontSize: 12,
              color: BaseColorTheme.unselectedIconColor
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }
}

