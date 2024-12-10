class LocationInfo {
  final String compName;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String userType;
  final String icon;

  LocationInfo({
    required this.compName,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.userType,
    required this.icon,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      compName: json['compname'],
      address: json['address'],
      phone: json['phone'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      userType: json['usertype'],
      icon: json['icon'],
    );
  }
}
