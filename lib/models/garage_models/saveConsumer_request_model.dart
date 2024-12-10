class SaveConsumerRequest {
  String action;
  String addedBy;
  String name;
  String surname;
  String contact;
  String email;
  String country;
  String city;
  String address;

  SaveConsumerRequest({
    required this.action,
    required this.addedBy,
    required this.name,
    required this.surname,
    required this.contact,
    required this.email,
    required this.country,
    required this.city,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "action": action,
      "addedby": addedBy,
      "name": name,
      "surname": surname,
      "contact": contact,
      "email": email,
      "country": country,
      "city": city,
      "address": address,
    };
  }
}
