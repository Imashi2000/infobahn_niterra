class BrandModel {
  final int brandid;
  final String brand;

  BrandModel({
    required this.brandid,
    required this.brand,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandid: json['brandid'],
      brand: json['brand'],
    );
  }
}