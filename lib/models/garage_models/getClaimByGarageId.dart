class ClaimByGarage {
  int userVehicleId;
  int claimId;
  int userId;
  String name;
  String phone;
  String plateNo;
  String vehicleModel;
  String productType;
  String partNo;
  String expiryDate;
  String? diagnosis;
  String claimUniqueId;
  String claimDate;
  int quantityClaim;
  int claimStatus;
  int resubmitStatus;
  dynamic deliveryStatus;

  ClaimByGarage({
    required this.userVehicleId,
    required this.claimId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.plateNo,
    required this.vehicleModel,
    required this.productType,
    required this.partNo,
    required this.expiryDate,
    this.diagnosis,
    required this.claimUniqueId,
    required this.claimDate,
    required this.quantityClaim,
    required this.claimStatus,
    required this.resubmitStatus,
    required this.deliveryStatus,
  });

  factory ClaimByGarage.fromJson(Map<String, dynamic> json) {
    return ClaimByGarage(
      userVehicleId: json['uservehicleid'],
      claimId: json['claimid'],
      userId: json['userid'],
      name: json['name'],
      phone: json['phone'],
      plateNo: json['plateno'],
      vehicleModel: json['vehiclemodel'],
      productType: json['producttype'],
      partNo: json['partno'],
      expiryDate: json['expirydate'],
      diagnosis: json['diagnosis'],
      claimUniqueId: json['claimuniqueid'],
      claimDate: json['claimdate'],
      quantityClaim: json['quantityclaim'],
      claimStatus: json['claimstatus'],
      resubmitStatus: json['resubmitstatus'],
      deliveryStatus: json['deliverystatus'] is int
          ? json['deliverystatus']
          : json['deliverystatus'].toString(),
    );
  }
}
