import 'package:product_demo/features/products/data/datasources/product_remote_data_source.dart';
import 'package:product_demo/features/products/model/product_model.dart';
import 'package:product_demo/features/products/data/repositories/product_repository.dart';
import 'package:product_demo/utils/app_strings.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      return await remoteDataSource.getProducts();
    } catch (e) {
      throw Exception('${AppString.failedtoloadproducts} ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      return await remoteDataSource.getProductsByCategory(category);
    } catch (e) {
      throw Exception(
          '${AppString.failedtoloadcategory} $category: ${e.toString()}');
    }
  }
}
