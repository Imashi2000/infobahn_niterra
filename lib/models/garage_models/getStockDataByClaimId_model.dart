class StockDataByClaim {
  final String name;
  final String stockstatus;
  final String qtyinstock;
  final String? availabledate;

  StockDataByClaim({
    required this.name,
    required this.stockstatus,
    required this.qtyinstock,
    this.availabledate,
  });

  factory StockDataByClaim.fromJson(Map<String, dynamic> json) {
    return StockDataByClaim(
      name: json['name'] ?? '',
      stockstatus: json['stockstatus'] ?? '',
      qtyinstock: json['qtyinstock'] ?? '0',
      availabledate: json['availabledate'] == "" ? null : json['availabledate'],
    );
  }
}

