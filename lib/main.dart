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

  Store? store;
  Box<SleepRecord>? sleepRecordBox;
  List<SleepRecord> sleepRecords = [];

  Future<void> initialize() async {
    store = await openStore();
    sleepRecordBox = store?.box<SleepRecord>();
    sleepRecords = sleepRecordBox?.getAll() ?? [];
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
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (text) {
                    morningFeeling = int.parse(text);
                  },
                  decoration: InputDecoration(
                    hintText: morningFeeling.toString(),
                  ),
                ),
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
            ElevatedButton(
              onPressed: () {
                // データを登録
                sleepRecordBox?.put(
                  SleepRecord(
                    createdAt: createdAt,
                    timeForBed: timeForBed,
                    wakeUpTime: wakeUpTime,
                    sleepTime: sleepTime,
                    numberOfAwaking: numberOfAwaking,
                    timeOfAwaking: timeOfAwaking,
                    morningFeeling: morningFeeling,
                    qualityOfSleep: qualityOfSleep,
                  ),
                );
                sleepRecords = sleepRecordBox?.getAll() ?? [];
                setState(() {});
                // 画面遷移
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecordTablePage(sleepRecords: sleepRecords);
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
          ],
        ),
      ),
    );
  }
}
