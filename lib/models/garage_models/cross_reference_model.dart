class CrossReferenceModel {
  final String ngkNtkPartNo;
  final String productType;
  final String competitor;
  final String competitorPartNo;

  CrossReferenceModel({
    required this.ngkNtkPartNo,
    required this.productType,
    required this.competitor,
    required this.competitorPartNo,
  });

  factory CrossReferenceModel.fromJson(Map<String, dynamic> json) {
    return CrossReferenceModel(
      ngkNtkPartNo: json['ngk_ntk_partno'] ?? '',
      productType: json['product_type'] ?? '',
      competitor: json['competitor'] ?? '',
      competitorPartNo: json['comp_part_no'] ?? '',
    );
  }
}
