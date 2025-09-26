import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/alarm_model.dart';
import 'alarm_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlarmController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              padding:
                  const EdgeInsets.all(AppDimensions.screenHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.paddingMedium),

                  // Time display
                  StreamBuilder<DateTime>(
                    stream: Stream.periodic(
                        const Duration(seconds: 1), (_) => DateTime.now()),
                    builder: (context, snapshot) {
                      final now = snapshot.data ?? DateTime.now();
                      return Text(
                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                        style: AppTextStyles.timeDisplayLarge,
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.paddingSmall),

                  // Selected Location
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.textSecondary,
                        size: AppDimensions.iconSmall,
                      ),
                      SizedBox(width: AppDimensions.paddingSmall),
                      Text(
                        AppStrings.selectedLocation,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.paddingSmall),

                  Obx(() => Text(
                        controller.selectedLocation.value,
                        style: AppTextStyles.locationText,
                      )),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.paddingLarge),

            // Alarms section
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.alarms,
                      style: AppTextStyles.heading4,
                    ),

                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Alarms list
                    Expanded(
                      child: Obx(() => controller.alarms.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.alarm_off,
                                    size: 64,
                                    color: AppColors.textTertiary,
                                  ),
                                  SizedBox(height: AppDimensions.paddingMedium),
                                  Text(
                                    'No alarms set',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  SizedBox(height: AppDimensions.paddingSmall),
                                  Text(
                                    'Tap the + button to add your first alarm',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: controller.sortedAlarms.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: AppDimensions.paddingMedium,
                              ),
                              itemBuilder: (context, index) {
                                final alarm = controller.sortedAlarms[index];
                                return AlarmCard(
                                  alarm: alarm,
                                  onToggle: () =>
                                      controller.toggleAlarm(alarm.id),
                                  onEdit: () =>
                                      controller.navigateToEditAlarm(alarm),
                                  onDelete: () =>
                                      controller.deleteAlarm(alarm.id),
                                );
                              },
                            )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigateToAddAlarm(),
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.textPrimary,
          size: AppDimensions.iconLarge,
        ),
      ),
    );
  }
}

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.alarmItemHeight,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.alarmItemRadius),
        border: alarm.isEnabled
            ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Time and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  alarm.formattedTime12Hour,
                  style: AppTextStyles.timeDisplay.copyWith(
                    color: alarm.isEnabled
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alarm.formattedDate,
                  style: AppTextStyles.dateDisplay.copyWith(
                    color: alarm.isEnabled
                        ? AppColors.textSecondary
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Edit button
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconSmall,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),

              // Delete button
              IconButton(
                onPressed: () => _showDeleteDialog(context),
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                  size: AppDimensions.iconSmall,
                ),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),

              const SizedBox(width: AppDimensions.paddingSmall),

              // Toggle switch
              Switch(
                value: alarm.isEnabled,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.backgroundLight,
                inactiveThumbColor: AppColors.textTertiary,
                inactiveTrackColor: AppColors.switchInactive,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        title: const Text(
          'Delete Alarm',
          style: AppTextStyles.heading4,
        ),
        content: const Text(
          'Are you sure you want to delete this alarm?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              AppStrings.cancel,
              style: AppTextStyles.buttonMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onDelete();
            },
            child: Text(
              AppStrings.delete,
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
