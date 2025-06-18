import 'package:product_demo/features/products/model/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
}
