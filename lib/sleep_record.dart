import 'package:objectbox/objectbox.dart';

@Entity()
class SleepRecord {
  SleepRecord({
    required this.timeForBed,
    required this.wakeUpTime,
  });
  int id = 0;
  String timeForBed;
  String wakeUpTime;
}
