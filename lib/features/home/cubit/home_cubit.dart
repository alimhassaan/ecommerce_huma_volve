import 'package:ecommerce_app_huma_volve/features/home/services/home_services.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeServices homeServices;
  HomeCubit(this.homeServices) : super(HomeInitial());

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  void loadHomeData() async {
    emit(CategoryLoading());
    try {
      categories = await homeServices.getAllCategories();
      emit(CategoryLoaded(categories));

      if (categories.isNotEmpty && categories.first.id != null) {
        getProducts(categoryId: categories.first.id);
      } else {
        getProducts();
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void getProducts({int? categoryId}) async {
    emit(ProductsLoading());
    try {
      products = await homeServices.getAllProducts(categoryId: categoryId);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
