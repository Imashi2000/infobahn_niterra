class ClaimDetailsByClaimId {
  final int claimId;
  final String plateNo;
  final String vehicleModel;
  final String vinNo;
  final String engineCode;
  final int odometerVehicle;
  final String annualMileage;
  final String vinImg;
  final String productType;
  final String partNo;
  final String expiryDate;
  final int odometerProduct;
  final String productImg;
  final String invoiceImg;
  final String diagnosis;
  final String claimUniqueId;
  final int odometerClaim;
  final String claimDate;
  final int quantityClaim;
  final List<String> claimImages;
  final String claimStatus;

  ClaimDetailsByClaimId({
    required this.claimId,
    required this.plateNo,
    required this.vehicleModel,
    required this.vinNo,
    required this.engineCode,
    required this.odometerVehicle,
    required this.annualMileage,
    required this.vinImg,
    required this.productType,
    required this.partNo,
    required this.expiryDate,
    required this.odometerProduct,
    required this.productImg,
    required this.invoiceImg,
    required this.diagnosis,
    required this.claimUniqueId,
    required this.odometerClaim,
    required this.claimDate,
    required this.quantityClaim,
    required this.claimImages,
    required this.claimStatus,
  });

  factory ClaimDetailsByClaimId.fromJson(Map<String, dynamic> json) {
    return ClaimDetailsByClaimId(
      claimId: json['claimid'],
      plateNo: json['plateno'],
      vehicleModel: json['vehiclemodel'],
      vinNo: json['vinno'],
      engineCode: json['enginecode'],
      odometerVehicle: json['odometervehicle'],
      annualMileage: json['annualmileage'],
      vinImg: json['vinimg'],
      productType: json['producttype'],
      partNo: json['partno'],
      expiryDate: json['expirydate'],
      odometerProduct: json['odomterproduct'],
      productImg: json['productimg'],
      invoiceImg: json['invoiceimg'],
      diagnosis: json['diagnosis'],
      claimUniqueId: json['claimuniqueid'],
      odometerClaim: json['odometerclaim'],
      claimDate: json['claimdate'],
      quantityClaim: json['quantityclaim'],
      claimImages: List<String>.from(json['claimimage'] ?? []),
      claimStatus: json['claimstatus'],
    );
  }
}
