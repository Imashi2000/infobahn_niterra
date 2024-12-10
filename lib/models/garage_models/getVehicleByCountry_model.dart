class VehicleByCountry {
  final int uservehicleid;
  final int userid;
  final String name;
  final String surname;
  final String country;
  final String city;
  final String phone;
  final String email;
  final String modelyr;
  final String plateno;
  final String enginecode;
  final int odometer;
  final String mileage;
  final String vinno;
  final String vehiclemodel;

  VehicleByCountry(
      {required this.uservehicleid,
        required this.userid,
        required this.name,
        required this.surname,
        required this.country,
        required this.city,
        required this.email,
        required this.phone,
        required this.modelyr,
        required this.plateno,
        required this.enginecode,
        required this.odometer,
        required this.mileage,
        required this.vinno,
        required this.vehiclemodel,
      }
      );

  factory VehicleByCountry.fromJson(Map<String, dynamic> json) {
    return VehicleByCountry(
        uservehicleid: json['uservehicleid'],
        userid: json['userid'],
        name: json['name'],
        surname: json['surname'],
        country: json['country'],
        city: json['city'],
        email: json['email'],
        phone: json['phone'],
      modelyr: json['modelyr'],
      plateno: json['plateno'],
      enginecode: json['enginecode'],
      odometer: json['odometer'],
      mileage: json['mileage'],
      vinno: json['vinno'],
      vehiclemodel: json['vehiclemodel']
    );
  }
  String get consumerName => '$name $surname';
}
