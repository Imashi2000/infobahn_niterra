class SaveEnrollCampaignResponse {
  final String status;
  final String message;

  SaveEnrollCampaignResponse({required this.status, required this.message});

  factory SaveEnrollCampaignResponse.fromJson(Map<String, dynamic> json) {
    return SaveEnrollCampaignResponse(
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }
}