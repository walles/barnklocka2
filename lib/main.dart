import 'package:barnklocka2/gamestate.dart';
import 'package:intl/intl.dart';

import 'package:barnklocka2/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
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

  late TextEditingController _timeInputController;
  late FocusNode _timeInputFocus;

  @override
  void initState() {
    super.initState();
    _timeInputController = TextEditingController();
    _timeInputFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _timeInputController.dispose();
    _timeInputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ui;
    if (_gameState.shouldShowStartScreen()) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: ui,
          ),
        ),
      ),
    );
  }

  List<Widget> _startScreen() {
    return [
      ElevatedButton(
          onPressed: () {
            setState(() {
              _gameState.start();
            });
          },
          child: const Text('Start')),
    ];
  }

  /// These widgets will be shown in a column in the main UI
  List<Widget> _gameUi() {
    return [
      ////////////////////////////////////////////////////
      //
      // Clock
      //
      Flexible(
        child: Clock(
          _gameState.getTimestamp().hour,
          _gameState.getTimestamp().minute,
        ),
      ),
      ////////////////////////////////////////////////////
      //
      // AM / PM text
      //
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _ampm[_gameState.getTimestamp().hour],
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
    ];
  }

  void _handleAnswer() {
    if (_gameState.registerAnswer(_timeInputController.text, () {
      setState(() {});
    })) {
      // FIXME: Play a Ding! sound

      _timeInputController.clear();
      setState(() {
        _errorText = null;
      });
    } else {
      final twoDigits = NumberFormat('00');
      final hour = _gameState.getTimestamp().hour;
      final minute = _gameState.getTimestamp().minute;
      setState(() {
        _errorText =
            'Should be: ${twoDigits.format(hour)}${twoDigits.format(minute)}';
      });
    }

    _timeInputFocus.requestFocus();
  }
}
