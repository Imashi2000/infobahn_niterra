import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottombar.dart';
import 'package:niterra/screens/auth/logout_handler.dart';
import 'package:niterra/screens/garage/manage_campaign_screens/campaign_list_page.dart';
import 'package:niterra/screens/garage/garage_agreement_page.dart';
import 'package:niterra/screens/garage/staff_screens/manage_staff_page.dart';
import 'package:niterra/screens/garage/training_screens/manage_trainings.dart';
import 'package:niterra/screens/garage/profile_page.dart';
import 'package:niterra/screens/garage/tqa_feature/consumer_screens/consumer_list_table.dart';
import 'package:niterra/screens/garage/cross_reference_screens/cross_reference_page.dart';
import 'package:niterra/screens/garage/dashboard_page.dart';
import 'package:niterra/screens/garage/feedback_page.dart';
import 'package:niterra/screens/garage/tqa_feature/claim_screens/manage_claim.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/vehicle_list_page.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/product_list_page.dart';
import 'package:niterra/screens/garage/training_tracker_page.dart';
import 'package:niterra/utils/size.dart';

class NavigationDrawerScreen extends StatefulWidget {
  const NavigationDrawerScreen({super.key});

  @override
  State<NavigationDrawerScreen> createState() => _NavigationDrawerScreenState();
}

class _NavigationDrawerScreenState extends State<NavigationDrawerScreen> {
  int? _expandedIndex; // To track which category is expanded

  final List<Map<String, dynamic>> items = [
    {'image': 'assets/images/meter-6.png', 'name': 'Dashboard', 'screen': GarageDashboardScreen(), 'subcategories': []},
    {'image': 'assets/images/reference.png', 'name': 'Cross Reference', 'screen': CrossReferenceScreen(), 'subcategories': []},
    {
      'image': 'assets/images/tqa.png',
      'name': 'TQA',
      'screen': null, // TQA doesn't have a direct screen, it's a category with subcategories
      'subcategories': [
        {'image': 'assets/images/customer-review.png', 'name': 'Consumer Registration', 'screen': ConsumerRequestsScreen()},
        {'image': 'assets/images/request.png', 'name': 'Vehicle Registration', 'screen': VehicleListPage()},
        {'image': 'assets/images/registration.png', 'name': 'Product Registration', 'screen': ProductListPage()},
        {'image': 'assets/images/letter.png', 'name': 'Manage Claim', 'screen': ManageClaimScreen()},
      ]
    },
    {'image': 'assets/images/people-group.png', 'name': 'Manage Staff', 'screen': ManageStaffPage(), 'subcategories': []},
    {'image': 'assets/images/people-carry.png', 'name': 'Manage Trainings', 'screen': ManageTrainingsPage(), 'subcategories': []},
    {'image': 'assets/images/gps-fixed.png', 'name': 'Training Tracker', 'screen': TrainingTrackerPage(), 'subcategories': []},
    {'image': 'assets/images/report-document.png', 'name': 'Garage Agreement', 'screen': GarageAgreementPage(), 'subcategories': []},
    {'image': 'assets/images/clipboard.png', 'name': 'Manage Campaign', 'screen': CampaignListPage(), 'subcategories': []},
    {'image': 'assets/images/feedback.png', 'name': 'Feedback', 'screen': FeedbackPage(), 'subcategories': []},
    {'image': 'assets/images/user_logo.png', 'name': 'My Profile', 'screen': ProfilePage(), 'subcategories': []},
    {'image': 'assets/images/home.png', 'name': 'Home', 'screen': BottomNavigationBarExample(), 'subcategories': []},
    {'image': 'assets/images/logout.png', 'name': 'Log Out', 'screen':null, 'subcategories': []},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: BaseColorTheme.subHeadingTextColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (items[index]['subcategories'].isEmpty) {
                    return _buildTile(index);
                  } else {
                    return _buildExpandableTile(index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a simple ListTile
  Widget _buildTile(int index) {
    bool isDashboard = index == 0; // Only the Dashboard tile has a different style
    return Column(
      children: [
        Container(
          height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 57),
          decoration: isDashboard
              ? const ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(1.00, 0.00),
              end: Alignment(-1, 0),
              colors: [Color(0xFF00757F), Color(0xFF008346)],
            ),
            shape: RoundedRectangleBorder(),
          )
              : null,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300), // 300ms animation duration
            switchInCurve: Curves.easeOut, // Ease out curve for smooth transition
            child: ListTile(
              key: ValueKey<int>(index), // Ensure that AnimatedSwitcher knows when to switch
              tileColor: isDashboard ? null : BaseColorTheme.whiteTextColor, // Default white for others
              leading: Image.asset(
                items[index]['image'],
                width: 30,
                height: 30,
              ),
              title: Text(
                items[index]['name'],
                style: TextStyle(
                  color: isDashboard ? Colors.white : BaseColorTheme.subHeadingTextColor,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: BaseFontWeights.medium,
                ),
              ),
              onTap: () {
                if (items[index]['name'] == 'Log Out') {
                  // Call LogoutHandler.logout
                  LogoutHandler.logout(context);
                } else {
                  Navigator.pop(context); // Close the drawer
                  Get.to(items[index]['screen']); // Navigate to the screen
                }
              },
            ),
          ),
        ),
        Divider(
          color: BaseColorTheme.subHeadingTextColor,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  // Build an expandable ListTile for items with subcategories
  Widget _buildExpandableTile(int index) {
    return Column(
      children: [
        ListTile(
          key: ValueKey<int>(index), // Ensure that AnimatedSwitcher knows when to switch
          tileColor: BaseColorTheme.whiteTextColor, // Same color for all expandable tiles
          leading: Image.asset(
            items[index]['image'],
            width: 30,
            height: 30,
          ),
          title: Text(
            items[index]['name'],
            style: TextStyle(
              color: BaseColorTheme.subHeadingTextColor,
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: BaseFontWeights.medium,
            ),
          ),
          onTap: () {
            setState(() {
              _expandedIndex = _expandedIndex == index ? null : index; // Toggle expansion
            });
          },
        ),
        Divider(
          color: BaseColorTheme.subHeadingTextColor,
          height: 1,
          thickness: 1,
        ),
        if (_expandedIndex == index)
          Column(
            children: items[index]['subcategories'].map<Widget>((subcategory) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 29)),
                    height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 44),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300), // 300ms animation duration
                      switchInCurve: Curves.easeOut, // Ease out curve for smooth transition
                      child: ListTile(
                        key: ValueKey<int>(items[index]['subcategories'].indexOf(subcategory)),
                        tileColor: BaseColorTheme.whiteTextColor,
                        leading: Image.asset(
                          subcategory['image'],
                          width: 12,
                          height: 12,
                        ),
                        title: Text(
                          subcategory['name'],
                          style: TextStyle(
                            color: BaseColorTheme.subHeadingTextColor,
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: BaseFontWeights.medium,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                          Get.to(subcategory['screen']); // Navigate to the subcategory screen
                        },
                      ),
                    ),
                  ),
                  Divider(
                    color: BaseColorTheme.subHeadingTextColor,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}