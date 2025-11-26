import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.profilePictureUrl != null
                  ? NetworkImage(user!.profilePictureUrl!)
                  : null,
              child: user?.profilePictureUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            Text(
              user?.username ?? 'User',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(user?.phone ?? ''),
            const SizedBox(height: AppDimensions.spacingXXL),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Booking History'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/booking-history'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Wallet'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            CustomButton(
              text: 'Logout',
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              type: ButtonType.outline,
            ),
          ],
        ),
      ),
    );
  }
}

