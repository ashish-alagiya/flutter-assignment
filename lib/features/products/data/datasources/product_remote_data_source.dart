import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_demo/features/products/model/product_model.dart';
import 'package:product_demo/utils/api_constant.dart';
import 'package:product_demo/utils/app_strings.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConstant.productUrl),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception(AppString.failedtoloadproducts);
      }
    } catch (e) {
      throw Exception(AppString.failedtoconnectserver);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstant.categoryUrl}$category'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('${AppString.failedtoloadcategory} $category');
      }
    } catch (e) {
      throw Exception(AppString.failedtoconnectserver);
    }
  }
}
