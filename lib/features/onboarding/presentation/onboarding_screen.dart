import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/app_dimensions.dart';
import '../../../constants/app_strings.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => controller.skipOnboarding(),
                    child: const Text(
                      AppStrings.skip,
                      style: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onboardingItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.onboardingItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenHorizontalPadding,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppDimensions.paddingXLarge),

                          // Image container with rounded corners
                          Container(
                            height: AppDimensions.onboardingImageHeight,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXLarge,
                              ),
                              color: AppColors.surface,
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/onboarding1.png'),
                                fit: BoxFit.cover,
                                // For demo, using same placeholder for all screens
                                // In real app, use item.imagePath
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusXLarge,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.background.withOpacity(0.3),
                                    AppColors.background.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.paddingXLarge),

                          // Title
                          Text(
                            item.title,
                            style: AppTextStyles.onboardingTitle,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppDimensions.paddingMedium),

                          // Description
                          Text(
                            item.description,
                            style: AppTextStyles.onboardingDescription,
                            textAlign: TextAlign.center,
                          ),

                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom section with indicators and next button
              Padding(
                padding:
                    const EdgeInsets.all(AppDimensions.screenHorizontalPadding),
                child: Column(
                  children: [
                    // Page indicators
                    Obx(() => SmoothPageIndicator(
                          controller: controller.pageController,
                          count: controller.onboardingItems.length,
                          effect: const WormEffect(
                            dotHeight: AppDimensions.onboardingIndicatorSize,
                            dotWidth: AppDimensions.onboardingIndicatorSize,
                            activeDotColor: AppColors.primary,
                            dotColor: AppColors.textTertiary,
                            spacing: 16,
                          ),
                        )),

                    const SizedBox(height: AppDimensions.paddingXLarge),

                    // Next button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.nextPage(),
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
                            child: Text(
                              controller.isLastPage.value
                                  ? AppStrings.home
                                  : AppStrings.next,
                              style: AppTextStyles.buttonLarge,
                            ),
                          ),
                        )),

                    const SizedBox(height: AppDimensions.paddingLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
