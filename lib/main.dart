import 'package:barnklocka2/gamestate.dart';
import 'package:barnklocka2/gamestats.dart';
import 'package:barnklocka2/toplist.dart';
import 'package:intl/intl.dart';

import 'package:barnklocka2/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:audioplayers/audioplayers.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

const _name = 'Johans Barnklocka II';
const _ampm = [
  // 0-5
  'Midnight',
  'Morning',
  'Morning',
  'Morning',
  'Morning',
  'Morning',
  // 6-11
  'Morning',
  'Morning',
  'Morning',
  'Morning',
  'Morning',
  'Morning',
  // 12-17
  'Noon',
  'Afternoon',
  'Afternoon',
  'Afternoon',
  'Afternoon',
  'Afternoon',
  // 18-23
  'Evening',
  'Evening',
  'Evening',
  'Evening',
  'Evening',
  'Evening',
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _name,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _errorText;
  final GameState _gameState = GameState();

  late AudioPlayer _audioPlayer;
  late TextEditingController _timeInputController;
  late FocusNode _timeInputFocus;

  @override
  void initState() {
    // Do the opposite of dispose() here

    super.initState();

    _timeInputController = TextEditingController();
    _timeInputFocus = FocusNode();

    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    // Do the opposite of initState() here

    _audioPlayer.release();

    _timeInputFocus.dispose();
    _timeInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Column ui;
    if (_gameState.shouldShowStartScreen) {
      ui = _startScreen();
    } else {
      ui = _gameUi();
    }

    return Scaffold(
      appBar: AppBar(title: const Text(_name)),
      body: Container(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          constraints: const BoxConstraints(
              maxWidth:
                  400 // FIXME: What is the unit here? How will this look on different devices?
              ),
          child: ui,
        ),
      ),
    );
  }

  String _durationToString(Duration duration) {
    int minutes = duration.inSeconds ~/ 60;
    int milliseconds = duration.inMilliseconds % 60000;

    if (minutes == 0) {
      return '${(milliseconds / 1000).toStringAsFixed(3)}s';
    } else {
      NumberFormat secondsFormat = NumberFormat('00.###');
      return '${minutes}m${secondsFormat.format(milliseconds / 1000.0)}s';
    }
  }

  Widget _topListToWidget(TopList topList) {
    assert(!topList.isEmpty);

    final List<DataColumn> columns = [
      const DataColumn(
          label: Text('Correct'), tooltip: 'Correct on first attempt'),
      const DataColumn(label: Text('Duration')),
      const DataColumn(label: SizedBox.shrink()),
    ];

    List<DataRow> rows = [];
    for (int i = 0; i < topList.list.length; i++) {
      GameStats stats = topList.list[i];
      String lastCell = '';
      if (i == topList.mostRecentEntry) {
        lastCell = '<- You'; // ... are here
      }

      rows.add(DataRow(cells: [
        DataCell(Text(
            '${stats.correctOnFirstAttempt}/${GameState.questionsPerGame}')),
        DataCell(Text(_durationToString(stats.duration))),
        DataCell(Text(lastCell))
      ]));
    }

    return DataTable(columns: columns, rows: rows);
  }

  Column _startScreen() {
    List<Widget> widgets = [];

    TopList topList = _gameState.topList;
    if (!topList.isEmpty) {
      widgets.add(_topListToWidget(topList));
    }

    widgets.add(SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              _gameState.start();
            });
          },
          autofocus: true,
          child: const Text('Start')),
    ));

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: widgets);
  }

  Column _gameUi() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      ////////////////////////////////////////////////////
      //
      // Clock
      //
      Flexible(
        child: Clock(
          _gameState.timestamp.hour,
          _gameState.timestamp.minute,
        ),
      ),
      ////////////////////////////////////////////////////
      //
      // AM / PM text
      //
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _ampm[_gameState.timestamp.hour],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 35),
        ),
      ),
      ////////////////////////////////////////////////////
      //
      // Answer entry row
      //
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _timeInputController,
              focusNode: _timeInputFocus,
              autofocus: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'HHMM',
                  labelText: 'Digital time',
                  errorText: _errorText),
              onSubmitted: (String _) {
                // FIXME: Only if the input looks like a time!
                _handleAnswer();
              },
            ),
          ),
          Flexible(
            flex: 0,
            child: ElevatedButton(
                onPressed: _handleAnswer, child: const Text('Go!')),
          )
        ],
      )
    ]);
  }

  void _handleAnswer() {
    if (_gameState.registerAnswer(_timeInputController.text, () {
      setState(() {});
    })) {
      // Ding!
      _audioPlayer.play(AssetSource('correct.mp3'));

      _timeInputController.clear();
      setState(() {
        _errorText = null;
      });
    } else {
      final twoDigits = NumberFormat('00');
      final hour = _gameState.timestamp.hour;
      final minute = _gameState.timestamp.minute;
      setState(() {
        _errorText =
            'Should be: ${twoDigits.format(hour)}${twoDigits.format(minute)}';
      });
    }

    _timeInputFocus.requestFocus();
  }
}
