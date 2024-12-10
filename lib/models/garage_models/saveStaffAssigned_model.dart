class AssignTrainingRequest {
  final String action;
  final List<int> staffIds;
  final String trainingId;
  final String userId;

  AssignTrainingRequest({
    required this.action,
    required this.staffIds,
    required this.trainingId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "staffids": staffIds,
      "trainingid": trainingId,
      "userid": userId,
    };
  }
}
