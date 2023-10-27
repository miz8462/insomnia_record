import 'package:flutter/material.dart';
import 'package:insomnia_record/sleep_record.dart';
import 'package:intl/intl.dart';

class RecordTablePage extends StatefulWidget {
  const RecordTablePage({super.key, required this.sleepRecords});
  final List<SleepRecord> sleepRecords;

  @override
  State<RecordTablePage> createState() => _RecordTablePageState();
}

class _RecordTablePageState extends State<RecordTablePage> {
  int calcTotalTimeInBed(
      {required String timeForBed, required String wakeUpTime}) {
    // Stringの時間データをintする
    final int hourTimeForBed = int.parse(timeForBed.substring(0, 2));
    final int minuteTimeForBed = int.parse(timeForBed.substring(3, 5));
    int hourWakeUpTime = int.parse(wakeUpTime.substring(0, 2));
    final int minuteWakeUpTime = int.parse(wakeUpTime.substring(3, 5));
    int totalHour;
    int totalMinute;
    int totalTime;

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
    totalTime = totalHour * 60 + totalMinute;
    return totalTime;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Insomnia Record'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text('日付'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('布団に入った時間'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('布団から出た時間'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('眠りにつくまでの時間'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('夜中に目覚めた回数'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('夜中に目覚めてた時間'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('朝の体調(5段階)'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('睡眠の質(5段階)'),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text('総臥床時間'),
                ),
              ),
              // DataColumn(
              //   label: Expanded(
              //     child: Text('総睡眠時間'),
              //   ),
              // ),
              // DataColumn(
              //   label: Expanded(
              //     child: Text('睡眠効率'),
              //   ),
              // ),
            ],
            rows: List<DataRow>.generate(
              1,
              (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(DateFormat('MM/dd')
                          .format(widget.sleepRecords[index].createdAt)
                      // '${widget.sleepRecords[index].createdAt.month}/${widget.sleepRecords[index].createdAt.day}'
                      )),
                  DataCell(Text(widget.sleepRecords[index].timeForBed)),
                  DataCell(Text(widget.sleepRecords[index].wakeUpTime)),
                  DataCell(
                      Text((widget.sleepRecords[index].sleepTime.toString()))),
                  DataCell(Text(
                      widget.sleepRecords[index].numberOfAwaking.toString())),
                  DataCell(Text(
                      widget.sleepRecords[index].timeOfAwaking.toString())),
                  DataCell(Text(
                      widget.sleepRecords[index].morningFeeling.toString())),
                  DataCell(Text(
                      widget.sleepRecords[index].qualityOfSleep.toString())),
                  DataCell(Text(calcTotalTimeInBed(
                          timeForBed: widget.sleepRecords[index].timeForBed,
                          wakeUpTime: widget.sleepRecords[index].wakeUpTime)
                      .toString())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
