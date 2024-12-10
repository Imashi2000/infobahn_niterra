class ProductTypeSubModel {
  final int protypesubid;
  final String protypesub;

  ProductTypeSubModel({
    required this.protypesubid,
    required this.protypesub,
  });

  factory ProductTypeSubModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeSubModel(
      protypesubid: json['protypesubid'],
      protypesub: json['protypesub'],
    );
  }
}