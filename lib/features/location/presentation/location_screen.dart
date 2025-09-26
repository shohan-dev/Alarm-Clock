import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/app_dimensions.dart';
import '../../../constants/app_strings.dart';
import 'location_controller.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontalPadding,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingXLarge * 2),

                // Header text
                const Text(
                  AppStrings.locationTitle,
                  style: AppTextStyles.onboardingTitle,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                const Text(
                  AppStrings.locationDescription,
                  style: AppTextStyles.onboardingDescription,
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Circular image container
                Container(
                  width: 250,
                  height: 250,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    image: DecorationImage(
                      image: AssetImage('assets/images/location.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background.withOpacity(0.3),
                          AppColors.background.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Location button
                Obx(() => Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(AppDimensions.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMedium),
                        border: Border.all(
                          color: controller.hasLocationPermission.value
                              ? AppColors.primary
                              : AppColors.divider,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: controller.hasLocationPermission.value
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: AppDimensions.iconMedium,
                          ),
                          const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: Text(
                              controller.locationText.value,
                              style: controller.hasLocationPermission.value
                                  ? AppTextStyles.locationText.copyWith(
                                      color: AppColors.textPrimary,
                                    )
                                  : AppTextStyles.locationText,
                            ),
                          ),
                          if (controller.isLoading.value)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )),

                const SizedBox(height: AppDimensions.paddingLarge),

                // Use Current Location button
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.requestLocationPermission(),
                        icon: const Icon(Icons.my_location),
                        label: const Text(
                          AppStrings.useCurrentLocation,
                          style: AppTextStyles.buttonLarge,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.buttonRadius,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.paddingMedium,
                          ),
                        ),
                      ),
                    )),

                const SizedBox(height: AppDimensions.paddingMedium),

                // Home button (only show when location is granted)
                Obx(() => controller.hasLocationPermission.value
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.navigateToHome(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.buttonRadius,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.paddingMedium,
                            ),
                          ),
                          child: const Text(
                            AppStrings.home,
                            style: AppTextStyles.buttonLarge,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),

                const SizedBox(height: AppDimensions.paddingXLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
