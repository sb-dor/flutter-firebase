import 'dart:math';

import 'package:uuid/uuid.dart';

class AnalyticsProduct {
  final String name;
  final double price;
  final String id;
  final String currency;

  AnalyticsProduct(
    this.name,
    this.price,
    this.currency,
  ) : id = const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "currency": currency,
    };
  }
}

abstract final class AnalyticsProductData {
  static List<String> productNames = [
    "Pizza",
    "Burger",
    "Sushi",
    "Pasta",
    "Salad",
    "Sandwich",
    "Steak",
    "Fries",
    "Tacos",
    "Noodles",
    "Ice Cream",
    "Chocolate",
    "Coffee",
    "Tea",
    "Juice"
  ];
  static List<String> currencies = ["USD", "EUR", "JPY", "TJS", "GBP", "AUD", "CAD"];
  static Random random = Random();

  static List<AnalyticsProduct> get data {
    List<AnalyticsProduct> randomData = [];
    for (int i = 0; i < 15; i++) {
      String name = productNames[random.nextInt(productNames.length)];
      double price = random.nextDouble(); // Random price between 0 and 99
      String currency = currencies[random.nextInt(currencies.length)];
      randomData.add(AnalyticsProduct(name, price, currency));
    }
    return randomData;
  }
}
