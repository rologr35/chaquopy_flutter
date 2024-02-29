import 'package:flutter/material.dart';

import 'package:chaquopy/chaquopy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String _outputOrError = "";

  Map<String, dynamic> data = Map();
  bool loadImageVisibility = true;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void addIntendation() {
    TextEditingController _updatedController = TextEditingController();

    int currentPosition = _controller.selection.start;

    String controllerText = _controller.text;
    String text = controllerText.substring(0, currentPosition) +
        "    " +
        controllerText.substring(currentPosition, controllerText.length);

    _updatedController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: _controller.text.length + 4,
        extentOffset: _controller.text.length + 4,
      ),
    );

    setState(() {
      _controller = _updatedController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      minimum: EdgeInsets.only(top: 4),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNode,
                  controller: _controller,
                  minLines: 10,
                  maxLines: 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    'This shows Output Or Error : $_outputOrError',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, minimumSize: Size(88, 44),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () => addIntendation(),
                        child: Icon(
                          Icons.arrow_right_alt,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, minimumSize: Size(88, 44),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text(
                          'run Code',
                        ),
                        onPressed: () async {
                          // to run PythonCode, just use executeCode function, which will return map with following format
                          // {
                          // "textOutputOrError" : output of the code / error generated while running the code
                          // }
                          final _result =
                              await Chaquopy.executeCode(_controller.text);
                          setState(() {
                            _outputOrError = _result['textOutputOrError'] ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
