import 'package:ecommerce_app_huma_volve/core/constants/api_end_point.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/product_model.dart';

class HomeServices {
  final ApiClient apiClient;

  HomeServices({required this.apiClient});

  Future<List<CategoryModel>> getAllCategories() async {
    final response = await apiClient.dio.get(ApiEndPoint.categories);
    final dynamic data = response.data;
    if (data is List) {
      return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<ProductModel>> getAllProducts({int? categoryId}) async {
    final String endpoint = categoryId != null
        ? '${ApiEndPoint.categories}/$categoryId/${ApiEndPoint.products}'
        : ApiEndPoint.products;
    final response = await apiClient.dio.get(endpoint);
    final dynamic data = response.data;
    if (data is List) {
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
