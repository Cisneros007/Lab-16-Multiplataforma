import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final products = await apiService.fetchProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> createProduct(String title, String description, double price, DateTime createdAt, bool isSold) async {
    await apiService.createProduct(title, description, price, createdAt, isSold);
    fetchProducts();
  }

  Future<void> updateProduct(int id, String title, String description, double price, DateTime createdAt, bool isSold) async {
    await apiService.updateProduct(id, title, description, price, createdAt, isSold);
    fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await apiService.deleteProduct(id);
    fetchProducts();
  }

  void _showAddDialog() {
    String title = '';
    String description = '';
    double price = 0.0;
    DateTime createdAt = DateTime.now(); // Definir fecha actual por defecto
    bool isSold = false; // Definir como no vendido por defecto

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.parse(value),
              ),
              CheckboxListTile(
                title: const Text('Sold'),
                value: isSold,
                onChanged: (value) {
                  setState(() {
                    isSold = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                createProduct(title, description, price, createdAt, isSold);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int id, String currentTitle, String currentDescription, double currentPrice, DateTime? currentCreatedAt, bool currentIsSold) {
    String title = currentTitle;
    String description = currentDescription;
    double price = currentPrice;
    DateTime createdAt = currentCreatedAt ?? DateTime.now(); // Usar la fecha actual si currentCreatedAt es null
    bool isSold = currentIsSold;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
                controller: TextEditingController()..text = currentTitle,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
                controller: TextEditingController()..text = currentDescription,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = double.parse(value),
                controller: TextEditingController()..text = currentPrice.toString(),
              ),
              CheckboxListTile(
                title: const Text('Sold'),
                value: isSold,
                onChanged: (value) {
                  setState(() {
                    isSold = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateProduct(id, title, description, price, createdAt, isSold);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Product CRUD App'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductTile(
                  product: product,
                  onEdit: () => _showEditDialog(product.id, product.title, product.description, product.price, product.createdAt, product.isSold),
                  onDelete: () => deleteProduct(product.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
