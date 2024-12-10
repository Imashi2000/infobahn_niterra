class PartNoByProductTypeModel {
  final int productid;
  final String partno;

  PartNoByProductTypeModel({
    required this.productid,
    required this.partno,
  });

  factory PartNoByProductTypeModel.fromJson(Map<String, dynamic> json) {
    return PartNoByProductTypeModel(
      productid: json['productid'],
      partno: json['partno'],
    );
  }
}