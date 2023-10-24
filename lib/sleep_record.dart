import 'package:objectbox/objectbox.dart';

@Entity()
class SleepRecord {
  SleepRecord({
    required this.timeForBed,
    required this.wakeUpTime,
    required this.sleepTime,
    required this.numberOfAwaking,
    required this.timeOfAwaking,
    required this.morningFeeling,
    required this.qualityOfSleep,
  });

  int id = 0;
  String timeForBed;
  String wakeUpTime;
  int sleepTime;
  int numberOfAwaking;
  int timeOfAwaking;
  int morningFeeling;
  int qualityOfSleep;
}
