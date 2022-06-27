import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: _name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        datetime: DateTime(2019, 1, 1, 9, 12, 0),
      ),
    ];
  }
}
