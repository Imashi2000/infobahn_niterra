class ProductTypeModel {
  final int pdttypeid;
  final String pdttype;

  ProductTypeModel({
    required this.pdttypeid,
    required this.pdttype,
  });

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      pdttypeid: json['pdttypeid'],
      pdttype: json['pdttype'],
    );
  }
}