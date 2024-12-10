import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:niterra/common/snackbar.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getFeedbackByUser_model.dart';
import 'package:niterra/models/garage_models/saveFeedbackRequest_model.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/feedback_services.dart';
import 'package:niterra/utils/size.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FeedBackService _feedBackService = FeedBackService();
  final TextEditingController _feedbackController = TextEditingController();
 // Controller for feedback input
  List<FeedbackItem> feedbacks =[];
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  int? loggedUserid;
  String noFeedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedUserid != null) {
      _fetchFeedbacksByUserId();
    }
  }

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      //print("User Details: $userDetails"); // Debug log for userDetails
      setState(() {
        loggedUserid = int.tryParse(userDetails['userId'] ?? '0');
      });
      //print("Logged User ID: $loggedUserid , Logged UserTypeId: $userTypeId, Logged cityId: $cityId");
      if (loggedUserid != null) {
        await _fetchFeedbacksByUserId();
      }
    } catch (e) {
      //print('Error in _initializeUserData: $e');
      CommonLoaders.errorSnackBar(title: 'Error retrieving user details',message: '$e', duration: 4);
    }
  }

  Future<void> _fetchFeedbacksByUserId() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final fetchedFeedbacks = await _feedBackService.getFeedback(loggedUserid!);
      setState(() {
        feedbacks = fetchedFeedbacks;
        noFeedbackMessage = feedbacks.isEmpty ? 'No feedback available.' : '';
      });
    } catch (e) {
      CommonLoaders.errorSnackBar(
        title: 'Error fetching feedback',
        message: '$e',
        duration: 4,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveFeedback() async {
    final feedbackText = _feedbackController.text.trim();

    if (feedbackText.isEmpty) {
      CommonLoaders.errorSnackBar(
          title: 'Validation Error', message: 'Feedback cannot be empty.', duration: 4);
      return;
    }

    final SaveFeedbackRequest request = SaveFeedbackRequest(
      action: "saveFeedback",
      userId: loggedUserid.toString(),
      feedback: feedbackText,
    );

    try {
      setState(() {
        isLoading = true;
      });

      final response = await _feedBackService.saveFeedback(request);

      setState(() {
        isLoading = false;
      });

      CommonLoaders.successSnackBar(
          title: 'Success', message: response.message, duration: 4);

      // Clear input and reload feedback table
      _feedbackController.clear();
      _fetchFeedbacksByUserId();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CommonLoaders.errorSnackBar(
          title: 'Error saving feedback', message: '$e', duration: 4);
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
                        context: context, portionWidthValue: 18.0)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 7.83),
                      ),
                      const Text(
                        'FEEDBACK',
                        style: TextStyle(
                          color: BaseColorTheme.subHeadingTextColor,
                          fontSize: 22.0,
                          fontWeight: BaseFontWeights.semiBold,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 16.23),
                      ),
                      // Feedback input field
                      Container(
                        width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 356),
                        height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 169),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: BaseColorTheme.borderColor,width: 1),
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                              color: BaseColorTheme.textfieldShadowColor,
                              blurRadius: 4.0,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _feedbackController,
                          decoration: InputDecoration(
                            hintText: 'Type your feedback here',
                            hintStyle: TextStyle(color: BaseColorTheme.blackColor.withOpacity(0.6000000238418579),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: BaseFontWeights.regular),

                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 9.01, horizontal: 19.1),
                          ),
                          maxLines: null, // Allow multiline input
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 15),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommonButton(
                              btnText: 'Submit',
                              buttonColor: BaseColorTheme.primaryGreenColor,
                              buttonHeight: 25,
                              buttonWidth: 95,
                              buttonBorderRaduis: 15,
                              buttonTextColor: BaseColorTheme.whiteTextColor,
                              buttonFontWeight: BaseFontWeights.medium,
                              buttonFontSize: 10,
                            onPressed: () async {
                              await _saveFeedback();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 34),
                      ),
                      // Feedback table
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
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
                          padding:  EdgeInsets.all(
                              ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateColor.resolveWith(
                                      (states) =>
                                  BaseColorTheme.feedbackTableHeadingBgColor),
                              dataRowColor: WidgetStateColor.resolveWith(
                                      (states) => BaseColorTheme.tableRowBgColor),
                              headingTextStyle: const TextStyle(
                                  color: BaseColorTheme.blackColor,
                                  fontWeight: BaseFontWeights.semiBold,
                                  fontSize: 14.0),
                              border: TableBorder.all(
                                  color: BaseColorTheme.tableLineColor),
                              headingRowHeight: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 36.0),
                              dataRowHeight: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 100.0),
                              columns: const [
                                DataColumn(label: Text('SL No')),
                                DataColumn(label: Text('Feedback')),
                                DataColumn(label: Text('Reply')),
                              ],
                              rows: feedbacks.asMap().entries.map((entry) {
                                final index = entry.key + 1; // 1-based index
                                final feedbackDetails = entry.value; // Extract FeedbackItem

                                return DataRow(cells: [
                                  DataCell(Text('$index')), // Index
                                  DataCell(Text(feedbackDetails.feedback)), // Feedback text
                                  DataCell(Text(feedbackDetails.reply.isNotEmpty
                                      ? feedbackDetails.reply
                                      : '')), // Reply or default text
                                ]);
                              }).toList(),

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
