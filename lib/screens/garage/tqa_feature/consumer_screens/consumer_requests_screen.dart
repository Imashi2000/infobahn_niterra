// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:niterra/common/widgets/button.dart';
// import 'package:niterra/common/widgets/garage_app_bar.dart';
// import 'package:niterra/common/styles/colors.dart';
// import 'package:niterra/common/styles/font_styles.dart';
// import 'package:niterra/common/widgets/bottom_navbar.dart';
// import 'package:niterra/common/widgets/navigation_drawer.dart';
// import 'package:niterra/screens/garage/tqa_feature/consumer_screens/consumer_registration_page.dart';
// import 'package:niterra/screens/garage/cross_reference_screens/cross_reference_details_page.dart';
// import 'package:niterra/utils/size.dart';
//
// class ConsumerRequestsScreen extends StatelessWidget {
//   ConsumerRequestsScreen({super.key});
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   final List<Map<String, String>> tableData = [
//     {
//       'Sl No': '1',
//       'Assigned by': 'Mr. Muhammad',
//       'Assigned For': 'Vehicle/Product Registration',
//       'Assigned On': '2024-09-23',
//       'Status': 'Registration Complete',
//     },
//     {
//       'Sl No': '2',
//       'Assigned by': 'Mr. Muhammad',
//       'Assigned For': 'Vehicle/Product Registration',
//       'Assigned On': '2024-09-23',
//       'Status': 'Assigned',
//     },
//     {
//       'Sl No': '3',
//       'Assigned by': 'Mr. Muhammad',
//       'Assigned For': 'Claim Registration',
//       'Assigned On': '2024-09-23',
//       'Status': 'Claim Complete',
//     },
//     {
//       'Sl No': '4',
//       'Assigned by': 'Mr. Muhammad',
//       'Assigned For': 'Claim Registration',
//       'Assigned On': '2024-09-23',
//       'Status': 'Request Approved',
//     },
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: GarageAppBar(
//           onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
//         ),
//         drawer: NavigationDrawerScreen(),
//         bottomNavigationBar: Padding(
//           padding: EdgeInsets.symmetric(
//               vertical: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 12.0),
//               horizontal: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 12.0)
//           ),
//           child: BottomBar(
//             onChanged: (BottomBarEnum type){
//               // setState(() {
//               //   selectedPage = type;
//               // });
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Image.asset(
//                   'assets/images/bgSettings.png',
//                   width: MediaQuery.of(context).size.width * 0.4,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding:  EdgeInsets.symmetric(
//                     horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
//                 ),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'DASHBOARD',
//                         style: TextStyle(
//                             color: BaseColorTheme.headingTextColor,
//                             fontSize: 22.0,
//                             fontWeight: BaseFontWeights.semiBold),
//                       ),
//                       SizedBox(
//                         height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 32.0),
//                       ),
//                       const Text(
//                         'CONSUMER REQUESTS',
//                         style: TextStyle(
//                             color: BaseColorTheme.subHeadingTextColor,
//                             fontSize: 20.0,
//                             fontWeight: BaseFontWeights.semiBold),
//                       ),
//                       SizedBox(
//                         height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 37.0),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.0),
//                           color: BaseColorTheme.whiteTextColor,
//                           boxShadow: const [
//                             BoxShadow(
//                                 color: Color.fromRGBO(218, 218, 218, 0.5),
//                                 offset: Offset(0, 4),
//                                 blurRadius: 4)
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0),
//                             ),
//                             Row(
//                               children: [
//                                 Spacer(),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 17.0),
//                                   child: CommonButton(
//                                     buttonColor: BaseColorTheme.buttonBgColor,
//                                     btnText: 'Add New +',
//                                     buttonBorderRaduis: 10.0,
//                                     buttonFontSize: 12.0,
//                                     buttonFontWeight: BaseFontWeights.medium,
//                                     buttonHeight: 22.0,
//                                     buttonTextColor: BaseColorTheme.whiteTextColor,
//                                     buttonWidth: 117.0,
//                                     onPressed: () {
//                                       Get.to(ConsumerRegistrationPage());
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 10.0),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 25.0),
//                                 ),
//                                 const Text(
//                                   "Show",
//                                   style: TextStyle(
//                                       fontSize: 12.0,
//                                       color: BaseColorTheme.unselectedIconColor,
//                                       fontWeight: BaseFontWeights.medium
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//
//                                 SizedBox(
//                                   width: 80.0,
//                                   height: 32.0,
//                                   child: TextFormField(
//                                     readOnly: true, // To open dropdown on click
//                                     decoration: InputDecoration(
//                                       hintText: '10',
//                                       suffixIcon: const Icon(Icons.arrow_drop_down),
//                                       contentPadding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: const BorderSide(
//                                           color: BaseColorTheme.searchLineColor,
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: const BorderSide(
//                                           color: BaseColorTheme.searchLineColor,
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide: const BorderSide(
//                                           color: BaseColorTheme.searchLineColor,
//                                           width: 1.5,
//                                         ),
//                                       ),
//                                     ),
//                                     onTap: () {
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//
//                                 // "Entries" text
//                                 const Text(
//                                   "Entries Search",
//                                   style: TextStyle(
//                                       fontSize: 12.0,
//                                       color: BaseColorTheme.unselectedIconColor,
//                                       fontWeight: BaseFontWeights.medium
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//
//                                 // Search text field
//                                 Expanded(
//                                   child: Container(
//                                     height: 32.0,
//                                     child: TextField(
//                                       decoration: InputDecoration(
//                                         hintText: '',
//                                         border: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                           borderSide: const BorderSide(
//                                             color: BaseColorTheme.searchLineColor,
//                                             width: 1.5,
//                                           ),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                           borderSide: const BorderSide(
//                                             color: BaseColorTheme.searchLineColor,
//                                             width: 1.5,
//                                           ),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderRadius: BorderRadius.circular(8),
//                                           borderSide: const BorderSide(
//                                             color: BaseColorTheme.searchLineColor,
//                                             width: 1.5,
//                                           ),
//                                         ),
//                                         contentPadding:
//                                         const EdgeInsets.symmetric(horizontal: 12),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 25.0),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 left: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 7.0)
//                               ),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   headingRowColor: MaterialStateColor.resolveWith(
//                                           (states) => BaseColorTheme.tableHeadingBgColor),
//                                   dataRowColor: MaterialStateColor.resolveWith(
//                                           (states) => BaseColorTheme.tableRowBgColor),
//                                   headingTextStyle: const TextStyle(
//                                       color: BaseColorTheme.blackColor,
//                                       fontWeight: BaseFontWeights.semiBold,
//                                       fontSize: 12.0),
//                                   dataTextStyle: const TextStyle(
//                                       color: BaseColorTheme.blackColor,
//                                       fontWeight: BaseFontWeights.regular,
//                                       fontSize: 12.0),
//                                   border: TableBorder.all(
//                                       color: BaseColorTheme.tableLineColor),
//                                   headingRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 68.0),
//                                   dataRowHeight: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 36.0),
//                                   columns: const [
//                                     DataColumn(label: Text('Sl No')),
//                                     DataColumn(label: Text('Assigned by')),
//                                     DataColumn(label: Text('Assigned For')),
//                                     DataColumn(label: Text('Assigned On')),
//                                     DataColumn(label: Text('Status')),
//                                   ],
//                                   rows: tableData.map((rowData) {
//                                     return DataRow(cells: [
//                                       DataCell(
//                                         Text(rowData['Sl No'] ?? ''),
//                                         // onTap: () {
//                                         //   Navigator.push(
//                                         //     context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) => ReferenceDetailsScreen(item: rowData)
//                                         //     ),
//                                         //   );
//                                         // },
//                                       ),
//                                       DataCell(
//                                         Text(rowData['Assigned by'] ?? ''),
//                                         // onTap: () {
//                                         //   Navigator.push(
//                                         //     context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) => ReferenceDetailsScreen(item: rowData)
//                                         //     ),
//                                         //   );
//                                         // },
//                                       ),
//                                       DataCell(
//                                         Text(
//                                             rowData['Assigned For'] ?? ''),
//                                         onTap: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => ReferenceDetailsScreen(item: rowData)
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       DataCell(
//                                         Text(rowData['Assigned On'] ?? ''),
//                                         // onTap: () {
//                                         //   Navigator.push(
//                                         //     context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) => ReferenceDetailsScreen(item: rowData)
//                                         //     ),
//                                         //   );
//                                         // },
//                                       ),
//                                       DataCell(
//                                         Text(
//                                             rowData['Status'] ?? ''
//                                         ),
//                                         // onTap: () {
//                                         //   Navigator.push(
//                                         //     context,
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) => ReferenceDetailsScreen(item: rowData)
//                                         //     ),
//                                         //   );
//                                         // },
//                                       ),
//                                     ]);
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 40.0),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
