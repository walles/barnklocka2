import 'dart:math';

import 'package:analog_clock/analog_clock.dart';
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
  final _random = Random();
  final _timeInputController = TextEditingController();

  DateTime _createRandomTimestamp() {
    return DateTime(2000, 1, 1, _random.nextInt(24), _random.nextInt(60), 0);
  }

  DateTime _getTimestamp() {
    _timestamp ??= _createRandomTimestamp();
    return _timestamp!;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _timeInputController.dispose();
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
    return [
      AnalogClock(
        height: 200, // FIXME: "height: same-as-the-width"?
        showSecondHand: false,
        showDigitalClock: false,
        showAllNumbers: true,
        datetime: _getTimestamp(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _timeInputController,
              autofocus: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'HHMM', labelText: 'Time in digital'),
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
      // FIXME: Randomize new time
      // FIXME: Clear text field
      print('Right!');
    } else {
      // FIXME: Print an error message
      print('Wrong!');
    }
  }
}

/// Checks whether the rendering ("1234" for example) is a valid rendering of
/// the timestamp's hours and minutes.
@visibleForTesting
bool isValidRendering(String rendering, DateTime timestamp) {
  // FIXME: Write tests for this function!
  return true;
}
