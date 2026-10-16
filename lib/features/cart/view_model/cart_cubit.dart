import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/domain/entites/home_product_entity.dart';
import '../models/cart_item.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super(const []);

  int get itemCount => state.fold(0, (count, item) => count + item.quantity);

  double get subtotal => state.fold(
    0,
    (total, item) => total + (item.product.price ?? 0) * item.quantity,
  );

  void addItem({
    required HomeProductEntity product,
    required Color selectedColor,
    required String selectedSize,
  }) {
    final id =
        '${product.id ?? product.slug ?? product.title}_${selectedColor.toARGB32()}_$selectedSize';
    final existingIndex = state.indexWhere((item) => item.id == id);
    final updatedItems = List<CartItem>.of(state);

    if (existingIndex == -1) {
      updatedItems.add(
        CartItem(
          product: product,
          quantity: 1,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ),
      );
    } else {
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
    }

    emit(List.unmodifiable(updatedItems));
  }

  void updateQuantity(String itemId, int quantity) {
    final updatedItems = <CartItem>[];
    for (final item in state) {
      if (item.id != itemId) {
        updatedItems.add(item);
      } else if (quantity > 0) {
        updatedItems.add(item.copyWith(quantity: quantity));
      }
    }
    emit(List.unmodifiable(updatedItems));
  }

  void removeItem(String itemId) {
    emit(List.unmodifiable(state.where((item) => item.id != itemId)));
  }

  void clear() {
    emit(const []);
  }
}
