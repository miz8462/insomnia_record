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
          return SingleChildScrollView(
            child: Column(
              children: [
                Text('布団に入った時間: ${sleepRecord.timeForBed}'),
                Text('布団から出た時間: ${sleepRecord.wakeUpTime}'),
                Text('眠りにつくまでの時間: ${sleepRecord.sleepTime.toString()}'),
                Text('夜中に目覚めた回数: ${sleepRecord.numberOfAwaking.toString()}'),
                Text('夜中に目覚めてた時間: ${sleepRecord.timeOfAwaking.toString()}'),
                Text('朝の体調(5段階): ${sleepRecord.morningFeeling.toString()}'),
                Text('睡眠の質(5段階): ${sleepRecord.qualityOfSleep.toString()}'),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
