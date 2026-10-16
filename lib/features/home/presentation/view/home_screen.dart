import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/profile/view_model/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/helper/theme.dart';
import '../../../profile/widgets/profile_avatar.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const HomeScreen({super.key, this.onProfileTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onListen);
    final cubit = context.read<HomeCubit>();
    if (cubit.categories.isEmpty) {
      cubit.loadHomeData();
    }
  }

  void _onListen() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    const triggerDistance = 200.0;
    if (position.pixels >= position.maxScrollExtent - triggerDistance) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onListen)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onProfileTap,
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              final user = state is ProfileLoaded
                                  ? state.user
                                  : null;
                              return ProfileAvatar(
                                name: user?.name ?? '',
                                imageUrl: user?.profilePictureUrl ?? '',
                                radius: 24,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gap(32),
                    Text(
                      'Explore',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 36),
                    ),
                    const Gap(8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                    ),
                    const Gap(32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Gap(32),
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) =>
                          current is CategoryLoading ||
                          current is CategoryLoaded ||
                          current is CategoryError,
                      builder: (context, state) {
                        final cubit = context.read<HomeCubit>();
                        if (state is CategoryLoading &&
                            cubit.categories.isEmpty) {
                          return const SizedBox(
                            height: 44,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (state is CategoryError &&
                            cubit.categories.isEmpty) {
                          return Center(child: Text(state.errorMessage));
                        }

                        final categories = cubit.categories;
                        if (categories.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (context, index) => const Gap(12),
                            itemBuilder: (context, index) {
                              return CategoryChip(
                                label: categories[index].name ?? '',
                                isSelected: _selectedCategoryIndex == index,
                                onTap: () {
                                  if (_selectedCategoryIndex != index) {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                    cubit.getProducts(
                                      categoryId: categories[index].id,
                                      limit: 10,
                                      offset: 0,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is ProductsLoading ||
                  current is ProductsLoaded ||
                  current is ProductsError,
              builder: (context, state) {
                final cubit = context.read<HomeCubit>();
                if (state is ProductsLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else if (state is ProductsError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }

                final products = cubit.products;
                if (products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text(
                          'No products found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(product: products[index]);
                    }, childCount: products.length),
                  ),
                );
              },
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) =>
                  current is ProductsLoading ||
                  current is ProductsError ||
                  current is ProductsLoaded,
              builder: (context, state) {
                if (state is! ProductsLoaded) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                if (state.isLoadingMore) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (state.paginationError != null) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: TextButton(
                        onPressed: () =>
                            context.read<HomeCubit>().loadMoreProducts(),
                        child: Text(
                          'Could not load more products. Tap to retry.',
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            const SliverToBoxAdapter(child: Gap(24)),
          ],
        ),
      ),
    );
  }
}
