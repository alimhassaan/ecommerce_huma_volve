import 'package:flutter/material.dart';
import '../../../features/home/domain/entites/home_product_entity.dart';

class CartItem {
  final HomeProductEntity product;
  final int quantity;
  final Color selectedColor;
  final String selectedSize;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });

  String get id =>
      '${product.id ?? product.slug ?? product.title}_${selectedColor.toARGB32()}_$selectedSize';

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
    );
  }
}
