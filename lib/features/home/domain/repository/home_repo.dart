import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error_handling/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';

abstract class HomeRepo {

  Future<Either<Failure, List<HomeCategoryEntity>>> getCategories();
  Future<Either<Failure, List<HomeProductEntity>>> getProducts(
    int? categoryId,
 
  );
}

