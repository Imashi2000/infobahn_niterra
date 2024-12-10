class SignUpModel{
  final String action;
  final String prefix;
  final String fname;
  final String sname;
  final String userType;
  final String? garageName;
  final String? retailerName;
  final String? designationId;
  final String? designation;
  final String countryReg;
  final String? cityReg;
  final String address;
  final String phone;
  final String email;
  final String password;

  SignUpModel({
    required this.action,
    required this.prefix,
    required this.fname,
    required this.sname,
    required this.userType,
    required this.garageName,
    required this.retailerName,
    this.designationId,
    required this.designation,
    required this.countryReg,
    required this.cityReg,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json){
    return SignUpModel(
      action: json['action'],
        prefix: json['prefix'],
        fname: json['fname'],
        sname: json['sname'],
        userType: json['userType'],
        garageName: json['garageName'],
        retailerName: json['retailerName'],
        designationId: json['designationId']?.toString(),
        designation: json['designation'],
        countryReg: json['countryReg'],
        cityReg: json['cityReg'],
        address: json['address'],
        phone: json['phone'],
        email: json['email'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "prefix": prefix,
      "fname": fname,
      "sname": sname,
      "usertype": userType.toString(),
      "garagename": garageName ?? "",
      "retailername":retailerName,
      "designationid": designationId ?? "",
      "designation": designation ?? "",
      "countryreg": countryReg.toString(),
      "cityreg": cityReg.toString(),
      "address": address,
      "phone": phone,
      "email": email,
      "password": password,
    };
  }
}