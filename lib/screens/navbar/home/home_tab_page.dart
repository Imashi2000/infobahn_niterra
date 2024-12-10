import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:niterra/common/styles/colors.dart';
import 'package:niterra/common/styles/font_styles.dart';
import 'package:niterra/common/styles/spacing.dart';
import 'package:niterra/common/widgets/landing_app_bar.dart';
import 'package:niterra/models/landing_models/auth_models/user_preferences.dart';
import 'package:niterra/models/landing_models/location_model.dart';
import 'package:niterra/screens/garage/dashboard_page.dart';
import 'package:niterra/screens/navbar/our_product_pages/ignition_parts_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/no_content_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_garage_page.dart';
import 'package:niterra/screens/navbar/our_product_pages/vehical_electronics_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_qa_page.dart';
import 'package:niterra/screens/navbar/trusted_pages/trusted_retailer_tab_page.dart';
import 'package:niterra/services/landing_services/homepage_services.dart';
import 'package:niterra/utils/size.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'dart:io';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final HomePageService _homePageService = HomePageService();
  final CarouselSliderController _carouselController = CarouselSliderController();
  final Map<String, Marker> _markers = {};
  late GoogleMapController mapController;
 // LatLng? _userLocation;
  List<LocationInfo> locations = [];
  int _currentIndex = 0;
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

  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/images/garage.png',
      'name': 'Trusted \nGarage',
      'screen': const TrustedGaragePage(),
    },
    {
      'image': 'assets/images/retailer.png',
      'name': 'Trusted \nRetailer',
      'screen': const TrustedRetailerTabPage(),
    },
    {
      'image': 'assets/images/tqa.png',
      'name': 'TQA',
      'screen': TrustedQaPage(),
    },
  ];

  final List<Map<String, dynamic>> productItems = [
    {
      'image': 'assets/images/ignition.png',
      'name': 'Ignition \nParts',
      'screen': IgnitionPartsPage()
    },
    {
      'image': 'assets/images/vehicle.png',
      'name': 'Vehicle \nElectronics',
      'screen': VehicalElectronicsPage()
    },
  ];

  final List<String> _imagePaths = [
    'assets/images/sliderTqa.png',
    'assets/images/sliderTqa.png',
    'assets/images/sliderTqa.png',
  ];

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
  //
  // Future<void> _getUserLocation() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Location services are disabled.')),
  //       );
  //       return;
  //     }
  //
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied.')),
  //         );
  //         return;
  //       }
  //     }
  //
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //
  //     setState(() {
  //       _userLocation = LatLng(position.latitude, position.longitude);
  //     });
  //   } catch (e) {
  //     print('Error getting user location: $e');
  //   }
  // }

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
    return SafeArea(
      child: Scaffold(
        appBar: LandingAppBar(
          leadingImage: 'assets/images/tp.png',
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getResponsiveWidth(
                    context: context,
                    portionWidthValue: AppSpace.bodyPadding)), // Padding for body
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 12.0),
                ),
                const Text(
                  'Trusted Program',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: BaseColorTheme.headingTextColor,
                      fontWeight: BaseFontWeights.medium),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 10.0),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: items.map((item) {
                      return InkWell(
                        onTap: () {
                          Get.to(item['screen']!);
                        },
                        child: Container(
                          height: ScreenUtils.getResponsiveHeight(
                              context: context, portionHeightValue: 80.0),
                          width: ScreenUtils.getResponsiveWidth(
                              context: context, portionWidthValue: 120.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Space between items
                          padding: const EdgeInsets.all(
                              8.0), // Padding within each item
                          decoration: BoxDecoration(
                            color: BaseColorTheme
                                .bgGrayColor, // Background color of each item
                            borderRadius:
                                BorderRadius.circular(15.0), // Rounded corners
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                item['image']!,
                                height: 40.0, // Image height
                                width: 40.0, // Image width
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                  width: 8.0), // Space between image and text
                              Text(
                                item['name']!,
                                style: const TextStyle(
                                  fontSize: 14.0, // Font size for item name
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 7.0),
                ),
                const Text(
                  'Our Products',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: BaseColorTheme.headingTextColor,
                      fontWeight: BaseFontWeights.medium),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 10.0),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: productItems.map((item) {
                      return InkWell(
                        onTap: () {
                          Get.to(item['screen']);
                        },
                        child: Container(
                          height: ScreenUtils.getResponsiveHeight(
                              context: context, portionHeightValue: 80.0),
                          width: ScreenUtils.getResponsiveWidth(
                              context: context, portionWidthValue: 172.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Space between items
                          padding: const EdgeInsets.all(
                              8.0), // Padding within each item
                          decoration: BoxDecoration(
                            color: BaseColorTheme
                                .bgGrayColor, // Background color of each item
                            borderRadius:
                                BorderRadius.circular(15.0), // Rounded corners
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                item['image']!,
                                height: 40.0, // Image height
                                width: 40.0, // Image width
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                  width: 8.0), // Space between image and text
                              Text(
                                item['name']!,
                                style: const TextStyle(
                                  fontSize: 14.0, // Font size for item name
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 22.0),
                ),
                const Text('Take advantage of our exclusive deals!',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: BaseFontWeights.medium,
                        color: BaseColorTheme.unselectedIconColor)),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 4.0),
                ),
                Container(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 139.0),
                  width: double.infinity,
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: _imagePaths.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 8.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _imagePaths.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: Container(
                        width: ScreenUtils.getResponsiveWidth(
                            context: context, portionWidthValue: 8.0),
                        height: ScreenUtils.getResponsiveHeight(
                            context: context, portionHeightValue: 8.0),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? BaseColorTheme.blackColor
                              : BaseColorTheme.iconGrayColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: ScreenUtils.getResponsiveHeight(
                      context: context, portionHeightValue: 42.44),
                ),
                Container(
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
              ],
            )),
      ),
    );
  }

  // addMarker(String id, LatLng location) async {
  //   var markerIcon = await BitmapDescriptor.asset(
  //       const ImageConfiguration(), 'assets/images/tp.png');
  //   var marker = Marker(
  //       markerId: MarkerId((id)),
  //       position: location,
  //       infoWindow: const InfoWindow(title: 'Garage name', snippet: 'get Directions'),
  //       icon: markerIcon);
  //   _markers[id] = marker;
  //   setState(() {});
  // }
}