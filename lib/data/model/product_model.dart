class ProductModel {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final int quantity;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    thumbnail: json['thumbnail'],
    quantity: json['quantity'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'thumbnail': thumbnail,
    'quantity': quantity,
  };



  // ✅ copyWith method
  ProductModel copyWith({
    int? id,
    String? title,
    double? price,
    String? thumbnail,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }
}