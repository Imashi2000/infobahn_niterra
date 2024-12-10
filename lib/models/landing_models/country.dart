class Country {
  final int countryId;
  final String country;
  final String phonecode;
  final String currency;

  Country({
    required this.countryId,
    required this.country,
    required this.phonecode,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['countryid'],
      country: json['country'],
      phonecode: json['phonecode'],
      currency: json['currency'],
    );
  }
}