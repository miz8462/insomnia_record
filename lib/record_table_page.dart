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
            rows: List<DataRow>.generate(
              7,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
