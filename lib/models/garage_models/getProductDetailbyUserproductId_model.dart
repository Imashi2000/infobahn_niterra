import 'dart:convert';

class ProductDetail {
  final String productType;
  final String installDate;
  final String expiryDate;
  final int partNoQty;

  ProductDetail({
    required this.productType,
    required this.installDate,
    required this.expiryDate,
    required this.partNoQty,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productType: json['producttype'] ?? '',
      installDate: json['installdate'] ?? '',
      expiryDate: json['expirydate'] ?? '',
      partNoQty: json['partnoqty'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'producttype': productType,
    'installdate': installDate,
    'expirydate': expiryDate,
    'partnoqty': partNoQty,
  };
}

class Diagnosis {
  final int diagnosisId;
  final String diagnosis;

  Diagnosis({
    required this.diagnosisId,
    required this.diagnosis,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      diagnosisId: json['diagnosisid'] ?? 0,
      diagnosis: json['diagnosis'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'diagnosisid': diagnosisId,
    'diagnosis': diagnosis,
  };
}

class SampleImage {
  final String sampleImg;

  SampleImage({
    required this.sampleImg,
  });

  factory SampleImage.fromJson(Map<String, dynamic> json) {
    return SampleImage(
      sampleImg: json['sampleimg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sampleimg': sampleImg,
  };
}

class ClaimResponse {
  final ProductDetail productDetail;
  final List<Diagnosis> diagnosis;
  final List<SampleImage> sampleImages;
  final String disclaimer;

  ClaimResponse({
    required this.productDetail,
    required this.diagnosis,
    required this.sampleImages,
    required this.disclaimer,
  });

  factory ClaimResponse.fromJson(Map<String, dynamic> json) {
    return ClaimResponse(
      productDetail: ProductDetail.fromJson(json['productdetail'] ?? {}),
      diagnosis: (json['diagnosis'] as List<dynamic>? ?? [])
          .map((item) => Diagnosis.fromJson(item))
          .toList(),
      sampleImages: (json['sampleimg'] as List<dynamic>? ?? [])
          .map((item) => SampleImage.fromJson(item))
          .toList(),
      disclaimer: json['disclaimer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'productdetail': productDetail.toJson(),
    'diagnosis': diagnosis.map((item) => item.toJson()).toList(),
    'sampleimg': sampleImages.map((item) => item.toJson()).toList(),
    'disclaimer': disclaimer,
  };
}

// For parsing JSON strings
ClaimResponse claimResponseFromJson(String str) =>
    ClaimResponse.fromJson(json.decode(str));

String claimResponseToJson(ClaimResponse data) => json.encode(data.toJson());
