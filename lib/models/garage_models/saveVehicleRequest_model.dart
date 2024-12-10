class SaveVehicleRequest {
  final String action;
  final String userId;
  final int consumerId;
  final String? vehMake;
  final String vehModelId;
  final String? otherModel;
  final String modelYear;
  final String plateNo;
  final String engineCode;
  final int odometer;
  final int mileage;
  final String vinNo;

  SaveVehicleRequest({
    this.action = "saveVehicle",
    required this.userId,
    required this.consumerId,
    required this.vehMake,
    required this.vehModelId,
    required this.otherModel,
    required this.modelYear,
    required this.plateNo,
    required this.engineCode,
    required this.odometer,
    required this.mileage,
    required this.vinNo,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "userid": userId,
      "consumerid": consumerId,
      "vehmake": vehMake,
      "vehmodelid": vehModelId,
      "othermodel": otherModel,
      "modelyr": modelYear,
      "plateno": plateNo,
      "enginecode": engineCode,
      "odometer": odometer,
      "mileage": mileage,
      "vinno": vinNo,
    };
  }
}