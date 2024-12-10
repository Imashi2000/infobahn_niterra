class SaveClaimRequest {
  String action;
  int vehicleId;
  int productId;
  int claimQty;
  int diagnosis;
  int odometer;
  int garageId;
  int confirmStatus;
  //List<String> images;

  SaveClaimRequest({
    required this.action,
    required this.vehicleId,
    required this.productId,
    required this.claimQty,
    required this.diagnosis,
    required this.odometer,
    required this.garageId,
    required this.confirmStatus,
   // required this.images,
  });

  Map<String, dynamic> toJson() => {
    "action": action,
    "vehicleid": vehicleId,
    "productid": productId,
    "claimqty": claimQty,
    "diagnosis": diagnosis,
    "odometer": odometer,
    "garageid": garageId,
    "confirmstatus": confirmStatus,
    //"images": images,
  };
}
