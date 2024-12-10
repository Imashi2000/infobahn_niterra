class ConsumerDropdownModel {
  final int consumerid;
  final String name;
  final String surname;
  final String email;

  ConsumerDropdownModel(
      {
        required this.consumerid,
        required this.name,
        required this.surname,
        required this.email,
        });

  factory ConsumerDropdownModel.fromJson(Map<String, dynamic> json) {
    return ConsumerDropdownModel(
        consumerid: json['consumerid'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        );
  }
  String get displayName => '$name $surname ($email)';
}