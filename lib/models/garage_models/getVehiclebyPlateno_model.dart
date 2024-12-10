class VehicleByPlateNo {
  final String vehiclemodel;

  VehicleByPlateNo({required this.vehiclemodel});

  factory VehicleByPlateNo.fromJson(Map<String, dynamic> json) {
    return VehicleByPlateNo(
      vehiclemodel: json['vehiclemodel'] ?? '', // Ensure null safety
    );
  }
}
