// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insomnia_record/objectbox.g.dart';
import 'package:insomnia_record/record_table_page.dart';
import 'package:insomnia_record/sleep_record.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() =>
    initializeDateFormatting("ja-JP", null).then((_) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insomnia Record',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const InsomniaRecordHomePage(title: 'Insomnia Record'),
    );
  }
}

class InsomniaRecordHomePage extends StatefulWidget {
  const InsomniaRecordHomePage({super.key, required this.title});

  final String title;

  @override
  State<InsomniaRecordHomePage> createState() => _InsomniaRecordHomePageState();
}

class _InsomniaRecordHomePageState extends State<InsomniaRecordHomePage> {
  final DateTime createdAt = DateTime.now();
  TimeOfDay selectedTimeForBed = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedWakeUpTime = const TimeOfDay(hour: 07, minute: 00);

  String timeForBed = '00:00';
  String wakeUpTime = '07:00';
  int sleepTime = 0;
  int numberOfAwaking = 0;
  int timeOfAwaking = 0;
  int morningFeeling = 1;
  int qualityOfSleep = 1;

  static List<int> listOneToFive = <int>[
    1,
    2,
    3,
    4,
    5,
  ];

  int dropdownValueMorningFeeling = 3;
  int dropdownValueQualityOfSleep = 3;

  Store? store;
  Box<SleepRecord>? box;
  List<SleepRecord> sleepRecords = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      store = await openStore();
      box = store?.box<SleepRecord>();
      _getNewSevenRecords();
    } catch (e) {
      print('初期化に失敗しました: $e');
    }
  }

  void _getNewSevenRecords() {
    sleepRecords = box?.getAll() ?? [];
    final query = box
        ?.query(SleepRecord_.id.greaterThan(sleepRecords.length - 7))
        .build();
    if (query != null) {
      sleepRecords = query.find();
      query.close(); // メソッドであることに注意
    }
    // box?.removeAll();
    setState(() {});
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        onTimeSelected(picked);
      });
    }
  }

  // 時刻入力ウィジェット
  // _selectTimeForBedと_selectWakeUpTimeを共通メソッドで呼び出し
  Future<void> _selectTimeForBed(BuildContext context) async {
    _selectTime(context, selectedTimeForBed, (picked) {
      selectedTimeForBed = picked;
    });
  }

  Future<void> _selectWakeUpTime(BuildContext context) async {
    _selectTime(context, selectedWakeUpTime, (picked) {
      selectedWakeUpTime = picked;
    });
  }

  Widget _buildTimeSelectionWidget(
    String label,
    TimeOfDay selectedTime,
    Function(BuildContext) onPressed,
  ) {
    return Column(
      children: [
        Text(label),
        Text(
          ('${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}'),
        ),
        ElevatedButton(
          onPressed: () => onPressed(context),
          child: const Text('時刻選択'),
        ),
      ],
    );
  }

  // _selectTimeForBedと_selectWakeUpTimeの呼び出しを共通メソッドで置き換え
  Widget buildTimeForBedWidget() {
    return _buildTimeSelectionWidget(
      '布団に入った時間',
      selectedTimeForBed,
      _selectTimeForBed,
    );
  }

  Widget buildWakeUpTimeWidget() {
    return _buildTimeSelectionWidget(
      '布団から出た時間',
      selectedWakeUpTime,
      _selectWakeUpTime,
    );
  }

  // 数値入力ウィジェット
  Widget _buildNumberInputWidget(
    String label,
    int value,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(label),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (text) {
            if (text.isNotEmpty) {
              onChanged(int.parse(text));
            } else {
              onChanged(0);
            }
          },
          decoration: InputDecoration(
            hintText: value.toString(),
          ),
        ),
      ],
    );
  }

  Widget buildSleepTimeWidget() {
    return _buildNumberInputWidget(
      '寝付くまでの時間',
      sleepTime,
      (value) {
        setState(() {
          sleepTime = value;
        });
      },
    );
  }

  Widget buildNumberOfAwakingWidget() {
    return _buildNumberInputWidget(
      '夜中目覚めた回数',
      numberOfAwaking,
      (value) {
        setState(() {
          numberOfAwaking = value;
        });
      },
    );
  }

  Widget buildTimeOfAwakingWidget() {
    return _buildNumberInputWidget(
      '夜中目覚めてた時間',
      timeOfAwaking,
      (value) {
        setState(() {
          timeOfAwaking = value;
        });
      },
    );
  }

  // ドロップダウンメニューウィジェット
  Widget _buildDropdownWidget(
    String label,
    int value,
    List<int> items,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(label),
        DropdownButton(
          value: value,
          items: items
              .map((int item) =>
                  DropdownMenuItem(value: item, child: Text(item.toString())))
              .toList(),
          onChanged: (int? selectedValue) {
            setState(() {
              onChanged(selectedValue!);
            });
          },
        ),
      ],
    );
  }

  Widget buildMorningFeelingDropdownWidget() {
    return _buildDropdownWidget(
      '朝の気分(5段階)',
      dropdownValueMorningFeeling,
      listOneToFive,
      (value) {
        dropdownValueMorningFeeling = value;
      },
    );
  }

  Widget buildQualityOfSleepDropdownWidget() {
    return _buildDropdownWidget(
      '睡眠の質(5段階)',
      dropdownValueQualityOfSleep,
      listOneToFive,
      (value) {
        dropdownValueQualityOfSleep = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // フォームウィジェット
            buildTimeForBedWidget(),
            buildWakeUpTimeWidget(),
            buildSleepTimeWidget(),
            buildNumberOfAwakingWidget(),
            buildTimeOfAwakingWidget(),
            buildMorningFeelingDropdownWidget(),
            buildQualityOfSleepDropdownWidget(),
            // フォームを登録しページ遷移するボタン
            CustomActionButton(
              onPressed: () {
                box?.put(
                  SleepRecord(
                    createdAt: createdAt,
                    timeForBed:
                        '${selectedTimeForBed.hour.toString().padLeft(2, "0")}:${selectedTimeForBed.minute.toString().padLeft(2, "0")}',
                    wakeUpTime:
                        '${selectedWakeUpTime.hour.toString().padLeft(2, "0")}:${selectedWakeUpTime.minute.toString().padLeft(2, "0")}',
                    sleepTime: sleepTime,
                    numberOfAwaking: numberOfAwaking,
                    timeOfAwaking: timeOfAwaking,
                    morningFeeling: dropdownValueMorningFeeling,
                    qualityOfSleep: dropdownValueQualityOfSleep,
                  ),
                );
                _getNewSevenRecords();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecordTablePage(
                        sleepRecords: sleepRecords,
                        box: box,
                      );
                    },
                  ),
                );
              },
              text: "登録",
            ),

            CustomActionButton(
              onPressed: () {
                _getNewSevenRecords();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecordTablePage(
                        sleepRecords: sleepRecords,
                        box: box,
                      );
                    },
                  ),
                );
              },
              text: "週間データを表示",
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // データを登録
            //     box?.put(
            //       SleepRecord(
            //         createdAt: createdAt,
            //         timeForBed:
            //             '${selectedTimeForBed.hour.toString().padLeft(2, "0")}:${selectedTimeForBed.minute.toString().padLeft(2, "0")}', // todo:リファクタ
            //         wakeUpTime:
            //             '${selectedWakeUpTime.hour.toString().padLeft(2, "0")}:${selectedWakeUpTime.minute.toString().padLeft(2, "0")}',
            //         sleepTime: sleepTime,
            //         numberOfAwaking: numberOfAwaking,
            //         timeOfAwaking: timeOfAwaking,
            //         morningFeeling: dropdownValueMorningFeeling,
            //         qualityOfSleep: dropdownValueQualityOfSleep,
            //       ),
            //     );
            //     _getNewSevenRecords();
            //     // 画面遷移
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return RecordTablePage(
            //               sleepRecords: sleepRecords, box: box);
            //         },
            //       ),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.orange.shade200,
            //     foregroundColor: Colors.brown.shade800,
            //   ),
            //   child: const Text("登録"),
            // ),
            // // テーブルページに遷移するだけのボタン
            // ElevatedButton(
            //   onPressed: () {
            //     _getNewSevenRecords();
            //     // 画面遷移
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return RecordTablePage(
            //               sleepRecords: sleepRecords, box: box);
            //         },
            //       ),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.orange.shade200,
            //     foregroundColor: Colors.brown.shade800,
            //   ),
            //   child: const Text("週間データを表示"),
            // ),
          ],
        ),
      ),
    );
  }
}

// ボタンウィジェット
class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomActionButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade200,
        foregroundColor: Colors.brown.shade800,
      ),
      child: Text(text),
    );
  }
}
