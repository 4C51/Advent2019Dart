class DateTimeRange {
  DateTime start;
  DateTime end;
  Duration duration;

  DateTimeRange(DateTime this.start, DateTime this.end) {
    duration = end.difference(start);
  }
}