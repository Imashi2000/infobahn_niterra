class AllPartNoModel {
  final int productid;
  final String partno;

  AllPartNoModel({
    required this.productid,
    required this.partno,
  });

  factory AllPartNoModel.fromJson(Map<String, dynamic> json) {
    return AllPartNoModel(
      productid: json['productid'],
      partno: json['partno'],
    );
  }
}