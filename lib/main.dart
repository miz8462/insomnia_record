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

  String timeForBed = '00:00';
  String wakeUpTime = '07:00';
  int sleepTime = 0;
  int numberOfAwaking = 0;
  int timeOfAwaking = 0;
  int morningFeeling = 1;
  int qualityOfSleep = 1;

  static List<String> listOneToFive = <String>[
    "1",
    "2",
    "3",
    "4",
    "5",
  ];

  String dropdownValueMorningFeeling = "3";
  String dropdownValueQualityOfSleep = "3";

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
                TextField(
                  onChanged: (text) {
                    timeForBed = text;
                  },
                  decoration: InputDecoration(
                    hintText: timeForBed,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text('布団から出た時間'),
                TextField(
                  onChanged: (text) {
                    wakeUpTime = text;
                  },
                  decoration: InputDecoration(
                    hintText: wakeUpTime,
                  ),
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
                    sleepTime = int.parse(text);
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
                    numberOfAwaking = int.parse(text);
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
                    timeOfAwaking = int.parse(text);
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
                        .map((String list) =>
                            DropdownMenuItem(value: list, child: Text(list)))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValueMorningFeeling = value!;
                      });
                    }),
              ],
            ),
            Column(
              children: [
                const Text('睡眠の質(5段階)'),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    qualityOfSleep = int.parse(text);
                  },
                  decoration: InputDecoration(
                    hintText: qualityOfSleep.toString(),
                  ),
                ),
              ],
            ),
            // フォームを登録しページ遷移するボタン
            ElevatedButton(
              onPressed: () {
                // データを登録
                box?.put(
                  SleepRecord(
                    createdAt: createdAt,
                    timeForBed: timeForBed,
                    wakeUpTime: wakeUpTime,
                    sleepTime: sleepTime,
                    numberOfAwaking: numberOfAwaking,
                    timeOfAwaking: timeOfAwaking,
                    morningFeeling: int.parse(dropdownValueMorningFeeling),
                    qualityOfSleep: qualityOfSleep,
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
