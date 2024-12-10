class TrainingByUserType {
  final int trainingId;
  final String trainingName;
  final String trainingDate;
  final String trainingTime;
  final String country;
  final String city;
  final String venue;
  final int assignStatus;

  TrainingByUserType({
    required this.trainingId,
    required this.trainingName,
    required this.trainingDate,
    required this.trainingTime,
    required this.country,
    required this.city,
    required this.venue,
    required this.assignStatus,
  });

  factory TrainingByUserType.fromJson(Map<String, dynamic> json) {
    return TrainingByUserType(
      trainingId: json['trainingid'],
      trainingName: json['trainingname'],
      trainingDate: json['trainingdate'],
      trainingTime: json['trainingtime'],
      country: json['country'],
      city: json['city'],
      venue: json['venue'],
      assignStatus: json['assignstatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainingid': trainingId,
      'trainingname': trainingName,
      'trainingdate': trainingDate,
      'trainingtime': trainingTime,
      'country': country,
      'city': city,
      'venue': venue,
      'assignstatus': assignStatus,
    };
  }
}
