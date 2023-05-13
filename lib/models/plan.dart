class Plan {
  String title;
  double price;
  String description;
  int shops;
  int time;
  Plan(
      {required this.title,
      required this.price,
      required this.shops,
      required this.description,
      required this.time});

  factory Plan.fromJson(json) => Plan(
      title: json["title"],
      price: isInteger(json["price"]) == true
          ? json["price"].toDouble()
          : json["price"],
      description: json["description"],
      shops: json["shops"],
      time: json["duration"]);
}

bool isInteger(num value) => value is int || value == value.roundToDouble();
