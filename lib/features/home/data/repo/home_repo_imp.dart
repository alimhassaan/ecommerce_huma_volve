import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error_handling/error_handler.dart';
import 'package:ecommerce_app_huma_volve/core/error_handling/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repo.dart';

class HomeRepoImp implements HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  HomeRepoImp(this.homeRemoteDataSource);
  @override
  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories() async {
    try {
      final categories = await homeRemoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<HomeProductEntity>>> getProducts({
    required int? categoryId,
    required int limit,
    required int offset,
  }) async {
    try {
      final products = await homeRemoteDataSource.getProducts(
        categoryId,
        limit: limit,
        offset: offset,
      );
      return Right(products);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
