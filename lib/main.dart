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

  Future<void> initialize() async {
    store = await openStore();
    box = store?.box<SleepRecord>();
    getNewSevenRecords();
  }

  void getNewSevenRecords() {
    sleepRecords = box?.getAll() ?? [];
    final query = box
        ?.query(SleepRecord_.id.greaterThan(sleepRecords.length - 7))
        .build();
    sleepRecords = query!.find();
    query.close;
    // box?.removeAll();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // todo:同じ関数が二つ。リファクタ
  Future<void> _selectTimeForBed(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTimeForBed = const TimeOfDay(hour: 0, minute: 0),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        selectedTimeForBed = picked;
      });
    }
  }

  // todo:同じ関数が二つ。リファクタ
  Future<void> _selectWakeUpTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedWakeUpTime = const TimeOfDay(hour: 0, minute: 0),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        });

    if (picked != null) {
      setState(() {
        selectedWakeUpTime = picked;
      });
    }
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
            // TODO: widgetを作成
            Column(
              children: [
                const Text('布団に入った時間'),
                Text(
                    ('${selectedTimeForBed.hour.toString().padLeft(2, "0")}:${selectedTimeForBed.minute.toString().padLeft(2, "0")}')),
                ElevatedButton(
                  onPressed: () => {
                    _selectTimeForBed(context),
                  },
                  child: const Text('時刻選択'),
                ),
              ],
            ),
            Column(
              children: [
                const Text('布団から出た時間'),
                Text(
                    ('${selectedWakeUpTime.hour.toString().padLeft(2, "0")}:${selectedWakeUpTime.minute.toString().padLeft(2, "0")}')),
                ElevatedButton(
                  onPressed: () => {
                    _selectWakeUpTime(context),
                  },
                  child: const Text('時刻選択'),
                ),
              ],
            ),
            Column(
              children: [
                const Text('寝付くまでの時間'),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      sleepTime = int.parse(text);
                    } else {
                      sleepTime = 0;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: sleepTime.toString(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text('夜中目覚めた回数'),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      numberOfAwaking = int.parse(text);
                    } else {
                      numberOfAwaking = 0;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: numberOfAwaking.toString(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text('夜中目覚めてた時間'),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      timeOfAwaking = int.parse(text);
                    } else {
                      timeOfAwaking = 0;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: timeOfAwaking.toString(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text('朝の気分(5段階)'),
                DropdownButton(
                    value: dropdownValueMorningFeeling,
                    items: listOneToFive
                        .map((int list) => DropdownMenuItem(
                            value: list, child: Text(list.toString())))
                        .toList(),
                    onChanged: (int? value) {
                      setState(() {
                        dropdownValueMorningFeeling = value!;
                      });
                    }),
              ],
            ),
            Column(
              children: [
                const Text('睡眠の質(5段階)'),
                DropdownButton(
                    value: dropdownValueQualityOfSleep,
                    items: listOneToFive
                        .map((int list) => DropdownMenuItem(
                            value: list, child: Text(list.toString())))
                        .toList(),
                    onChanged: (int? value) {
                      setState(() {
                        dropdownValueQualityOfSleep = value!;
                      });
                    }),
              ],
            ),
            // フォームを登録しページ遷移するボタン
            ElevatedButton(
              onPressed: () {
                // データを登録
                box?.put(
                  SleepRecord(
                    createdAt: createdAt,
                    timeForBed:
                        '${selectedTimeForBed.hour.toString().padLeft(2, "0")}:${selectedTimeForBed.minute.toString().padLeft(2, "0")}', // todo:リファクタ
                    wakeUpTime:
                        '${selectedWakeUpTime.hour.toString().padLeft(2, "0")}:${selectedWakeUpTime.minute.toString().padLeft(2, "0")}',
                    sleepTime: sleepTime,
                    numberOfAwaking: numberOfAwaking,
                    timeOfAwaking: timeOfAwaking,
                    morningFeeling: dropdownValueMorningFeeling,
                    qualityOfSleep: dropdownValueQualityOfSleep,
                  ),
                );
                getNewSevenRecords();
                // 画面遷移
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecordTablePage(
                          sleepRecords: sleepRecords, box: box);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade200,
                foregroundColor: Colors.brown.shade800,
              ),
              child: const Text("登録"),
            ),
            // テーブルページに遷移するだけのボタン
            ElevatedButton(
              onPressed: () {
                getNewSevenRecords();
                // 画面遷移
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecordTablePage(
                          sleepRecords: sleepRecords, box: box);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade200,
                foregroundColor: Colors.brown.shade800,
              ),
              child: const Text("週間データを表示"),
            ),
          ],
        ),
      ),
    );
  }
}
