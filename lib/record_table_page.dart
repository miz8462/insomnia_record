import 'package:flutter/material.dart';
import 'package:insomnia_record/calc_sleep_data.dart';
import 'package:insomnia_record/objectbox.g.dart';
import 'package:insomnia_record/sleep_record.dart';
import 'package:intl/intl.dart';

double fontSizeS = 16;
double fontSizeM = 20;
double fontSizeL = 26;

class RecordTablePage extends StatefulWidget {
  const RecordTablePage(
      {super.key, required this.sleepRecords, required this.box});
  final List<SleepRecord> sleepRecords;
  final Box<SleepRecord>? box;

  @override
  State<RecordTablePage> createState() => _RecordTablePageState();
}

class _RecordTablePageState extends State<RecordTablePage> {
  static const int numItems = 7;

  CalcSleepData calc = CalcSleepData();
  String totalTimeInBed = "0";
  String totalSleepTime = "0";
  // 7日間平均
  String averageTotalTimeInBed = '1.0';
  String averageTotalSleepTime = '1.0';
  // カラム名
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
    return <DataColumn>[
      customDataColumn(createdAt),
      customDataColumn(timeForBed),
      customDataColumn(wakeUpTime),
      customDataColumn(sleepTime),
      customDataColumn(numberOfAwaking),
      customDataColumn(timeOfAwaking),
      customDataColumn(morningFeeling),
      customDataColumn(qualityOfSleep),
      customDataColumn(totalTimeInBed),
      customDataColumn(totalSleepTime),
      customDataColumn(sleepEfficiency),
    ];
  }

  DataColumn customDataColumn(String title) {
    return DataColumn(
      label: Expanded(
        child: Text(
          title,
          style: TextStyle(fontSize: fontSizeS),
        ),
      ),
    );
  }

  Future<void> deleteDialog(int id, Box<SleepRecord>? box) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('削除しますか？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              // データを削除しトップに戻る
              box?.remove(id),
              Navigator.popUntil(context, (route) => route.isFirst)
            },
            child: const Text('はい'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('いいえ'),
          ),
        ],
      ),
    );
  }

  List<DataRow> createDataCells(
      {required List<SleepRecord> sleepRecords,
      required Box<SleepRecord>? box}) {
    return List<DataRow>.generate(
      // データ数がnumItems(7)より小さいときも表が表示されるようにする
      (sleepRecords.length < numItems) ? sleepRecords.length : numItems,
      (index) => DataRow(
        cells: <DataCell>[
          DataCell(
            Text(
              DateFormat('MM/dd').format(sleepRecords[index].createdAt),
              style: TextStyle(
                fontSize: fontSizeS,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                // 日付に下線を付ける
                decoration: TextDecoration.underline,
                decorationColor: Colors.grey, // 下線の色を指定する場合
                decorationThickness: 2.0, // 下線の太さを指定する場合
                decorationStyle: TextDecorationStyle.solid, // 下線のスタイルを指定する場合
              ),
            ),
            onTap: () {
              // 削除モーダル表示
              deleteDialog(sleepRecords[index].id, box);
            },
          ),
          customDataCell(sleepRecords[index].timeForBed),
          customDataCell(sleepRecords[index].wakeUpTime),
          customDataCell(sleepRecords[index].sleepTime.toString()),
          customDataCell(sleepRecords[index].numberOfAwaking.toString()),
          customDataCell(sleepRecords[index].timeOfAwaking.toString()),
          customDataCell(sleepRecords[index].morningFeeling.toString()),
          customDataCell(sleepRecords[index].qualityOfSleep.toString()),
          customDataCell(totalTimeInBed = calc
              .calcTotalTimeInBed(
                  timeForBed: sleepRecords[index].timeForBed,
                  wakeUpTime: sleepRecords[index].wakeUpTime)
              .toString()),
          // DataCell(Text(totalTimeInBed = calc
          //     .calcTotalTimeInBed(
          //         timeForBed: sleepRecords[index].timeForBed,
          //         wakeUpTime: sleepRecords[index].wakeUpTime)
          //     .toString())),
          customDataCell(totalSleepTime = calc
              .calcTotalSleepTime(
                totalTimeInBed: totalTimeInBed,
                sleepTime: sleepRecords[index].sleepTime,
                timeOfAwaking: sleepRecords[index].timeOfAwaking,
              )
              .toString()),
          customDataCell(calc
              .calcSleepEfficiency(
                  totalSleepTime: totalSleepTime,
                  totalTimeInBed: totalTimeInBed)
              .toString()),
        ],
      ),
    );
  }

  DataCell customDataCell(String title,
      {FontWeight fontWeight = FontWeight.normal}) {
    return DataCell(Text(
      title,
      style: TextStyle(fontSize: fontSizeM, fontWeight: fontWeight),
    ));
  }

  void getNewSevenRecords() {
    var sleepRecords = widget.box?.getAll() ?? [];
    final query = widget.box
        ?.query(SleepRecord_.id.greaterThan(sleepRecords.length - 7))
        .build();
    if (query != null) {
      sleepRecords = query.find();
      query.close;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insomnia Record'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                DataTable(
                  columns: createColumns(),
                  rows: createDataCells(
                      sleepRecords: widget.sleepRecords, box: widget.box),
                ),
                DataTable(
                  headingRowHeight: 0,
                  columns: createColumns(),
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text(
                          '平均',
                          style: TextStyle(fontSize: fontSizeS),
                        )),
                        customDataCell(
                            calc.calcSevenDaysAverageTimeForBed(
                                sleepRecords: widget.sleepRecords),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            calc.calcSevenDaysAverageWakeUpTime(
                                sleepRecords: widget.sleepRecords),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            calc
                                .calcSevenDaysAverageSleepTime(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            calc
                                .calcSevenDaysAverageNumberOfAwaking(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            calc
                                .calcSevenDaysAverageTimeOfAwaking(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            calc
                                .calcSevenDaysAverageMorningFeeling(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            calc
                                .calcSevenDaysAverageQualityOfSleep(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            averageTotalTimeInBed = calc
                                .calcSevenDaysAverageTotalTimeInBed(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            averageTotalSleepTime = calc
                                .calcSevenDaysAverageTotalSleepTime(
                                    sleepRecords: widget.sleepRecords)
                                .toString(),
                            fontWeight: FontWeight.bold),
                        customDataCell(
                            ((() {
                              double sleepEfficiencyValue =
                                  (double.parse(averageTotalSleepTime) /
                                          double.parse(averageTotalTimeInBed)) *
                                      1000;
                              return sleepEfficiencyValue.isFinite
                                  ? (sleepEfficiencyValue.round() / 10)
                                      .toString()
                                  : '0.0';
                            })()),
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
