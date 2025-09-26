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
        _sortAlarms();
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
    _sortAlarms();
    _saveAlarms();
    _scheduleNotification(alarm);
  }

  void updateAlarm(AlarmModel updatedAlarm) {
    int index = alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    if (index != -1) {
      alarms[index] = updatedAlarm;
      _sortAlarms();
      _saveAlarms();
      _scheduleNotification(updatedAlarm);
    }
  }

  void deleteAlarm(String alarmId) {
    alarms.removeWhere((alarm) => alarm.id == alarmId);
    _sortAlarms();
    _saveAlarms();
    _cancelNotification(alarmId);
    Get.snackbar('Success', 'Alarm deleted successfully!');
  }

  void toggleAlarm(String alarmId) {
    if (kDebugMode) {
      print('=== TOGGLE ALARM DEBUG ===');
      print('Toggling alarm with ID: $alarmId');
      print('Current alarms list:');
      for (int i = 0; i < alarms.length; i++) {
        print(
            'Index $i: ID=${alarms[i].id}, enabled=${alarms[i].isEnabled}, time=${alarms[i].formattedTime}');
      }
    }

    int index = alarms.indexWhere((alarm) => alarm.id == alarmId);
    if (kDebugMode) {
      print('Found alarm at index: $index');
    }

    if (index != -1) {
      final alarm = alarms[index];
      if (kDebugMode) {
        print('Current alarm status: ${alarm.isEnabled}');
        print('Alarm details: ${alarm.toJson()}');
      }

      final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
      alarms[index] = updatedAlarm;
      _sortAlarms(); // Maintain consistent ordering after state change

      if (kDebugMode) {
        print('Updated alarm status: ${updatedAlarm.isEnabled}');
        print('Updated alarm details: ${updatedAlarm.toJson()}');
      }

      _saveAlarms();

      // Force UI update
      alarms.refresh();

      if (updatedAlarm.isEnabled) {
        _scheduleNotification(updatedAlarm);
      } else {
        _cancelNotification(alarmId);
      }

      if (kDebugMode) {
        print('=== AFTER UPDATE ===');
        for (int i = 0; i < alarms.length; i++) {
          print(
              'Index $i: ID=${alarms[i].id}, enabled=${alarms[i].isEnabled}, time=${alarms[i].formattedTime}');
        }
        print('=== END DEBUG ===');
      }
    } else {
      if (kDebugMode) {
        print('Alarm with ID $alarmId not found!');
      }
    }
  }

  // In-place sort to avoid UI index/id mismatch; keeps enabled first by next trigger time
  void _sortAlarms() {
    final enabledAlarms = alarms.where((a) => a.isEnabled).toList();
    final disabledAlarms = alarms.where((a) => !a.isEnabled).toList();
    enabledAlarms.sort((a, b) => a.nextAlarmTime.compareTo(b.nextAlarmTime));
    disabledAlarms.sort((a, b) => a.nextAlarmTime.compareTo(b.nextAlarmTime));
    final sorted = [...enabledAlarms, ...disabledAlarms];
    if (!_listEqualsById(sorted, alarms)) {
      alarms.assignAll(sorted);
    }
    if (kDebugMode) {
      print(
          'Sorted alarms order (in-place): ${alarms.map((a) => a.id).join(', ')}');
    }
  }

  bool _listEqualsById(List<AlarmModel> a, List<AlarmModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
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
}
