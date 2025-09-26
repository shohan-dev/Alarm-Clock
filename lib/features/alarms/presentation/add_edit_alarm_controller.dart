import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import '../domain/alarm_model.dart';
import 'alarm_controller.dart';

class AddEditAlarmController extends GetxController {
  var selectedTime = DateTime.now().obs;
  var selectedDate = DateTime.now().obs;
  var alarmLabel = 'Alarm'.obs;
  var isEnabled = true.obs;

  AlarmModel? editingAlarm;

  @override
  void onInit() {
    super.onInit();

    // Check if we're editing an existing alarm
    if (Get.arguments is AlarmModel) {
      editingAlarm = Get.arguments as AlarmModel;
      selectedTime.value = editingAlarm!.time;
      selectedDate.value = editingAlarm!.date;
      alarmLabel.value = editingAlarm!.label;
      isEnabled.value = editingAlarm!.isEnabled;
    } else {
      // Set default time to current time + 1 minute
      final now = DateTime.now();
      selectedTime.value = now.add(const Duration(minutes: 1));
      selectedDate.value = now;
    }
  }

  void selectTime() {
    picker.DatePicker.showTimePicker(
      Get.context!,
      showTitleActions: true,
      currentTime: selectedTime.value,
      locale: picker.LocaleType.en,
      theme: const picker.DatePickerTheme(
        backgroundColor: Color(0xFF2D2D3D),
        itemStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        doneStyle: TextStyle(
          color: Color(0xFF6C5CE7),
          fontSize: 16,
        ),
        cancelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      onConfirm: (time) {
        selectedTime.value = time;
      },
    );
  }

  void selectDate() {
    picker.DatePicker.showDatePicker(
      Get.context!,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      currentTime: selectedDate.value,
      locale: picker.LocaleType.en,
      theme: const picker.DatePickerTheme(
        backgroundColor: Color(0xFF2D2D3D),
        itemStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        doneStyle: TextStyle(
          color: Color(0xFF6C5CE7),
          fontSize: 16,
        ),
        cancelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      onConfirm: (date) {
        selectedDate.value = date;
      },
    );
  }

  void saveAlarm() async {
    try {
      print('SaveAlarm called'); // Debug print

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final alarmId =
          editingAlarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final alarm = AlarmModel(
        id: alarmId,
        time: selectedTime.value,
        date: selectedDate.value,
        label: alarmLabel.value.isEmpty ? 'Alarm' : alarmLabel.value,
        isEnabled: isEnabled.value,
      );

      print('Alarm created: ${alarm.toJson()}'); // Debug print

      // Try to find the controller, if not found, create a new one
      AlarmController alarmController;
      try {
        alarmController = Get.find<AlarmController>();
        print('Controller found'); // Debug print
      } catch (e) {
        print('Controller not found, creating new one'); // Debug print
        alarmController = Get.put(AlarmController());
      }

      // Save the alarm
      if (editingAlarm != null) {
        alarmController.updateAlarm(alarm);
        print('Alarm updated'); // Debug print
      } else {
        alarmController.addAlarm(alarm);
        print('Alarm added'); // Debug print
      }

      // Add a small delay to ensure operations complete
      await Future.delayed(const Duration(milliseconds: 200));

      // Close loading dialog
      if (Get.isDialogOpen == true) {
        Get.back(); // Close loading dialog
      }

      print('About to navigate back'); // Debug print

      // Navigate back to home screen
      Get.back(); // Go back to previous screen

      // Show success message
      Get.snackbar(
        'Success',
        editingAlarm != null
            ? 'Alarm updated successfully!'
            : 'Alarm saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      print('Navigation completed'); // Debug print
    } catch (e) {
      print('Error in saveAlarm: $e'); // Debug print
      print('Stack trace: ${StackTrace.current}'); // Debug print

      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back(); // Close loading dialog
      }

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to save alarm: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Still navigate back even if there's an error
      try {
        Get.back();
        print('Navigated back after error'); // Debug print
      } catch (navError) {
        print('Navigation error: $navError'); // Debug print
      }
    }
  }

  String get formattedTime {
    final hour = selectedTime.value.hour;
    final minute = selectedTime.value.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String get formattedDate {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${selectedDate.value.day} ${months[selectedDate.value.month - 1]} ${selectedDate.value.year}';
  }
}
