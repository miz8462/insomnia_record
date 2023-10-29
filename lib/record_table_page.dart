import 'package:flutter/material.dart';
import 'package:insomnia_record/calc_sleep_data.dart';
import 'package:insomnia_record/sleep_record.dart';
import 'package:intl/intl.dart';

class RecordTablePage extends StatefulWidget {
  const RecordTablePage({super.key, required this.sleepRecords});
  final List<SleepRecord> sleepRecords;

  @override
  State<RecordTablePage> createState() => _RecordTablePageState();
}

class _RecordTablePageState extends State<RecordTablePage> {
  CalcSleepData calc = CalcSleepData();
  String totalTimeInBed = "0";
  String totalSleepTime = "0";
  static const int numItems = 7;

  // 7日間平均
  // TODO: average関数で初期化する
  final double averageTimeForBed = 0.0;
  final double averageWakeUpTime = 0.0;
  final double averageSleepTime = 0.0;
  final double averageNumberOfAwaking = 0.0;
  final double averageTimeOfAwaking = 0.0;
  final double averageMorningFeeling = 0.0;
  final double averageQualityOfSleep = 0.0;
  final double averageTotalTimeInBed = 0.0;
  final double averageTotalSleepTime = 0.0;

  List<DataColumn> createColumns() {
    const String createdAt = "日付";
    const String timeForBed = "布団に入った時間";
    const String wakeUpTime = "布団から出た時間";
    const String sleepTime = "眠りにつくまでの時間";
    const String numberOfAwaking = "夜中に目覚めた回数";
    const String timeOfAwaking = "夜中に目覚めてた時間";
    const String morningFeeling = "朝の体調(5段階)";
    const String qualityOfSleep = "睡眠の質(5段階)";
    const String totalTimeInBed = "総臥床時間";
    const String totalSleepTime = "総睡眠時間";
    const String sleepEfficiency = "睡眠効率";
    return const <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text(createdAt),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(timeForBed),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(wakeUpTime),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(sleepTime),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(numberOfAwaking),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(timeOfAwaking),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(morningFeeling),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(qualityOfSleep),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(totalTimeInBed),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(totalSleepTime),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(sleepEfficiency),
        ),
      ),
    ];
  }

  List<DataRow> createDataCells({required List<SleepRecord> sleepRecords}) {
    return List<DataRow>.generate(
      // TODO: データ数がnumItems(7)より小さいときも表が表示されるようにする
      numItems,
      (index) => DataRow(
        cells: <DataCell>[
          // TODO: 修正、削除のモーダル
          DataCell(
              Text(DateFormat('MM/dd').format(sleepRecords[index].createdAt))),
          DataCell(Text(sleepRecords[index].timeForBed)),
          DataCell(Text(sleepRecords[index].wakeUpTime)),
          DataCell(Text((sleepRecords[index].sleepTime.toString()))),
          DataCell(Text(sleepRecords[index].numberOfAwaking.toString())),
          DataCell(Text(sleepRecords[index].timeOfAwaking.toString())),
          DataCell(Text(sleepRecords[index].morningFeeling.toString())),
          DataCell(Text(sleepRecords[index].qualityOfSleep.toString())),
          DataCell(Text(totalTimeInBed = calc
              .calcTotalTimeInBed(
                  timeForBed: sleepRecords[index].timeForBed,
                  wakeUpTime: sleepRecords[index].wakeUpTime)
              .toString())),
          DataCell(Text(totalSleepTime = calc
              .calcTotalSleepTime(
                totalTimeInBed: totalTimeInBed,
                sleepTime: widget.sleepRecords[index].sleepTime,
                timeOfAwaking: widget.sleepRecords[index].timeOfAwaking,
              )
              .toString())),
          DataCell(Text(calc
              .calcSleepEfficiency(
                  totalSleepTime: totalSleepTime,
                  totalTimeInBed: totalTimeInBed)
              .toString())),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // TODO: 戻るボタン
        appBar: AppBar(
          title: const Text('Insomnia Record'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              DataTable(
                columns: createColumns(),
                rows: createDataCells(sleepRecords: widget.sleepRecords),
              ),
              // DataTable(columns: columns, rows: rows)
            ],
          ),
        ),
      ),
    );
  }
}
