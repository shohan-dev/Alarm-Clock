import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/route/app_routes.dart';

class SplashController extends GetxController {
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final hasSeenOnboarding = storage.read('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      final hasLocation = storage.read('user_location') != null;
      Get.offAllNamed(hasLocation ? AppRoutes.home : AppRoutes.location);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
