import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_widget.dart' as error_widget;
import '../../providers/mechanic_provider.dart';

class MechanicListScreen extends StatelessWidget {
  const MechanicListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mechanicProvider = Provider.of<MechanicProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Mechanics'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingMD),
            child: CustomTextField(
              hint: 'Search by name or service...',
              prefixIcon: Icons.search,
              onChanged: (value) => mechanicProvider.searchMechanics(value),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMD),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Nearest',
                  isSelected: mechanicProvider.sortOption == SortOption.nearest,
                  onTap: () => mechanicProvider.setSortOption(SortOption.nearest),
                ),
                const SizedBox(width: AppDimensions.spacingSM),
                _FilterChip(
                  label: 'Top Rated',
                  isSelected: mechanicProvider.sortOption == SortOption.topRated,
                  onTap: () => mechanicProvider.setSortOption(SortOption.topRated),
                ),
                const SizedBox(width: AppDimensions.spacingSM),
                _FilterChip(
                  label: 'Cheapest',
                  isSelected: mechanicProvider.sortOption == SortOption.cheapest,
                  onTap: () => mechanicProvider.setSortOption(SortOption.cheapest),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Expanded(
            child: mechanicProvider.isLoading
                ? const LoadingIndicator()
                : mechanicProvider.error != null
                    ? error_widget.CustomErrorWidget(
                        message: mechanicProvider.error!,
                        onRetry: () => mechanicProvider.loadNearbyMechanics(),
                      )
                    : mechanicProvider.mechanics.isEmpty
                        ? error_widget.EmptyStateWidget(
                            message: 'No mechanics found',
                            subtitle: 'Try adjusting your search or filters',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppDimensions.spacingMD),
                            itemCount: mechanicProvider.mechanics.length,
                            itemBuilder: (context, index) {
                              final mechanic = mechanicProvider.mechanics[index];
                              return Card(
                                margin: const EdgeInsets.only(
                                  bottom: AppDimensions.spacingMD,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: mechanic.profilePictureUrl != null
                                        ? NetworkImage(mechanic.profilePictureUrl!)
                                        : null,
                                    child: mechanic.profilePictureUrl == null
                                        ? const Icon(Icons.person, size: 30)
                                        : null,
                                  ),
                                  title: Row(
                                    children: [
                                      Expanded(child: Text(mechanic.name)),
                                      if (mechanic.verified)
                                        const Icon(
                                          Icons.verified,
                                          color: AppColors.success,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: AppColors.ratingStar, size: 16),
                                          Text(' ${mechanic.rating.toStringAsFixed(1)}'),
                                          Text(' (${mechanic.totalReviews})',
                                              style: AppTextStyles.bodySmall(isDark: isDark)),
                                        ],
                                      ),
                                      if (mechanic.distance != null)
                                        Text(
                                          '${mechanic.distance!.toStringAsFixed(1)} km away',
                                          style: AppTextStyles.bodySmall(isDark: isDark),
                                        ),
                                      if (mechanic.priceRange != null)
                                        Text(
                                          mechanic.priceRange!,
                                          style: AppTextStyles.bodySmall(isDark: isDark),
                                        ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    context.push('/mechanic/${mechanic.id}');
                                  },
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}

