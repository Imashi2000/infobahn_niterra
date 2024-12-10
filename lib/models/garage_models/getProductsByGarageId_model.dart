class ProductsByGarageId {
  final int uservehicleid;
  final int userproductid;
  final int userid;
  final String name;
  final String email;
  final String phone;
  final String plateno;
  final String vehiclemodel;
  final String producttype;
  final String partno;
  final int quantity;
  final String installdate;
  final String nextreplacement;
  final String expirydate;
  final String claimstatus;

  ProductsByGarageId({
    required this.uservehicleid,
    required this.userproductid,
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.plateno,
    required this.vehiclemodel,
    required this.producttype,
    required this.partno,
    required this.quantity,
    required this.installdate,
    required this.nextreplacement,
    required this.expirydate,
    required this.claimstatus,
  });

  factory ProductsByGarageId.fromJson(Map<String, dynamic> json) {
    return ProductsByGarageId(
        uservehicleid: json['uservehicleid'],
        userproductid: json['userproductid'],
        userid: json['userid'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        plateno: json['plateno'],
        vehiclemodel: json['vehiclemodel'],
        producttype: json['producttype'],
        partno: json['partno'],
        quantity: json['quantity'],
        installdate: json['installdate'],
        nextreplacement: json['nextreplacement'],
        expirydate: json['expirydate'],
        claimstatus: json['claimstatus']);
  }
  DateTime get parsedExpiryDate {
    try {
      return DateTime.parse(expirydate);
    } catch (_) {
      return DateTime.now(); // Fallback in case of parsing issues
    }
  }
}
