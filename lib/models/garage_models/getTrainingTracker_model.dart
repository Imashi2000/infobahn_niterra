class TrainingTracker {
  final int staffId;
  final String staffName;
  final String staffEmail;
  final String staffPhone;
  final String trainingName;
  final String trainingDate;
  final String trainingTime;
  final String trainingStatus;
  final String certificateStatus;

  TrainingTracker({
    required this.staffId,
    required this.staffName,
    required this.staffEmail,
    required this.staffPhone,
    required this.trainingName,
    required this.trainingDate,
    required this.trainingTime,
    required this.trainingStatus,
    required this.certificateStatus,
  });

  factory TrainingTracker.fromJson(Map<String, dynamic> json) {
    return TrainingTracker(
      staffId: json['staffid'],
      staffName: json['staffname'],
      staffEmail: json['staffemail'],
      staffPhone: json['staffphone'],
      trainingName: json['trainingname'],
      trainingDate: json['trainingdate'],
      trainingTime: json['trainingtime'],
      trainingStatus: json['trainingstatus'],
      certificateStatus: json['certificatestatus'],
    );
  }
}
