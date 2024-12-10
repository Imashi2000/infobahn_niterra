class VehicleManufacturerModel {
  final int vehmakeId;
  final String vehmake;
  final String vehtype;

  VehicleManufacturerModel({
    required this.vehmakeId,
    required this.vehmake,
    required this.vehtype,
  });

  factory VehicleManufacturerModel.fromJson(Map<String, dynamic> json) {
    return VehicleManufacturerModel(
      vehmakeId: json['vehmake_id'],
      vehmake: json['vehmake'],
      vehtype: json['vehtype'],
    );
  }
}
