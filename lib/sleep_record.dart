import 'package:objectbox/objectbox.dart';

@Entity()
class SleepRecord {
  SleepRecord({
    required this.createdAt,
    required this.timeForBed,
    required this.wakeUpTime,
    required this.sleepTime,
    required this.numberOfAwaking,
    required this.timeOfAwaking,
    required this.morningFeeling,
    required this.qualityOfSleep,
  });

  int id = 0;
  DateTime createdAt;
  String timeForBed;
  String wakeUpTime;
  int sleepTime;
  int numberOfAwaking;
  int timeOfAwaking;
  int morningFeeling;
  int qualityOfSleep;
}
