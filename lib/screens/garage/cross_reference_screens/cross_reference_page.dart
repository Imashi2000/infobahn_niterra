import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/cross_reference_model.dart';
import 'package:niterra/screens/garage/cross_reference_screens/cross_reference_details_page.dart';
import 'package:niterra/screens/garage/tqa_feature/consumer_screens/consumer_registration_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/cross_reference_service.dart';
import 'package:niterra/utils/size.dart';
import 'package:shimmer/shimmer.dart';

class CrossReferenceScreen extends StatefulWidget {
  const CrossReferenceScreen({super.key});

  @override
  State<CrossReferenceScreen> createState() => _CrossReferenceScreenState();
}

class _CrossReferenceScreenState extends State<CrossReferenceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CrossReferenceAPIService _crossReferenceAPIService =
      CrossReferenceAPIService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<CrossReferenceModel> allData = [];
  List<CrossReferenceModel> displayedData = [];
  int currentPage = 0;
  int rowsPerPage = 10;
  bool isLoading = false;
  String? currentSearch;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await _crossReferenceAPIService.fetchCrossReferenceData(
          search: currentSearch);
      setState(() {
        allData = data;
        _updateDisplayedData();
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateDisplayedData() {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = startIndex + rowsPerPage;

    setState(() {
      displayedData = allData.sublist(
        startIndex,
        endIndex > allData.length ? allData.length : endIndex,
      );
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updateDisplayedData();
    });
  }

  void _onRowsPerPageChanged(int rows) {
    setState(() {
      rowsPerPage = rows;
      currentPage = 0;
      _updateDisplayedData();
    });
  }

  void _onSearch(String query) {
    setState(() {
      currentSearch = query.isEmpty ? null : query;
      currentPage = 0;
    });
    _fetchData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      if ((currentPage + 1) * rowsPerPage < allData.length) {
        setState(() {
          currentPage++;
          _updateDisplayedData();
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (allData.length / rowsPerPage).ceil();
    return Scaffold(
        key: _scaffoldKey,
        appBar: GarageAppBar(
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: const NavigationDrawerScreen(),
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
                    const Text(
                      'DASHBOARD',
                      style: TextStyle(
                          color: BaseColorTheme.headingTextColor,
                          fontSize: 22.0,
                          fontWeight: BaseFontWeights.semiBold),
                    ),
                    SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 32.0)),
                    const Text(
                      'CROSS REFERENCE',
                      style: TextStyle(
                          color: BaseColorTheme.subHeadingTextColor,
                          fontSize: 20.0,
                          fontWeight: BaseFontWeights.semiBold),
                    ),
                    SizedBox(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 37.0)),
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: ScreenUtils.getResponsiveHeight(
                                context: context, portionHeightValue: 10.0),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 17.0),
                              ),
                              const Text(
                                "Show",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: BaseColorTheme.unselectedIconColor,
                                    fontWeight: BaseFontWeights.medium),
                              ),
                             SizedBox(width: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 8.0),),
                              Container(
                                height: 32.0,
                                width: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 47.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: BaseColorTheme.borderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<int>(
                                  value: rowsPerPage,
                                  items: [5, 10, 15]
                                      .map((e) => DropdownMenuItem<int>(
                                          value: e, child: Text('$e')))
                                      .toList(),
                                  onChanged: (value) =>
                                      _onRowsPerPageChanged(value!),
                                  borderRadius: BorderRadius.circular(15.0),
                                  underline: Container(),
                                ),
                              ),
                              SizedBox(width: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 16.0),),
                              const Text(
                                "Entries Search",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: BaseColorTheme.unselectedIconColor,
                                    fontWeight: BaseFontWeights.medium),
                              ),
                              SizedBox(width: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 16.0),),
                              Expanded(
                                child: Container(
                                  height: 32.0,
                                  width: ScreenUtils.getResponsiveWidth(
                                      context: context, portionWidthValue: 117.0),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: _onSearch,
                                    decoration: InputDecoration(
                                      hintText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: BaseColorTheme.searchLineColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: BaseColorTheme.searchLineColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: BaseColorTheme.searchLineColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtils.getResponsiveWidth(
                                    context: context, portionWidthValue: 17.0),
                              )
                            ],
                          ),
                          SizedBox(
                              height: ScreenUtils.getResponsiveHeight(
                                  context: context, portionHeightValue: 20.0)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtils.getResponsiveWidth(
                                  context: context, portionWidthValue: 17.0),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: isLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: DataTable(
                                        headingRowColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => BaseColorTheme
                                                    .tableHeadingBgColor),
                                        columns: const [
                                          DataColumn(label: Text('Sl No')),
                                          DataColumn(
                                              label: Text('Product Type')),
                                          DataColumn(
                                              label:
                                                  Text('Competitor Part No')),
                                          DataColumn(label: Text('Competitor')),
                                          DataColumn(
                                              label: Text('NGK/NTK Part No')),
                                        ],
                                        rows: List<DataRow>.generate(
                                          rowsPerPage, // Show shimmer rows equal to rowsPerPage
                                          (index) => DataRow(cells: [
                                            DataCell(Container(
                                              width: 50,
                                              height: 16,
                                              color: Colors.grey,
                                            )),
                                            DataCell(Container(
                                              width: 100,
                                              height: 16,
                                              color: Colors.grey,
                                            )),
                                            DataCell(Container(
                                              width: 120,
                                              height: 16,
                                              color: Colors.grey,
                                            )),
                                            DataCell(Container(
                                              width: 100,
                                              height: 16,
                                              color: Colors.grey,
                                            )),
                                            DataCell(Container(
                                              width: 100,
                                              height: 16,
                                              color: Colors.grey,
                                            )),
                                          ]),
                                        ),
                                      ),
                                    )
                                  : DataTable(
                                      headingRowColor:
                                          WidgetStateColor.resolveWith(
                                              (states) => BaseColorTheme
                                                  .tableHeadingBgColor),
                                      dataRowColor:
                                          WidgetStateColor.resolveWith(
                                              (states) => BaseColorTheme
                                                  .tableRowBgColor),
                                      columns: const [
                                        DataColumn(label: Text('Sl No')),
                                        DataColumn(label: Text('Product Type')),
                                        DataColumn(
                                            label: Text('Competitor Part No')),
                                        DataColumn(label: Text('Competitor')),
                                        DataColumn(
                                            label: Text('NGK/NTK Part No')),
                                      ],
                                      rows: List<DataRow>.generate(
                                        displayedData.length,
                                        (index) {
                                          final rowData = displayedData[index];
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        ReferenceDetailsScreen(
                                                          item: {
                                                            'Sl No':
                                                                '${index + 1 + (currentPage * rowsPerPage)}',
                                                            'Product Type':
                                                                rowData
                                                                    .productType,
                                                            'Competitor Part No':
                                                                rowData
                                                                    .competitorPartNo,
                                                            'Competitor':
                                                                rowData
                                                                    .competitor,
                                                            'NGK/NTK Part No':
                                                                rowData
                                                                    .ngkNtkPartNo,
                                                          },
                                                        ));
                                                  },
                                                  child: Text(
                                                      '${index + 1 + (currentPage * rowsPerPage)}'),
                                                ),
                                              ),
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        ReferenceDetailsScreen(
                                                          item: {
                                                            'Sl No':
                                                                '${index + 1 + (currentPage * rowsPerPage)}',
                                                            'Product Type':
                                                                rowData
                                                                    .productType,
                                                            'Competitor Part No':
                                                                rowData
                                                                    .competitorPartNo,
                                                            'Competitor':
                                                                rowData
                                                                    .competitor,
                                                            'NGK/NTK Part No':
                                                                rowData
                                                                    .ngkNtkPartNo,
                                                          },
                                                        ));
                                                  },
                                                  child:
                                                      Text(rowData.productType),
                                                ),
                                              ),
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        ReferenceDetailsScreen(
                                                          item: {
                                                            'Sl No':
                                                                '${index + 1 + (currentPage * rowsPerPage)}',
                                                            'Product Type':
                                                                rowData
                                                                    .productType,
                                                            'Competitor Part No':
                                                                rowData
                                                                    .competitorPartNo,
                                                            'Competitor':
                                                                rowData
                                                                    .competitor,
                                                            'NGK/NTK Part No':
                                                                rowData
                                                                    .ngkNtkPartNo,
                                                          },
                                                        ));
                                                  },
                                                  child: Text(
                                                      rowData.competitorPartNo),
                                                ),
                                              ),
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        ReferenceDetailsScreen(
                                                          item: {
                                                            'Sl No':
                                                                '${index + 1 + (currentPage * rowsPerPage)}',
                                                            'Product Type':
                                                                rowData
                                                                    .productType,
                                                            'Competitor Part No':
                                                                rowData
                                                                    .competitorPartNo,
                                                            'Competitor':
                                                                rowData
                                                                    .competitor,
                                                            'NGK/NTK Part No':
                                                                rowData
                                                                    .ngkNtkPartNo,
                                                          },
                                                        ));
                                                  },
                                                  child:
                                                      Text(rowData.competitor),
                                                ),
                                              ),
                                              DataCell(
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() =>
                                                        ReferenceDetailsScreen(
                                                          item: {
                                                            'Sl No':
                                                                '${index + 1 + (currentPage * rowsPerPage)}',
                                                            'Product Type':
                                                                rowData
                                                                    .productType,
                                                            'Competitor Part No':
                                                                rowData
                                                                    .competitorPartNo,
                                                            'Competitor':
                                                                rowData
                                                                    .competitor,
                                                            'NGK/NTK Part No':
                                                                rowData
                                                                    .ngkNtkPartNo,
                                                          },
                                                        ));
                                                  },
                                                  child: Text(
                                                      rowData.ngkNtkPartNo),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: currentPage > 0
                                    ? () => _onPageChanged(currentPage - 1)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              TextButton(
                                onPressed: null,
                                child: Text('${currentPage + 1}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              IconButton(
                                onPressed: currentPage < totalPages - 1
                                    ? () => _onPageChanged(currentPage + 1)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
