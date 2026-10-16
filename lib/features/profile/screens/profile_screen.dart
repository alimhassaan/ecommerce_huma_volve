import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../core/dummy_data.dart';
import '../../../core/helper/theme.dart';
import '../../auth/login/screens/login_screen.dart';
import 'edit_profile_screen.dart';
import '../view_model/profile_cubit.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const Gap(12),
                      TextButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final user = (state as ProfileLoaded).user;
            return Column(
              children: [
                const Gap(24),
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Gap(32),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ProfileAvatar(
                        name: user.name,
                        imageUrl: user.profilePictureUrl,
                        radius: 56,
                      ),
                    ),
                    Material(
                      color: AppTheme.primary,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Edit profile',
                        onPressed: () => _editProfile(context, user),
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const Gap(32),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      ProfileMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () => _showInfo(
                          context,
                          'My Orders',
                          'Your completed orders will appear here.',
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.favorite_border,
                        title: 'Wishlist',
                        onTap: () => _showInfo(
                          context,
                          'Wishlist',
                          'Your saved products will appear here.',
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Shipping Addresses',
                        onTap: () => _showInfo(
                          context,
                          'Shipping Addresses',
                          'Address management is not available yet.',
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        onTap: () => _showInfo(
                          context,
                          'Payment Methods',
                          'No payment methods are stored in this app.',
                        ),
                      ),
                      ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () => _showInfo(
                          context,
                          'Settings',
                          'Profile details can be changed using the edit button.',
                        ),
                      ),
                      const Gap(16),
                      ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        isDestructive: true,
                        onTap: () => _logout(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, UserProfile user) async {
    final profileCubit = context.read<ProfileCubit>();
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: profileCubit,
          child: EditProfileScreen(user: user),
        ),
      ),
    );
    if (updated == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated on this device.')),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (shouldLogout != true || !context.mounted) return;

    try {
      await context.read<ProfileCubit>().logout();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not log out: $error')));
      }
    }
  }

  Future<void> _showInfo(BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
