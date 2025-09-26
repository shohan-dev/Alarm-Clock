import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/location/presentation/location_screen.dart';
import '../../features/alarms/presentation/home_screen.dart';
import '../../features/alarms/presentation/add_edit_alarm_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.location,
      page: () => const LocationScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.addAlarm,
      page: () => const AddEditAlarmScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.editAlarm,
      page: () => const AddEditAlarmScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
