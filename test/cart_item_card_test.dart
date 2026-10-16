import 'package:ecommerce_app_huma_volve/features/cart/models/cart_item.dart';
import 'package:ecommerce_app_huma_volve/features/cart/widgets/cart_item_card.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cart item card fits a narrow screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              child: CartItemCard(
                cartItem: CartItem(
                  product: HomeProductEntity(
                    id: 1,
                    title: 'A long product title that should be truncated',
                    price: 123,
                    images: const [],
                  ),
                  quantity: 2,
                  selectedColor: Colors.black,
                  selectedSize: 'Extra large',
                ),
                onIncrease: () {},
                onDecrease: () {},
                onRemove: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
