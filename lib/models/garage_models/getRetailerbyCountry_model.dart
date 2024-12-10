class RetailerData {
  final int userid;
  final String name;
  final String surname;
  final String disclaimer;

  RetailerData({
    required this.userid,
    required this.name,
    required this.surname,
    required this.disclaimer,
  });

  factory RetailerData.fromJson(Map<String, dynamic> json) {
    return RetailerData(
      userid: json['userid'],
      name: json['name'] as String,
      surname: json['surname'] as String,
      disclaimer: json['disclaimer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid':userid,
      'name': name,
      'surname': surname,
      'disclaimer': disclaimer,
    };
  }
  String get displayRetailerName => '$name $surname';
}