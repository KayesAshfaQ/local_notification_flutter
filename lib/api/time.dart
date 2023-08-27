class Time {
  final int hour;
  final int minute;
  final int second;

  const Time({this.hour = 0, this.minute = 0, this.second = 0});

  factory Time.fromDateTime(DateTime dateTime) {
    return Time(
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );
  }

  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute, second);
  }
}