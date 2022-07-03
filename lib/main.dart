import 'dart:math';
import 'package:intl/intl.dart';

import 'package:barnklocka2/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
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
  DateTime? _timestamp;
  String? _errorText;
  final _random = Random();

  late TextEditingController _timeInputController;
  late FocusNode _timeInputFocus;

  DateTime _createRandomTimestamp() {
    return DateTime(2000, 1, 1, _random.nextInt(24), 0, 0);
  }

  DateTime _getTimestamp() {
    _timestamp ??= _createRandomTimestamp();
    print('New timestamp: $_timestamp');
    return _timestamp!;
  }

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
              children: _mainUi(),
            )),
      ),
    );
  }

  /// These widgets will be shown in a column in the main UI
  List<Widget> _mainUi() {
    final ampm = _getTimestamp().hour < 12
        ? 'First half of the day'
        : 'Second half of the day';

    return [
      Expanded(
        child: Clock(
          _getTimestamp().hour,
          _getTimestamp().minute,
        ),
      ),
      //
      // ----------------------------------------------
      //
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          ampm,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ),
      ),
      //
      // ----------------------------------------------
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
                  labelText: 'Time in digital',
                  errorText: _errorText),
              onSubmitted: (String _) {
                // FIXME: Only if the input looks like a time!
                _handleButtonPress();
              },
            ),
          ),
          Flexible(
            child: ElevatedButton(
                onPressed: _handleButtonPress, child: const Text('Go!')),
          )
        ],
      )
    ];
  }

  void _handleButtonPress() {
    if (isValidRendering(_timeInputController.text, _getTimestamp())) {
      // FIXME: Play a Ding! sound

      _timeInputController.clear();
      setState(() {
        _errorText = null;
        _timestamp = _createRandomTimestamp();
      });
    } else {
      final twoDigits = NumberFormat('00');
      final hour = _getTimestamp().hour;
      final minute = _getTimestamp().minute;
      setState(() {
        _errorText =
            'Digital time is ${twoDigits.format(hour)}${twoDigits.format(minute)}';
      });
    }

    _timeInputFocus.requestFocus();
  }
}

/// Checks whether the rendering ("1234" for example) is a valid rendering of
/// the timestamp's hours and minutes.
@visibleForTesting
bool isValidRendering(String rendering, DateTime timestamp) {
  final twoDigits = NumberFormat('00');

  if (rendering.length == 3) {
    rendering = '0$rendering';
  }

  final correct =
      '${twoDigits.format(timestamp.hour)}${twoDigits.format(timestamp.minute)}';

  return rendering == correct;
}
