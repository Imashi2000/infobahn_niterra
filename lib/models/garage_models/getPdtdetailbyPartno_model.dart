class ProductDetailsByPartNo {
  final String brand;
  final int brandid;
  final String pdtcategory;
  final int pdtcategoryid;
  final String pdttype;
  final int pdttypeid;
  final String disclaimer;

  ProductDetailsByPartNo({
    required this.brand,
    required this.brandid,
    required this.pdtcategoryid,
    required this.pdttype,
    required this.pdttypeid,
    required this.pdtcategory,
    required this.disclaimer,
  });

  factory ProductDetailsByPartNo.fromJson(Map<String, dynamic> json) {
    return ProductDetailsByPartNo(
      brand: json['brand'],
      brandid: json['brandid'],
      pdtcategory: json['pdtcategory'] as String,
      pdtcategoryid: json['pdtcategoryid'] as int,
      pdttype: json['pdttype'],
      pdttypeid: json['pdttypeid'],
      disclaimer: json['disclaimer']
    );
  }
}
