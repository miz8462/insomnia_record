import 'package:flutter/material.dart';

class RecordTablePage extends StatefulWidget {
  const RecordTablePage({super.key});

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
        body: const Text('Madoka'));
  }
}
