import 'package:ecommerce_app_huma_volve/features/home/services/home_services.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeServices homeServices;
  HomeCubit(this.homeServices) : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoryLoading());
    try {
      final categories = await homeServices.getAllCategories();
      emit(CategoryLoaded(categories));
      emit(ProductsLoading());
      final products = await homeServices.getAllProducts(categoryId: categories[0].id);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(CategoryError(e.toString()));
      
    }
  }
}
