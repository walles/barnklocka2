import 'package:barnklocka2/timepicker.dart';
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
  DateTime? _timestamp;
  String? _errorText;
  final _timePicker = TimePicker();

  late TextEditingController _timeInputController;
  late FocusNode _timeInputFocus;

  DateTime _getTimestamp() {
    _timestamp ??= _timePicker.createRandomTimestamp();
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
    return [
      ////////////////////////////////////////////////////
      //
      // Clock
      //
      Flexible(
        child: Clock(
          _getTimestamp().hour,
          _getTimestamp().minute,
        ),
      ),
      ////////////////////////////////////////////////////
      //
      // AM / PM text
      //
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _ampm[_getTimestamp().hour],
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
                _handleButtonPress();
              },
            ),
          ),
          Flexible(
            flex: 0,
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
        _timestamp = _timePicker.createRandomTimestamp();
      });
    } else {
      final twoDigits = NumberFormat('00');
      final hour = _getTimestamp().hour;
      final minute = _getTimestamp().minute;
      setState(() {
        _errorText =
            'Should be: ${twoDigits.format(hour)}${twoDigits.format(minute)}';
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
