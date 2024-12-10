import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/widgets/bottom_navbar.dart';
import 'package:niterra/common/widgets/garage_app_bar.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/models/landing_models/location_model.dart';
import 'package:niterra/screens/garage/tqa_feature/consumer_screens/consumer_list_table.dart';
import 'package:niterra/screens/garage/cross_reference_screens/cross_reference_page.dart';
import 'package:niterra/screens/garage/tqa_feature/veihicle_product_screens/vehicle_list_page.dart';
import 'package:niterra/services/landing_services/homepage_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:niterra/common/widgets/navigation_drawer.dart';
import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class GarageDashboardScreen extends StatefulWidget {
  GarageDashboardScreen({super.key});

  @override
  State<GarageDashboardScreen> createState() => _GarageDashboardScreenState();
}

class _GarageDashboardScreenState extends State<GarageDashboardScreen> {
  final HomePageService _homePageService = HomePageService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, Marker> _markers = {};
  late GoogleMapController mapController;
  List<LocationInfo> locations = [];
  int? loggedCountryId;
  int? cityId;
  LatLng _initialPosition = const LatLng(24.9650014, 55.0787874);

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loggedCountryId !=null && cityId !=null) {
      _fetchLocations();
    }
  }

  final Map<String, String> socialLinks = {
    'facebook': 'https://www.facebook.com/sharer/sharer.php?u=https://trustedprog.com/trusted-partner.php?country=JP',
    'linkedin': 'https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww.linkedin.com%2FshareArticle%3Fmini%3Dtrue%26url%3Dhttps%3A%2F%2Ftrustedprog.com%2Ftrusted-partner.php%3Fcountry%3DJP',
    'instagram': 'https://www.instagram.com/ngkntkme/',
    'youtube': 'https://www.youtube.com/channel/UCEjpJys5OICSIKeIXK5fWxw',
    'email': 'info@trustedprog.com',
  };

  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/images/reference.png',
      'name': 'Cross \nReference',
      'screen': CrossReferenceScreen(),
      'color': const Color(0xFFCDE8DD)
    },
    {
      'image': 'assets/images/request.png',
      'name': 'Consumers \nRegistration',
      'screen': ConsumerRequestsScreen(),
      'color': const Color(0xFFA7E8E8)
    },
    {
      'image': 'assets/images/registration.png',
      'name': 'Product \nRegistration',
      'screen': VehicleListPage(),
      'color': const Color(0xFFFFD0CF)
    },
  ];

  BottomBarEnum selectedPage = BottomBarEnum.Home;

  Future<void> _initializeUserData() async {
    try {
      // Retrieve user details from SharedPreferences
      final userDetails = await UserPreferences.getUserDetails();
      print("User Details: $userDetails"); // Debug log for userDetails

      setState(() {
        loggedCountryId = int.tryParse(userDetails['countryId'] ?? '0');
        cityId = int.tryParse(userDetails['cityId'] ?? '0');
      });

      print("Logged CountryId: $loggedCountryId,Logged cityId: $cityId");
      if (loggedCountryId !=null && cityId !=null) {
        await _fetchLocations();
      }
    } catch (e) {
      print('Error in _initializeUserData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving user details: $e')),
      );
    }
  }

  Future<void> _fetchLocations() async {
    try {
      final fetchedLocations = await _homePageService.fetchLocations(loggedCountryId.toString(),cityId.toString());
      setState(() {
        locations = fetchedLocations;
      });

      for (var location in fetchedLocations) {
        _addMarker(location);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching locations: $e')),
      );
    }
  }

  Future<void> _addMarker(LocationInfo location) async {
    BitmapDescriptor markerIcon;

    try {
      // Fetch the icon from a network URL
      if (location.icon.isNotEmpty) {
        final Uint8List markerBytes = await _downloadMarkerIcon(location.icon);
        markerIcon = BitmapDescriptor.fromBytes(markerBytes); // Correct usage
      } else {
        markerIcon = BitmapDescriptor.defaultMarker; // Use default marker
      }

      final marker = Marker(
        markerId: MarkerId(location.compName),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.compName,
          snippet: '${location.address}\nPhone: ${location.phone}',
          onTap: () {
            _showLocationPopup(location);
          },
        ),
        icon: markerIcon,
      );

      setState(() {
        _markers[location.compName] = marker;
      });
    } catch (e) {
      print("Error adding marker: $e");
    }
  }

  /// Download Marker Icon from Network
  Future<Uint8List> _downloadMarkerIcon(String url) async {
    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      return bytes;
    } else {
      throw Exception('Failed to download marker icon from $url');
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
  /// Show Popup on Marker Tap
  void _showLocationPopup(LocationInfo location) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(location.compName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Address: ${location.address}'),
              Text('Phone: ${location.phone}'),
              Text('Type: ${location.userType}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BaseColorTheme.whiteTextColor,
      appBar: GarageAppBar(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const NavigationDrawerScreen(),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.symmetric(
      //       vertical: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 12.0),
      //       horizontal: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 12.0)
      //   ),
      //   child: BottomBar(
      //     onChanged: (BottomBarEnum type) {
      //       Get.to(HomePage());
      //     }, // Pass selectedPage for active tab indication
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(
                  context: context, portionHeightValue: 8.0),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
              ),
              child: const Text(
                'DASHBOARD',
                style: TextStyle(
                    color: BaseColorTheme.headingTextColor,
                    fontSize: 22.0,
                    fontWeight: BaseFontWeights.semiBold),
              ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(
                  context: context, portionHeightValue: 26.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: ScreenUtils.getResponsiveHeight(
                    context: context, portionHeightValue: 193),
                width: ScreenUtils.getResponsiveWidth(
                    context: context, portionWidthValue: 358),
                child:GoogleMap(

                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15.0,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: _markers.values.toSet(),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(
                  context: context, portionHeightValue: 12.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
              ),
              child: const Align(
                alignment: Alignment.centerRight,
                // child: Text(
                //   'See all',
                //   style: TextStyle(
                //       color: BaseColorTheme.seeAllTextColor,
                //       fontSize: 15.0,
                //       fontWeight: BaseFontWeights.semiBold),
                // ),
              ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 18.0),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
                ),
                child: Row(
                  children: items.map((item) {
                    return InkWell(
                      onTap: (){
                        Get.to(item['screen']!);
                      },
                      child: Container(
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 157.0),
                        width: ScreenUtils.getResponsiveWidth(
                            context: context, portionWidthValue: 142.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4.0), // Space between items
                        decoration: BoxDecoration(
                          color: item['color']!, // Background color of each item
                          borderRadius:
                              BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['name']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: BaseFontWeights.semiBold,
                                  color: BaseColorTheme.unselectedIconColor),
                            ),
                            Image.asset(
                              item['image']!,
                              height: 78.0, // Image height
                              width: 78.0, // Image width
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                                width: 8.0), // Space between image and text
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(
                  context: context, portionHeightValue: 13.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Products',
                    style: TextStyle(
                        color: BaseColorTheme.headingTextColor,
                        fontSize: 18.0,
                        fontWeight: BaseFontWeights.medium),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                        color: BaseColorTheme.seeAllTextColor,
                        fontSize: 15.0,
                        fontWeight: BaseFontWeights.semiBold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(
                  context: context, portionHeightValue: 9.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
              ),
              child: Container(
                height: ScreenUtils.getResponsiveHeight(
                    context: context, portionHeightValue: 100.0),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: BaseColorTheme.bgGrayColor, // Background color of each item
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/product.png',
                            height: 68.0, // Image height
                            width: 101.0, // Image width
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 8.0),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Product Name or Code',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: BaseFontWeights.semiBold,
                                    color: BaseColorTheme.cardTextColor
                                ),
                              ),
                              Text(
                                'Brand name',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: BaseFontWeights.medium,
                                    color: BaseColorTheme.unselectedIconColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 28.0,
                        height: 28.0,
                        decoration: const BoxDecoration(
                          color: Colors.white, // Optional: Background color for the container
                          shape: BoxShape.circle, // Makes the container circular
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 114, 151, 0.25),
                              offset: Offset(0, 4.48),
                              blurRadius: 4.48,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.favorite_border,
                            color: BaseColorTheme.yellowLineColor,
                            size: 18.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(
                  context: context, portionHeightValue: 29.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getResponsiveWidth(context: context, portionWidthValue: 17.0)
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: BaseColorTheme.bgGrayColor, // Background color of each item
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Connect with us',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: BaseFontWeights.medium,
                        color: BaseColorTheme.headingTextColor
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 20.0),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Facebook Icon
                    GestureDetector(
                      onTap: () => _launchURL(socialLinks['facebook']!),
                      child: Image.asset(
                        'assets/images/facebook.png',
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // LinkedIn Icon
                    GestureDetector(
                      onTap: () => _launchURL(socialLinks['linkedin']!),
                      child: Image.asset(
                        'assets/images/linkedin.png',
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Instagram Icon
                    GestureDetector(
                      onTap: () => _launchURL(socialLinks['instagram']!),
                      child: Image.asset(
                        'assets/images/instagram.png',
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // YouTube Icon
                    GestureDetector(
                      onTap: () => _launchURL(socialLinks['youtube']!),
                      child: Image.asset(
                        'assets/images/video.png',
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Email Icon
                    GestureDetector(
                      onTap: () => _launchURL(socialLinks['email']!),
                      child: Image.asset(
                        'assets/images/email.png',
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                    SizedBox(
                      height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 25.0),
                    )
              ],
                ),

            ),
            ),
            SizedBox(
              height: ScreenUtils.getResponsiveHeight(context: context, portionHeightValue: 50.0),
            )
          ],
        ),
      ),
    );
  }
}
