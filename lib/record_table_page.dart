import 'package:flutter/material.dart';
import 'package:insomnia_record/sleep_record.dart';

class RecordTablePage extends StatefulWidget {
  const RecordTablePage({super.key, required this.sleepRecords});
  final List<SleepRecord> sleepRecords;

  @override
  State<RecordTablePage> createState() => _RecordTablePageState();
}

class _RecordTablePageState extends State<RecordTablePage> {
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
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('01/17')),
                  DataCell(Text('02:00')),
                  DataCell(Text('10:00')),
                  DataCell(Text('30')),
                  DataCell(Text('2')),
                  DataCell(Text('20')),
                  DataCell(Text('4')),
                  DataCell(Text('5')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
