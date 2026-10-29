import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const _baseUrl = 'https://dummyjson.com/products?limit=100';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> raw = data['products'] as List<dynamic>;
      return raw
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load products (HTTP ${response.statusCode})');
  }
}
