class ModelTypes {
  final int? vehmodel_id; // Make this nullable to handle missing values
  final String vehmodel;
  final String? vehmake;
  final String? vehtype;

  ModelTypes({
    this.vehmodel_id,
    required this.vehmodel,
    this.vehmake,
    this.vehtype,
  });

  factory ModelTypes.fromJson(Map<String, dynamic> json) {
    return ModelTypes(
      vehmodel_id: json['vehmodel_id'], // This can be null
      vehmodel: json['vehmodel'] ?? '', // Default to an empty string if null
      vehmake: json['vehmake'],
      vehtype: json['vehtype'],
    );
  }
}
