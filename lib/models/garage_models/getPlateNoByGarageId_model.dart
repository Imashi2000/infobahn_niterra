class PlateNumberByGarage {
  final int vehicleId;
  final String plateNo;

  PlateNumberByGarage({
    required this.vehicleId,
    required this.plateNo,
  });

  factory PlateNumberByGarage.fromJson(Map<String, dynamic> json) {
    return PlateNumberByGarage(
      vehicleId: json['vehicleid'],
      plateNo: json['plateno'],
    );
  }
}
