class City{
  final int cityId;
  final String cityName;

  City({
    required this.cityId,
    required this.cityName
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityId: json['city_id'],
      cityName: json['city'],
    );
  }
}