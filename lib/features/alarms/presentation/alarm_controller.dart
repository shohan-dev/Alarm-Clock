import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import '../domain/alarm_model.dart';
import '../../../core/route/app_routes.dart';
import '../../../helpers/notification_helper.dart';

class AlarmController extends GetxController {
  final GetStorage storage = GetStorage();

  var alarms = <AlarmModel>[].obs;
  var isLoading = false.obs;
  var selectedLocation = 'Add your location'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAlarms();
    _loadLocation();
  }

  void _loadLocation() {
    final locationData = storage.read('user_location');
    if (locationData != null) {
      selectedLocation.value = locationData['address'] ?? 'Unknown location';
    }
  }

  void _loadAlarms() {
    try {
      final alarmsData = storage.read('alarms');
      if (alarmsData != null) {
        final alarmsList = List<Map<String, dynamic>>.from(alarmsData);
        alarms.value =
            alarmsList.map((json) => AlarmModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Error loading alarms - handle silently in production
      if (kDebugMode) {
        print('Error loading alarms: $e');
      }
    }
  }

  void _saveAlarms() {
    try {
      final alarmsJson = alarms.map((alarm) => alarm.toJson()).toList();
      storage.write('alarms', alarmsJson);
    } catch (e) {
      // Error saving alarms - handle silently in production
      if (kDebugMode) {
        print('Error saving alarms: $e');
      }
    }
  }

  void addAlarm(AlarmModel alarm) {
    alarms.add(alarm);
    _saveAlarms();
    _scheduleNotification(alarm);
  }

  void updateAlarm(AlarmModel updatedAlarm) {
    int index = alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    if (index != -1) {
      alarms[index] = updatedAlarm;
      _saveAlarms();
      _scheduleNotification(updatedAlarm);
    }
  }

  void deleteAlarm(String alarmId) {
    alarms.removeWhere((alarm) => alarm.id == alarmId);
    _saveAlarms();
    _cancelNotification(alarmId);
    Get.snackbar('Success', 'Alarm deleted successfully!');
  }

  void toggleAlarm(String alarmId) {
    int index = alarms.indexWhere((alarm) => alarm.id == alarmId);
    if (index != -1) {
      final alarm = alarms[index];
      final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
      alarms[index] = updatedAlarm;
      _saveAlarms();

      if (updatedAlarm.isEnabled) {
        _scheduleNotification(updatedAlarm);
      } else {
        _cancelNotification(alarmId);
      }
    }
  }

  Future<void> _scheduleNotification(AlarmModel alarm) async {
    if (!alarm.isEnabled) return;

    await NotificationHelper.scheduleAlarm(
      id: alarm.id.hashCode,
      title: 'Alarm',
      body: alarm.label,
      scheduledTime: alarm.nextAlarmTime,
    );
  }

  Future<void> _cancelNotification(String alarmId) async {
    await NotificationHelper.cancelAlarm(alarmId.hashCode);
  }

  void navigateToAddAlarm() {
    Get.toNamed(AppRoutes.addAlarm);
  }

  void navigateToEditAlarm(AlarmModel alarm) {
    Get.toNamed(AppRoutes.editAlarm, arguments: alarm);
  }

  // Sort alarms by time
  List<AlarmModel> get sortedAlarms {
    final enabledAlarms = alarms.where((alarm) => alarm.isEnabled).toList();
    final disabledAlarms = alarms.where((alarm) => !alarm.isEnabled).toList();

    enabledAlarms.sort((a, b) => a.nextAlarmTime.compareTo(b.nextAlarmTime));
    disabledAlarms.sort((a, b) => a.nextAlarmTime.compareTo(b.nextAlarmTime));

    return [...enabledAlarms, ...disabledAlarms];
  }
}
