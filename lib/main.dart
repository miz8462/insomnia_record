import 'package:flutter/material.dart';
import 'package:insomnia_record/objectbox.g.dart';
import 'package:insomnia_record/record_table_page.dart';
import 'package:insomnia_record/sleep_record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insomnia Record',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade200),
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
  String timeForBed = '00:00';

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
      body: Column(
        children: [
          const Text('布団に入った時間'),
          TextFormField(
            initialValue: timeForBed,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: データ登録
            
          // TODO: ページ遷移
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const RecordTablePage();
              },
            ),
          );
        },
        tooltip: 'add new record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
