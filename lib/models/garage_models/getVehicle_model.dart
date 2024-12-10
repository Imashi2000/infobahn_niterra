class VehicleModel {
  final int vehtype_id;
  final String vehtype;

  VehicleModel({
    required this.vehtype_id,
    required this.vehtype,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
        vehtype_id: json['vehtype_id'],
        vehtype: json['vehtype'],

    );
  }
}