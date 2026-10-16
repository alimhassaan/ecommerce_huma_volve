part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

class HomeInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategoryLoaded extends HomeState {
  final List<HomeCategoryEntity> categories;
  CategoryLoaded(this.categories);
}

class CategoryError extends HomeState {
  final String errorMessage;
  CategoryError(this.errorMessage);
}

class ProductsLoading extends HomeState {}

class ProductsLoaded extends HomeState {
  final List<HomeProductEntity> products;
  ProductsLoaded(this.products);
}

class ProductsError extends HomeState {
  final String errorMessage;
  ProductsError(this.errorMessage);
}
