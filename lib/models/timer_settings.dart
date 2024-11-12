class TimerSettings {
  final int groupSize;
  final int minutes;
  final int seconds;
  final bool positionsEnabled;
  final bool neutralEnabled;
  final bool topEnabled;
  final bool bottomEnabled;
  final bool alarmEnabled;

  TimerSettings({
    required this.groupSize,
    required this.minutes,
    required this.seconds,
    required this.positionsEnabled,
    required this.neutralEnabled,
    required this.topEnabled,
    required this.bottomEnabled,
    required this.alarmEnabled,
  });

  Duration get duration => Duration(minutes: minutes, seconds: seconds);
}