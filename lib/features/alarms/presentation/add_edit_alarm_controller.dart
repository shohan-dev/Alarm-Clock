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

  void saveAlarm() {
    final alarmId =
        editingAlarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final alarm = AlarmModel(
      id: alarmId,
      time: selectedTime.value,
      date: selectedDate.value,
      label: alarmLabel.value,
      isEnabled: isEnabled.value,
    );

    final alarmController = Get.find<AlarmController>();

    if (editingAlarm != null) {
      alarmController.updateAlarm(alarm);
    } else {
      alarmController.addAlarm(alarm);
    }

    Get.back();
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
