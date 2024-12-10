import 'dart:io';

class SaveProductRequest {
  final String action;
  final String vehicleId;
  final String productId;
  final String productTypeId;
  final String? productSubId;
  final String partNoQty;
  final String purchasePlace;
  final String otherRetailer;
  final File? productImg;
  final File? invoiceImg;
  final String odometer;
  final String garageId;

  SaveProductRequest({
    required this.action,
    required this.vehicleId,
    required this.productId,
    required this.productTypeId,
    required this.productSubId,
    required this.partNoQty,
    required this.purchasePlace,
    required this.otherRetailer,
    required this.productImg,
    required this.invoiceImg,
    required this.odometer,
    required this.garageId,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "vehicleid": vehicleId,
      "productid": productId,
      "producttypeid": productTypeId,
      "productsubid": productSubId,
      "partnoqty": partNoQty,
      "purchaseplace": purchasePlace,
      "otheretailer": otherRetailer,
      "productimg": productImg,
      "invoiceimg": invoiceImg,
      "odometer": odometer,
      "garageid": garageId,
    };
  }
}
