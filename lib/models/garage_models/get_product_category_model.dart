class ProductCategoryModel {
  final int pdtcategoryid;
  final String pdtcategory;
  final String disclaimer;

  ProductCategoryModel({
    required this.pdtcategoryid,
    required this.pdtcategory,
    required this.disclaimer
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      pdtcategoryid: json['pdtcategoryid'],
      pdtcategory: json['pdtcategory'],
      disclaimer: json['disclaimer']
    );
  }
}