import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error_handling/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repo.dart';

class GetProductsUseCase {
  final HomeRepo homeRepository;

  GetProductsUseCase(this.homeRepository);

  Future<Either<Failure, List<HomeProductEntity>>> invoke(int? categoryId) =>
      homeRepository.getProducts(categoryId);
}
