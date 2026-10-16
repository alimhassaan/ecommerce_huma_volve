import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(HomeInitial());

  List<HomeCategoryModel> categories = [];
  List<HomeProductModel> products = [];

  Future<void> loadHomeData() async {
    emit(CategoryLoading());
    final categoriesResult = await getCategoriesUseCase.invoke();

    await categoriesResult.fold(
      (failure) async {
        emit(CategoryError(failure.failureMessage));
      },
      (loadedCategories) async {
        categories = loadedCategories
            .map(
              (category) =>
                  HomeCategoryModel(id: category.id, name: category.name),
            )
            .toList();
        emit(CategoryLoaded(categories));

        if (categories.isEmpty) {
          products = [];
          emit(ProductsLoaded(products));
          return;
        }

        await getProducts(
          categoryId: categories.first.id!,
          limit: 10,
          offset: 0,
        );
      },
    );
  }

  Future<void> getProducts({
    int? categoryId,
    required int limit,
    required int offset,
  }) async {
    emit(ProductsLoading());
    final productsResult = await getProductsUseCase.invoke(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );

    productsResult.fold(
      (failure) => emit(ProductsError(failure.failureMessage)),
      (loadedProducts) {
        products = loadedProducts
            .map(
              (product) => HomeProductModel(
                id: product.id,
                title: product.title,
                slug: product.slug,
                price: product.price,
                description: product.description,
                category: product.category,
                images: product.images,
              ),
            )
            .toList();
        emit(ProductsLoaded(products));
      },
    );
  }

  Future<void> getProdctsById(
    int id, {
    required int limit,
    required int offset,
  }) async {
    emit(ProductsLoading());
    final prodcts = await getProductsUseCase.invoke(
      categoryId: id,
      limit: limit,
      offset: offset,
    );
    prodcts.fold(
      (failure) => emit(ProductsError(failure.failureMessage)),
      (productsLoaded) => emit(ProductsLoaded(productsLoaded)),
    );
  }
}
