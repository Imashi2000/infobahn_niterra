class ConsumerbyCountryModel {
  final int consumerid;
  final String name;
  final String surname;
  final int countryid;
  final String country;
  final int cityid;
  final String city;
  final String address;
  final String phone;
  final String email;
  final String cstatus;

  ConsumerbyCountryModel(
      {required this.consumerid,
      required this.name,
      required this.surname,
      required this.countryid,
      required this.country,
      required this.cityid,
      required this.city,
      required this.email,
      required this.address,
      required this.phone,
      required this.cstatus});

  factory ConsumerbyCountryModel.fromJson(Map<String, dynamic> json) {
    return ConsumerbyCountryModel(
        consumerid: json['consumerid'],
        name: json['name'],
        surname: json['surname'],
        countryid: json['countryid'],
        country: json['country'],
        cityid: json['cityid'],
        city: json['city'],
        address: json['address'],
        email: json['email'],
        phone: json['phone'],
        cstatus: json['cstatus']
    );
  }
  String get fullName => '$name $surname';
}
