import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_widget.dart' as error_widget;
import '../../providers/mechanic_provider.dart';

class MechanicDetailScreen extends StatefulWidget {
  final String mechanicId;

  const MechanicDetailScreen({
    super.key,
    required this.mechanicId,
  });

  @override
  State<MechanicDetailScreen> createState() => _MechanicDetailScreenState();
}

class _MechanicDetailScreenState extends State<MechanicDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MechanicProvider>(context, listen: false)
          .loadMechanic(widget.mechanicId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mechanicProvider = Provider.of<MechanicProvider>(context);
    final mechanic = mechanicProvider.selectedMechanic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (mechanicProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mechanic Details')),
        body: const LoadingIndicator(),
      );
    }

    if (mechanicProvider.error != null || mechanic == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mechanic Details')),
        body: error_widget.CustomErrorWidget(
          message: mechanicProvider.error ?? 'Mechanic not found',
          onRetry: () => mechanicProvider.loadMechanic(widget.mechanicId),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: mechanic.profilePictureUrl != null
                  ? Image.network(
                      mechanic.profilePictureUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primary,
                        child: const Icon(Icons.person, size: 100),
                      ),
                    )
                  : Container(
                      color: AppColors.primary,
                      child: const Icon(Icons.person, size: 100),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  mechanic.name,
                                  style: AppTextStyles.h2(isDark: isDark),
                                ),
                                if (mechanic.verified) ...[
                                  const SizedBox(width: AppDimensions.spacingSM),
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.success,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppDimensions.spacingXS),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: AppColors.ratingStar, size: 20),
                                Text(
                                  ' ${mechanic.rating.toStringAsFixed(1)}',
                                  style: AppTextStyles.bodyLarge(isDark: isDark),
                                ),
                                Text(
                                  ' (${mechanic.totalReviews} reviews)',
                                  style: AppTextStyles.bodyMedium(isDark: isDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingLG),
                  if (mechanic.distance != null)
                    _InfoRow(
                      icon: Icons.location_on,
                      label: 'Distance',
                      value: '${mechanic.distance!.toStringAsFixed(1)} km away',
                    ),
                  if (mechanic.estimatedArrivalMinutes != null)
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'Estimated Arrival',
                      value: '${mechanic.estimatedArrivalMinutes} minutes',
                    ),
                  if (mechanic.priceRange != null)
                    _InfoRow(
                      icon: Icons.attach_money,
                      label: 'Price Range',
                      value: mechanic.priceRange!,
                    ),
                  const SizedBox(height: AppDimensions.spacingLG),
                  if (mechanic.services.isNotEmpty) ...[
                    Text(
                      'Services Offered',
                      style: AppTextStyles.h3(isDark: isDark),
                    ),
                    const SizedBox(height: AppDimensions.spacingMD),
                    Wrap(
                      spacing: AppDimensions.spacingSM,
                      runSpacing: AppDimensions.spacingSM,
                      children: mechanic.services.map((service) {
                        return Chip(
                          label: Text(service),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),
                  ],
                  if (mechanic.workshopAddress != null) ...[
                    Text(
                      'Workshop Address',
                      style: AppTextStyles.h3(isDark: isDark),
                    ),
                    const SizedBox(height: AppDimensions.spacingSM),
                    Text(
                      mechanic.workshopAddress!,
                      style: AppTextStyles.bodyMedium(isDark: isDark),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingMD),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: CustomButton(
          text: mechanic.isAvailable ? 'Book Now' : 'Not Available',
          onPressed: mechanic.isAvailable
              ? () => context.push('/booking/${mechanic.id}')
              : null,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMD),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacingSM),
          Text(
            '$label: ',
            style: AppTextStyles.bodyMedium(isDark: isDark),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium(
              isDark: isDark,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

