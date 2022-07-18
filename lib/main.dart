import 'package:barnklocka2/gamestate.dart';
import 'package:barnklocka2/gamestats.dart';
import 'package:barnklocka2/toplist.dart';
import 'package:intl/intl.dart';

import 'package:barnklocka2/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

const _name = 'Johans Barnklocka II';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _name,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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

  /// NumberFormat with the right locale
  NumberFormat _numberFormat(String format) {
    return NumberFormat(format, Localizations.localeOf(context).toString());
  }

  String _durationToString(Duration duration) {
    int minutes = duration.inSeconds ~/ 60;
    int milliseconds = duration.inMilliseconds % 60000;

    if (minutes == 0) {
      final secondsFormat = _numberFormat('#0.000');
      return '${secondsFormat.format(milliseconds / 1000)}s';
    } else {
      final secondsFormat = _numberFormat('00.000');
      return '${minutes}m${secondsFormat.format(milliseconds / 1000.0)}s';
    }
  }

  Widget _topListToWidget(TopList topList) {
    assert(!topList.isEmpty);

    final l10n = AppLocalizations.of(context)!;
    final List<DataColumn> columns = [
      DataColumn(
          label: Text(l10n.tableHeadingCorrect),
          tooltip: l10n.tableHeadingCorrectOnFirstAttempt),
      DataColumn(label: Text(l10n.tableHeadingDuration)),
      const DataColumn(label: SizedBox.shrink()),
    ];

    List<DataRow> rows = [];
    for (int i = 0; i < topList.list.length; i++) {
      GameStats stats = topList.list[i];
      String lastCell = '';
      if (i == topList.mostRecentEntry) {
        lastCell = '<- ${l10n.tableRowLatest}';
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

  String _ampm(int hourOfDay) {
    final l10n = AppLocalizations.of(context)!;
    return [
      // 0-5
      l10n.amPm00h,
      l10n.amPm01h,
      l10n.amPm02h,
      l10n.amPm03h,
      l10n.amPm04h,
      l10n.amPm05h,
      // 6-11
      l10n.amPm06h,
      l10n.amPm07h,
      l10n.amPm08h,
      l10n.amPm09h,
      l10n.amPm10h,
      l10n.amPm11h,
      // 12-17
      l10n.amPm12h,
      l10n.amPm13h,
      l10n.amPm14h,
      l10n.amPm15h,
      l10n.amPm16h,
      l10n.amPm17h,
      // 18-23
      l10n.amPm18h,
      l10n.amPm19h,
      l10n.amPm20h,
      l10n.amPm21h,
      l10n.amPm22h,
      l10n.amPm23h,
    ][hourOfDay];
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
          _ampm(_gameState.timestamp.hour),
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
      final twoDigits = _numberFormat('00');
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
