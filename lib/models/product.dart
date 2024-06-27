class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final DateTime? createdAt; // Cambiado a DateTime nullable
  final bool isSold;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.createdAt, // Cambiado a DateTime nullable
    required this.isSold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      isSold: json['isSold'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'createdAt': createdAt?.toIso8601String(), // Usando el operador de navegación segura '?.' para evitar errores si createdAt es null
      'isSold': isSold,
    };
  }
}
