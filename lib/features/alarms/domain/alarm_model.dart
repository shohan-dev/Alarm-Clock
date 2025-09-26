class AlarmModel {
  final String id;
  final DateTime time;
  final DateTime date;
  final bool isEnabled;
  final String label;
  final List<int> repeatDays; // 1=Monday, 7=Sunday
  final String sound;

  AlarmModel({
    required this.id,
    required this.time,
    required this.date,
    this.isEnabled = true,
    this.label = 'Alarm',
    this.repeatDays = const [],
    this.sound = 'default',
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.millisecondsSinceEpoch,
      'date': date.millisecondsSinceEpoch,
      'isEnabled': isEnabled,
      'label': label,
      'repeatDays': repeatDays,
      'sound': sound,
    };
  }

  // Create from JSON
  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      isEnabled: json['isEnabled'] ?? true,
      label: json['label'] ?? 'Alarm',
      repeatDays: List<int>.from(json['repeatDays'] ?? []),
      sound: json['sound'] ?? 'default',
    );
  }

  // Copy with modifications
  AlarmModel copyWith({
    String? id,
    DateTime? time,
    DateTime? date,
    bool? isEnabled,
    String? label,
    List<int>? repeatDays,
    String? sound,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      time: time ?? this.time,
      date: date ?? this.date,
      isEnabled: isEnabled ?? this.isEnabled,
      label: label ?? this.label,
      repeatDays: repeatDays ?? this.repeatDays,
      sound: sound ?? this.sound,
    );
  }

  // Format time for display
  String get formattedTime {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Format time with AM/PM
  String get formattedTime12Hour {
    int hour = time.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  // Format date for display
  String get formattedDate {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Get next alarm time
  DateTime get nextAlarmTime {
    DateTime now = DateTime.now();
    DateTime alarmDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (alarmDateTime.isBefore(now)) {
      // If alarm time has passed today, set for tomorrow
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    return alarmDateTime;
  }
}
