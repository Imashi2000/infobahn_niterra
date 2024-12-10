import 'dart:convert';

class ProductDetails {
  final int uservehicleid;
  final int userproductid;
  final int userid;
  final String name;
  final String email;
  final String phone;
  final String plateno;
  final String enginecode;
  final int odometer;
  final String mileage;
  final String vinno;
  final String vehiclemodel;
  final String producttype;
  final String partno;
  final int quantity;
  final String productimg;
  final String invoiceimg;
  final String installdate;
  final String nextreplacement;
  final int odometerproduct;

  ProductDetails({
    required this.uservehicleid,
    required this.userproductid,
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.plateno,
    required this.enginecode,
    required this.odometer,
    required this.mileage,
    required this.vinno,
    required this.vehiclemodel,
    required this.producttype,
    required this.partno,
    required this.quantity,
    required this.productimg,
    required this.invoiceimg,
    required this.installdate,
    required this.nextreplacement,
    required this.odometerproduct,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      uservehicleid: json['uservehicleid'],
      userproductid: json['userproductid'],
      userid: json['userid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      plateno: json['plateno'],
      enginecode: json['enginecode'],
      odometer: json['odometer'],
      mileage: json['mileage'],
      vinno: json['vinno'],
      vehiclemodel: json['vehiclemodel'],
      producttype: json['producttype'],
      partno: json['partno'],
      quantity: json['quantity'],
      productimg: json['productimg'],
      invoiceimg: json['invoiceimg'],
      installdate: json['installdate'],
      nextreplacement: json['nextreplacement'],
      odometerproduct: json['odometerproduct'],
    );
  }

  static List<ProductDetails> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductDetails.fromJson(json)).toList();
  }
}
