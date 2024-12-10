class EnrollCampaignRequest {
  final String action;
  final String campaignId;
  final String userId;
  final String remark;

  EnrollCampaignRequest({
    required this.action,
    required this.campaignId,
    required this.userId,
    required this.remark,
  });

  // Convert the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'campaignid': campaignId,
      'userid': userId,
      'remark': remark,
    };
  }
}
