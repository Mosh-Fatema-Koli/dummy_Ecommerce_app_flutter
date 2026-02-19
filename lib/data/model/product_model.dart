class ProductModel {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  int quantity; // new field for cart

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.quantity = 0, // default 1
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'thumbnail': thumbnail,
    'quantity': quantity,
  };
}
