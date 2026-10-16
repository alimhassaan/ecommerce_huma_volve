import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/helper/theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/cart_item.dart';
import '../view_model/cart_cubit.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const CartScreen({super.key, this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        actions: [
          BlocBuilder<CartCubit, List<CartItem>>(
            builder: (context, items) {
              if (items.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Clear cart',
                onPressed: () => _confirmClearCart(context),
                icon: const Icon(Icons.delete_sweep_outlined),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, items) {
          if (items.isEmpty) return _buildEmptyCart(context);

          final cart = context.read<CartCubit>();
          final subtotal = cart.subtotal;
          final tax = subtotal * 0.1;
          final total = subtotal + tax;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CartItemCard(
                      cartItem: item,
                      onIncrease: () =>
                          cart.updateQuantity(item.id, item.quantity + 1),
                      onDecrease: () =>
                          cart.updateQuantity(item.id, item.quantity - 1),
                      onRemove: () => cart.removeItem(item.id),
                    );
                  },
                ),
              ),
              _buildSummary(context, subtotal, tax, total),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const Gap(20),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'Add something you love and it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Gap(24),
            OutlinedButton(
              onPressed: onContinueShopping,
              child: const Text('Continue shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    double subtotal,
    double tax,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _priceRow('Subtotal', subtotal),
            const Gap(12),
            _priceRow('Tax (10%)', tax),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
            const Gap(20),
            PrimaryButton(
              text: 'Checkout',
              onPressed: () => _showCheckoutNotice(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ],
    );
  }

  Future<void> _confirmClearCart(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (shouldClear == true && context.mounted) {
      context.read<CartCubit>().clear();
    }
  }

  Future<void> _showCheckoutNotice(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Checkout unavailable'),
        content: const Text(
          'Your cart is ready, but online checkout has not been connected yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
