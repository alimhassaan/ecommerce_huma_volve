import 'package:ecommerce_app_huma_volve/features/cart/view_model/cart_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CartCubit cartCubit;
  late HomeProductEntity product;

  setUp(() {
    cartCubit = CartCubit();
    product = HomeProductEntity(id: 10, title: 'Test product', price: 25);
  });

  tearDown(() async {
    await cartCubit.close();
  });

  test('adding the same product variant increments its quantity', () {
    cartCubit.addItem(
      product: product,
      selectedColor: Colors.black,
      selectedSize: 'M',
    );
    cartCubit.addItem(
      product: product,
      selectedColor: Colors.black,
      selectedSize: 'M',
    );

    expect(cartCubit.state, hasLength(1));
    expect(cartCubit.state.single.quantity, 2);
    expect(cartCubit.itemCount, 2);
    expect(cartCubit.subtotal, 50);
  });

  test(
    'product variants stay separate and removing the last unit empties cart',
    () {
      cartCubit.addItem(
        product: product,
        selectedColor: Colors.black,
        selectedSize: 'M',
      );
      cartCubit.addItem(
        product: product,
        selectedColor: Colors.black,
        selectedSize: 'L',
      );

      expect(cartCubit.state, hasLength(2));

      final item = cartCubit.state.first;
      cartCubit.updateQuantity(item.id, 0);

      expect(cartCubit.state, hasLength(1));
      expect(cartCubit.state.single.selectedSize, 'L');

      cartCubit.clear();

      expect(cartCubit.state, isEmpty);
    },
  );
}
