class SleepMinute {
  int hour;
  int minute;

  SleepMinute(int this.hour, int this.minute);

  @override
  get hashCode {
    return hour * 100 + minute;
  }

  @override
  bool operator ==(other) {
    return this.hour == other.hour && this.minute == other.minute;
  }
}