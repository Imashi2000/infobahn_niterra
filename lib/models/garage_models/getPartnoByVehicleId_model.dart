class PartNoByVehicle {
  final int userproductid;
  final int productid;
  final String partno;
  final String vehiclemodel;

  PartNoByVehicle({
    required this.userproductid,
    required this.productid,
    required this.partno,
    required this.vehiclemodel,
  });

  factory PartNoByVehicle.fromJson(Map<String, dynamic> json) {
    return PartNoByVehicle(
        userproductid: json['userproductid'],
        productid: json['productid'],
        partno: json['partno'],
        vehiclemodel: json['vehiclemodel'],
    );
  }
}
