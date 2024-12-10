class ProductsByVehicle {
  final int uservehicleid;
  final int userproductid;
  final int userid;
  final String name;
  final String country;
  final String city;
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
  final String expirydate;
  final String claimstatus;

  ProductsByVehicle({
    required this.uservehicleid,
    required this.userproductid,
    required this.userid,
    required this.name,
    required this.country,
    required this.city,
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
    required this.expirydate,
    required this.claimstatus,
  });

  factory ProductsByVehicle.fromJson(Map<String, dynamic> json) {
    return ProductsByVehicle(
      uservehicleid: json['uservehicleid'],
      userproductid: json['userproductid'],
      userid: json['userid'],
      name: json['name'],
      country: json['country'],
      city: json['city'],
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
      expirydate: json['expirydate'],
      claimstatus: json['claimstatus']
    );
  }
  DateTime get parsedExpiryDate {
    try {
      return DateTime.parse(expirydate);
    } catch (_) {
      return DateTime.now(); // Fallback in case of parsing issues
    }
  }
}