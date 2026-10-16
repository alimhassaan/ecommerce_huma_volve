import 'package:ecommerce_app_huma_volve/core/constants/api_end_point.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

class HomeRemoteDataSourceImp implements HomeRemoteDataSource {
  final ApiClient apiClient;
  HomeRemoteDataSourceImp(this.apiClient);
  @override
  Future<List<HomeCategoryModel>> getCategories() async {
    final response = await apiClient.dio.get(ApiEndPoint.categories);
    final dynamic data = response.data;
    if (data is List) {
      return data
          .map((e) => HomeCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<HomeProductModel>> getProducts(int? categoryId) async {
    final String endpoint = categoryId != null
        ? '${ApiEndPoint.categories}/$categoryId/${ApiEndPoint.products}'
        : ApiEndPoint.products;
    final response = await apiClient.dio.get(endpoint);
    final dynamic data = response.data;
    if (data is List) {
      return data
          .map((e) => HomeProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
