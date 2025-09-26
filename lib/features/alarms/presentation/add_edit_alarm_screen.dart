import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/app_dimensions.dart';
import '../../../constants/app_strings.dart';
import 'add_edit_alarm_controller.dart';

class AddEditAlarmScreen extends StatelessWidget {
  const AddEditAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddEditAlarmController());
    final isEditing = controller.editingAlarm != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? AppStrings.editAlarm : AppStrings.addAlarm,
          style: AppTextStyles.heading3,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.paddingLarge),

              // Time selection
              const Text(
                AppStrings.alarmTime,
                style: AppTextStyles.heading4,
              ),

              const SizedBox(height: AppDimensions.paddingMedium),

              GestureDetector(
                onTap: () => controller.selectTime(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            controller.formattedTime,
                            style: AppTextStyles.timeDisplay,
                          )),
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primary,
                        size: AppDimensions.iconMedium,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXLarge),

              // Date selection
              const Text(
                AppStrings.alarmDate,
                style: AppTextStyles.heading4,
              ),

              const SizedBox(height: AppDimensions.paddingMedium),

              GestureDetector(
                onTap: () => controller.selectDate(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            controller.formattedDate,
                            style: AppTextStyles.bodyLarge,
                          )),
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: AppDimensions.iconMedium,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXLarge),

              // Alarm label
              const Text(
                'Label',
                style: AppTextStyles.heading4,
              ),

              const SizedBox(height: AppDimensions.paddingMedium),

              TextFormField(
                initialValue: controller.alarmLabel.value,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter alarm label',
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMedium),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => controller.alarmLabel.value = value,
              ),

              const Spacer(),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.saveAlarm(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.buttonRadius),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingMedium,
                    ),
                  ),
                  child: const Text(
                    AppStrings.save,
                    style: AppTextStyles.buttonLarge,
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
