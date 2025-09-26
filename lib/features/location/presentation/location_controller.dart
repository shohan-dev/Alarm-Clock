import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constants/app_routes.dart';

class LocationController extends GetxController {
  final GetStorage storage = GetStorage();

  var isLoading = false.obs;
  var locationText = 'Add your location'.obs;
  var hasLocationPermission = false.obs;
  var currentPosition = Rxn<Position>();

  @override
  void onInit() {
    super.onInit();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Permission.location.status;
    hasLocationPermission.value = permission.isGranted;

    if (hasLocationPermission.value) {
      await _getCurrentLocation();
    }
  }

  Future<void> requestLocationPermission() async {
    isLoading.value = true;

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services to use this feature.',
        );
        isLoading.value = false;
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to use this feature.',
          );
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied Forever',
          'Please enable location permission from settings.',
        );
        isLoading.value = false;
        return;
      }

      hasLocationPermission.value = true;
      await _getCurrentLocation();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location permission: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        locationText.value = '${placemark.locality}, ${placemark.country}';

        // Save location data
        storage.write('user_location', {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': locationText.value,
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  void navigateToHome() {
    if (hasLocationPermission.value && currentPosition.value != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Location Required',
        'Please allow location access to continue.',
      );
    }
  }
}
