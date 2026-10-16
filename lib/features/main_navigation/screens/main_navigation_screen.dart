import 'package:ecommerce_app_huma_volve/core/networking/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/data_source/home_remote_data_source_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repo/home_repo_imp.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helper/theme.dart';
import '../../cart/models/cart_item.dart';
import '../../cart/view_model/cart_cubit.dart';
import '../../home/presentation/view/home_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/view_model/profile_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final ApiClient apiClient;
  late final HomeCubit homeCubit;
  late final CartCubit cartCubit;
  late final ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    cartCubit = CartCubit();
    profileCubit = ProfileCubit();
    final homeRepository = HomeRepoImp(HomeRemoteDataSourceImp(apiClient));
    homeCubit = HomeCubit(
      getCategoriesUseCase: GetCategoriesUseCase(homeRepository),
      getProductsUseCase: GetProductsUseCase(homeRepository),
    );
  }

  @override
  void dispose() {
    homeCubit.close();
    cartCubit.close();
    profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BlocProvider.value(
        value: homeCubit,
        child: HomeScreen(onProfileTap: () => setState(() => _currentIndex = 2)),
      ),
      CartScreen(onContinueShopping: () => setState(() => _currentIndex = 0)),
      const ProfileScreen(),
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cartCubit),
        BlocProvider.value(value: profileCubit),
      ],
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primary,
            unselectedItemColor: Colors.grey.shade400,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.home_filled, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.home_filled, size: 32),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _cartNavigationIcon(Icons.shopping_cart_outlined, 28),
                activeIcon: _cartNavigationIcon(Icons.shopping_cart, 32),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.person_outline, size: 28),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Icon(Icons.person, size: 32),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _cartNavigationIcon(IconData icon, double size) {
    return BlocBuilder<CartCubit, List<CartItem>>(
      builder: (context, items) {
        final count = items.fold(0, (sum, item) => sum + item.quantity);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: size),
              if (count > 0)
                Positioned(
                  right: -9,
                  top: -7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
