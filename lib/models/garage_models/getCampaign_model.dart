class Campaign {
  final int campaignId;
  final String campaignName;
  final String startDate;
  final String endDate;
  final String status;

  Campaign({
    required this.campaignId,
    required this.campaignName,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      campaignId: json['campaignid'],
      campaignName: json['campaignname'],
      startDate: json['startdate'],
      endDate: json['enddate'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campaignid': campaignId,
      'campaignname': campaignName,
      'startdate': startDate,
      'enddate': endDate,
      'status': status,
    };
  }
}
