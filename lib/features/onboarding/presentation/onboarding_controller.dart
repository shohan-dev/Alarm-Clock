import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_strings.dart';
import '../domain/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final GetStorage storage = GetStorage();

  var currentIndex = 0.obs;
  var isLastPage = false.obs;

  // Onboarding data based on the design
  final List<OnboardingModel> onboardingItems = [
    OnboardingModel(
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Description,
      imagePath: 'assets/images/onboarding1.png', // Airplane wing image
    ),
    OnboardingModel(
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Description,
      imagePath: 'assets/images/onboarding2.png', // Beach/ocean image
    ),
    OnboardingModel(
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Description,
      imagePath: 'assets/images/onboarding3.png', // Boat in water image
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Check if onboarding is already completed
    checkOnboardingStatus();
  }

  void checkOnboardingStatus() {
    final hasSeenOnboarding = storage.read('hasSeenOnboarding') ?? false;
    if (hasSeenOnboarding) {
      Get.offAllNamed(AppRoutes.location);
    }
  }

  void nextPage() {
    if (currentIndex.value < onboardingItems.length - 1) {
      currentIndex.value++;
      pageController.animateToPage(
        currentIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    storage.write('hasSeenOnboarding', true);
    Get.offAllNamed(AppRoutes.location);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    isLastPage.value = index == onboardingItems.length - 1;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
