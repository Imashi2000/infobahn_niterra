class PlateNumberByCountry {
  final int vehicleid;
  final String plateno;

  PlateNumberByCountry({
    required this.vehicleid,
    required this.plateno,
  });

  factory PlateNumberByCountry.fromJson(Map<String, dynamic> json) {
    return PlateNumberByCountry(
      vehicleid: json['vehicleid'],
      plateno: json['plateno'],
    );
  }
}
