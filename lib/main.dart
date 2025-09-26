import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/constants/app_theme.dart';
import 'core/route/app_routes.dart';
import 'core/route/app_pages.dart';
import 'helpers/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize notifications
  await NotificationHelper.initialize();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1E1E2E),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const AlarmClockApp());
}

class AlarmClockApp extends StatelessWidget {
  const AlarmClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Travel Alarm',
      theme: AppTheme.theme,
      initialRoute: _getInitialRoute(),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
  
  String _getInitialRoute() {
    final storage = GetStorage();
    final hasSeenOnboarding = storage.read('hasSeenOnboarding') ?? false;
    
    if (hasSeenOnboarding) {
      final hasLocation = storage.read('user_location') != null;
      return hasLocation ? AppRoutes.home : AppRoutes.location;
    }
    
    return AppRoutes.onboarding;
  }
}