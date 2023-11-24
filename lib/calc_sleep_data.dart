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

  // todo: 時刻の平均を求めるひとつの関数にする
  String calcSevenDaysAverageTimeForBed(
      {required List<SleepRecord> sleepRecords}) {
    String result = "00:00";
    int totalMin = 0;
    int averageMin = 0;
    int averageHour = 0;
    String strAverageMin = "00";
    String strAverageHour = "00";

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return result;
    }
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
    // 分や時間が一桁の場合、十の位に0を付ける
    if (averageHour < 10) {
      strAverageHour = '0$averageHour';
    } else {
      strAverageHour = '$averageHour';
    }
    if (averageMin < 10) {
      strAverageMin = '0$averageMin';
    } else {
      strAverageMin = '$averageMin';
    }
    result = '$strAverageHour:$strAverageMin';
    return result;
  }

  String calcSevenDaysAverageWakeUpTime(
      {required List<SleepRecord> sleepRecords}) {
    String result = "00:00";
    int totalMin = 0;
    int averageMin = 0;
    int averageHour = 0;
    String strAverageMin = "00";
    String strAverageHour = "00";

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return result;
    }

    // 時間を分になおす
    for (int i = 0; i < sleepRecords.length; i++) {
      final int hour = int.parse(sleepRecords[i].wakeUpTime.substring(0, 2));
      final int min = int.parse(sleepRecords[i].wakeUpTime.substring(3, 5));
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
    // 分や時間が一桁の場合、十の位に0を付ける
    if (averageHour < 10) {
      strAverageHour = '0$averageHour';
    } else {
      strAverageHour = '$averageHour';
    }
    if (averageMin < 10) {
      strAverageMin = '0$averageMin';
    } else {
      strAverageMin = '$averageMin';
    }
    result = '$strAverageHour:$strAverageMin';
    return result;
  }

  // todo: 数値の平均を求めるひとつの関数にする
  double calcSevenDaysAverageSleepTime(
      {required List<SleepRecord> sleepRecords}) {
    double total = 0;
    double average = 0;

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }
    // 合計を求める
    for (int i = 0; i < sleepRecords.length; i++) {
      total += sleepRecords[i].sleepTime;
    }
    // 平均を求める
    if (sleepRecords.length < numItems) {
      average = (((total / sleepRecords.length) * 10).round() / 10).toDouble();
    } else {
      average = (((total / numItems) * 10).round() / 10).toDouble();
    }

    return average;
  }

  double calcSevenDaysAverageNumberOfAwaking(
      {required List<SleepRecord> sleepRecords}) {
    double total = 0;
    double average = 0;

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }
    // 合計を求める
    for (int i = 0; i < sleepRecords.length; i++) {
      total += sleepRecords[i].numberOfAwaking;
    }
    // 平均を求める
    if (sleepRecords.length < numItems) {
      average = (((total / sleepRecords.length) * 10).round() / 10).toDouble();
    } else {
      average = (((total / numItems) * 10).round() / 10).toDouble();
    }

    return average;
  }

  double calcSevenDaysAverageTimeOfAwaking(
      {required List<SleepRecord> sleepRecords}) {
    double total = 0;
    double average = 0;

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }
    // 合計を求める
    for (int i = 0; i < sleepRecords.length; i++) {
      total += sleepRecords[i].timeOfAwaking;
    }
    // 平均を求める
    if (sleepRecords.length < numItems) {
      average = (((total / sleepRecords.length) * 10).round() / 10).toDouble();
    } else {
      average = (((total / numItems) * 10).round() / 10).toDouble();
    }

    return average;
  }

  double calcSevenDaysAverageMorningFeeling(
      {required List<SleepRecord> sleepRecords}) {
    double total = 0;
    double average = 0;

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }
    // 合計を求める
    for (int i = 0; i < sleepRecords.length; i++) {
      total += sleepRecords[i].morningFeeling;
    }
    // 平均を求める
    if (sleepRecords.length < numItems) {
      average = (((total / sleepRecords.length) * 10).round() / 10).toDouble();
    } else {
      average = (((total / numItems) * 10).round() / 10).toDouble();
    }

    return average;
  }

  double calcSevenDaysAverageQualityOfSleep(
      {required List<SleepRecord> sleepRecords}) {
    double total = 0;
    double average = 0;

    // レコードがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }
    // 合計を求める
    for (int i = 0; i < sleepRecords.length; i++) {
      total += sleepRecords[i].qualityOfSleep;
    }
    // 平均を求める
    if (sleepRecords.length < numItems) {
      average = (((total / sleepRecords.length) * 10).round() / 10).toDouble();
    } else {
      average = (((total / numItems) * 10).round() / 10).toDouble();
    }

    return average;
  }

  double calcSevenDaysAverageTotalTimeInBed(
      {required List<SleepRecord> sleepRecords}) {
    double average = 0.0;
    int sumTotalTime = 0;
    // 登録データがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }

    // 総臥床時間の週間合計
    for (int i = 0; i < sleepRecords.length; i++) {
      int totalTimeInBed = calcTotalTimeInBed(
          timeForBed: sleepRecords[i].timeForBed,
          wakeUpTime: sleepRecords[i].wakeUpTime);
      sumTotalTime += totalTimeInBed;
    }

    // 登録データが七つに満たない場合
    if (sleepRecords.length < numItems) {
      average = (((sumTotalTime / sleepRecords.length) * 10).round()) / 10;
    } else {
      average = (((sumTotalTime / numItems) * 10).round()) / 10;
    }
    return average;
  }
  double calcSevenDaysAverageTotalSleepTime(
      {required List<SleepRecord> sleepRecords}) {
    double average = 0.0;
    int sumTotalTime = 0;
    // 登録データがない場合
    if (sleepRecords.isEmpty) {
      return average;
    }

    // 総睡眠時間の週間合計
    for (int i = 0; i < sleepRecords.length; i++) {
      int totalTimeInBed = calcTotalTimeInBed(
          timeForBed: sleepRecords[i].timeForBed,
          wakeUpTime: sleepRecords[i].wakeUpTime);
      int totalSleepTime = calcTotalSleepTime(
                totalTimeInBed: totalTimeInBed.toString(),
                sleepTime: sleepRecords[i].sleepTime,
                timeOfAwaking: sleepRecords[i].timeOfAwaking,
              );
      sumTotalTime += totalSleepTime;
    }

    // 登録データが七つに満たない場合
    if (sleepRecords.length < numItems) {
      average = (((sumTotalTime / sleepRecords.length) * 10).round()) / 10;
    } else {
      average = (((sumTotalTime / numItems) * 10).round()) / 10;
    }
    return average;
  }  
}
