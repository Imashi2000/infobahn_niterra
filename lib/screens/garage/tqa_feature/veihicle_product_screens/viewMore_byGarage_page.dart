import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/button.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'package:niterra/models/garage_models/getAllProdDetByUserProductId_model.dart';
import 'package:niterra/models/garage_models/getProductsByGarageId_model.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/product_list_page.dart';
import 'package:niterra/screens/navbar/home/home_page.dart';
import 'package:niterra/services/garage_services/product_registration_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:shimmer/shimmer.dart';

class ViewMoreDetailsGaragePage extends StatefulWidget {
  final int userProductId;
  const ViewMoreDetailsGaragePage({Key? key, required this.userProductId}) : super(key: key);

  @override
  State<ViewMoreDetailsGaragePage> createState() => _ViewMoreDetailsGaragePageState();
}

class _ViewMoreDetailsGaragePageState extends State<ViewMoreDetailsGaragePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProductRegistrationServices _productService = ProductRegistrationServices();

  ProductDetails? productDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final details = await _productService.fetchProductDetailsByUserProductId(widget.userProductId);
      setState(() {
        productDetails = details;
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: GarageAppBar(
        isDetailsPage: true,
        detailsTitle: 'James Garage',
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: NavigationDrawerScreen(),
      body: isLoading
          ? _buildShimmerEffect()
          : productDetails == null
          ? Center(child: Text('No details available'))
          : _buildDetailsPage(),
    );
  }

  Widget _buildDetailsPage() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 150.0)
              ),
              child: Image.asset(
                'assets/images/bgSettings.png',
                width: ScreenUtils.getResponsiveWidth(
                    context: context, portionWidthValue: 257),
                height: ScreenUtils.getResponsiveHeight(
                    context: context, portionHeightValue: 514),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 18.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DASHBOARD',
                  style: TextStyle(
                    color: BaseColorTheme.headingTextColor,
                    fontSize: 22.0,
                    fontWeight: BaseFontWeights.semiBold,
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 21.23),
                ),
                const Text(
                  'Consumer Details',
                  style: TextStyle(
                    color: BaseColorTheme.subHeadingTextColor,
                    fontSize: 20.0,
                    fontWeight: BaseFontWeights.semiBold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 22.0),
                ),
                detailsWidget(itemTitle: 'Name: ', itemValue: productDetails!.name),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Phone: ', itemValue: productDetails!.phone),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Email: ', itemValue: productDetails!.email),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                const Text(
                  'Vehicle Details',
                  style: TextStyle(
                    color: BaseColorTheme.subHeadingTextColor,
                    fontSize: 20.0,
                    fontWeight: BaseFontWeights.semiBold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 22.0)),
                detailsWidget(itemTitle: 'Vehicle Model: ', itemValue: productDetails!.vehiclemodel),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Plate No: ', itemValue: productDetails!.plateno),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Engine Code: ', itemValue: productDetails!.enginecode),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'VIN No: ', itemValue: productDetails!.vinno),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(
                    itemTitle: 'Odometer Reading(Registration Time): ', itemValue: productDetails!.odometer.toString()),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Annual Mileage: ', itemValue: productDetails!.mileage),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                const Text(
                  'Product Details',
                  style: TextStyle(
                    color: BaseColorTheme.subHeadingTextColor,
                    fontSize: 20.0,
                    fontWeight: BaseFontWeights.semiBold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 22.0)),
                detailsWidget(itemTitle: 'Product Type: ', itemValue: productDetails!.producttype),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Part No: ', itemValue: productDetails!.partno),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                detailsWidget(itemTitle: 'Installation Date: ', itemValue: productDetails!.installdate),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                if (productDetails!.productimg.isNotEmpty)
                  Image.network(
                    productDetails!.productimg,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
                  ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                if (productDetails!.invoiceimg.isNotEmpty)
                  Image.network(
                    productDetails!.invoiceimg,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
                  ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 15.0),
                ),
                CommonButton(
                  btnText: 'Back',
                  buttonColor: BaseColorTheme.buttonBgColor,
                  buttonHeight: 25,
                  buttonWidth: 80,
                  buttonBorderRaduis: 10,
                  buttonTextColor: BaseColorTheme.whiteTextColor,
                  buttonFontWeight: BaseFontWeights.medium,
                  buttonFontSize: 12,
                  onPressed: () {
                    Get.to(ProductListPage());
                  },
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 40.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: List.generate(6, (index) {
            return Column(
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.white,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.image, color: Colors.grey[700]),
      ),
    );
  }
}

class detailsWidget extends StatelessWidget {
  final String itemTitle;
  final String itemValue;
  const detailsWidget({
    super.key,
    required this.itemTitle,
    required this.itemValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          itemTitle,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: BaseFontWeights.semiBold,
            color: BaseColorTheme.unselectedIconColor,
          ),
        ),
        Flexible(
          child: Text(
            itemValue,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: BaseFontWeights.medium,
              color: BaseColorTheme.unselectedIconColor,
            ),
          ),
        ),
      ],
    );
  }
}
