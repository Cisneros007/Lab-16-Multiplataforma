import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ApiService {
  final String apiUrl = "https://api.escuelajs.co/api/v1/products";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> createProduct(String title, String description, double price, DateTime createdAt, bool isSold) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": title,
        "description": description,
        "price": price,
        "categoryId": 1,
        "images": ["https://placeimg.com/640/480/any"],
        "createdAt": createdAt.toIso8601String(),
        "isSold": isSold,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create product');
    }
  }

  Future<void> updateProduct(int id, String title, String description, double price, DateTime createdAt, bool isSold) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": title,
        "description": description,
        "price": price,
        "createdAt": createdAt.toIso8601String(),
        "isSold": isSold,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
