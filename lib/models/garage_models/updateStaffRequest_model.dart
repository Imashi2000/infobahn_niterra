class UpdateStaffRequestModel {
  final String staffName;
  final String staffEmail;
  final String staffPhone;
  final int designationId;
  final int staffId;
  final int userid;

  UpdateStaffRequestModel({
    required this.staffName,
    required this.staffEmail,
    required this.staffPhone,
    required this.designationId,
    required this.staffId,
    required this.userid,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": "updateStaff",
      "staffname": staffName,
      "staffemail": staffEmail,
      "staffphone": staffPhone,
      "designationid": designationId.toString(),
      "staffid": staffId.toString(),
      "userid": userid.toString(),
    };
  }
}
