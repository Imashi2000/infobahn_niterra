class StaffAssigned {
  final int staffid;
  final String staffname;

  StaffAssigned({
    required this.staffid,
    required this.staffname,
  });

  factory StaffAssigned.fromJson(Map<String, dynamic> json) {
    return StaffAssigned(
      staffid: json['staffid'],
      staffname: json['staffname'],
    );
  }
}
