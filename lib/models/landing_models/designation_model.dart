class Designation {
  final int designationId;
  final String designation;

  Designation({
    required this.designationId,
    required this.designation,
  });

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      designationId: json['designation_id'],
      designation: json['designation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "designation_id": designationId,
      "designation": designation,
    };
  }
}
