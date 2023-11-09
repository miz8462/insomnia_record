import 'package:insomnia_record/sleep_record.dart';

class CalcSleepData {
  int calcTotalTimeInBed(
      {required String timeForBed, required String wakeUpTime}) {
    // Stringの時間データをintする
    final int hourTimeForBed = int.parse(timeForBed.substring(0, 2));
    final int minuteTimeForBed = int.parse(timeForBed.substring(3, 5));
    int hourWakeUpTime = int.parse(wakeUpTime.substring(0, 2));
    final int minuteWakeUpTime = int.parse(wakeUpTime.substring(3, 5));
    int totalHour;
    int totalMinute;

    // 起床時間から睡眠時間を引く
    if ((totalMinute = minuteWakeUpTime - minuteTimeForBed) < 0) {
      totalMinute += 60;
      hourWakeUpTime -= 1;
      if ((totalHour = hourWakeUpTime - hourTimeForBed) < 0) {
        totalHour += 24;
      }
    }
    if ((totalHour = hourWakeUpTime - hourTimeForBed) < 0) {
      totalHour += 24;
    }
    return totalHour * 60 + totalMinute;
  }

  int calcTotalSleepTime(
      {required String totalTimeInBed,
      required int sleepTime,
      required int timeOfAwaking}) {
    final intTotalTime = int.parse(totalTimeInBed);
    return (intTotalTime - (sleepTime + timeOfAwaking));
  }

  double calcSleepEfficiency(
      {required String totalSleepTime, required String totalTimeInBed}) {
    final intTotalSleepTime = int.parse(totalSleepTime);
    final intTotalTimeInBed = int.parse(totalTimeInBed);
    return ((intTotalSleepTime / intTotalTimeInBed) * 1000).round() / 10;
  }

  static const int oneHour = 60;
  static const int numItems = 7;

  String calcSevenDaysAverageTimeForBed(
      {required List<SleepRecord> sleepRecords}) {
    String result = "00:00";
    int totalMin = 0;
    int averageMin = 0;
    int averageHour = 0;
    // 時間を分になおす
    for (int i = 0; i < sleepRecords.length; i++) {
      final int hour = int.parse(sleepRecords[i].timeForBed.substring(0, 2));
      final int min = int.parse(sleepRecords[i].timeForBed.substring(3, 5));
      totalMin += hour * oneHour;
      totalMin += min;
    }
    if (sleepRecords.length < numItems) {
      averageMin = (totalMin / sleepRecords.length).round();
    } else {
      averageMin = (totalMin / numItems).round();
    }
    averageHour = averageMin ~/ oneHour;
    averageMin = averageMin % oneHour;
    result = '$averageHour:$averageMin';
    return result;
  }

  double calcSevenDaysAverageInt({required List<SleepRecord> sleepRecords}) {
    return 0;
  }

  double calcAverageSleepEfficiency(
      {required double averageTotalTimeInBed,
      required double averageTotalSleepTime}) {
    return ((averageTotalSleepTime / averageTotalTimeInBed * 1000).round() /
        10);
  }
}
