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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insomnia Record'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: widget.sleepRecords.length,
        itemBuilder: (context, index) {
          Text(widget.sleepRecords[index].timeForBed);
          final sleepRecord = widget.sleepRecords[index];
          return Column(
            children: [
              Text(sleepRecord.timeForBed),
              Text(sleepRecord.wakeUpTime),
            ],
          );
        },
      ),
    );
  }
}
