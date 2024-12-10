class StaffToAssign {
  final int staffid;
  final String staffname;

  StaffToAssign({
    required this.staffid,
    required this.staffname,
  });

  factory StaffToAssign.fromJson(Map<String, dynamic> json) {
    return StaffToAssign(
      staffid: json['staffid'],
      staffname: json['staffname'],
    );
  }
}
