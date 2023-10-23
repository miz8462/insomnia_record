import 'package:objectbox/objectbox.dart';

@Entity()
class SleepRecord {
  SleepRecord({
    required this.timeForBed,
  });
  int id = 0;
  String timeForBed;
}
