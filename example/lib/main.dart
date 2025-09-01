import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atomic_flutter_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atomic Flutter Kit Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _textFieldValue = '';
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AtomicAppBar(
        title: const AtomicText('Atomic Kit Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const AtomicText(
              'Buttons:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AtomicButton(
              label: 'Primary Button',
              onPressed: () {
                AtomicToast.show(
                  context: context,
                  message: 'Primary Button Pressed!',
                );
              },
            ),
            const SizedBox(height: 10),
            AtomicButton(
              label: 'Secondary Button',
              variant: AtomicButtonVariant.secondary,
              onPressed: () {
                AtomicToast.show(
                  context: context,
                  message: 'Secondary Button Pressed!',
                );
              },
            ),
            const SizedBox(height: 20),
            const AtomicText(
              'Text Field:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AtomicTextField(
              controller: TextEditingController(),
              hint: 'Enter some text',
              onChanged: (value) {
                setState(() {
                  _textFieldValue = value;
                });
              },
            ),
            const SizedBox(height: 10),
            AtomicText('Current Text: $_textFieldValue'),
            const SizedBox(height: 20),
            const AtomicText(
              'Switch:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AtomicSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
                AtomicToast.show(
                  context: context,
                  message: 'Switch is now: $value',
                );
              },
            ),
            const SizedBox(height: 10),
            AtomicText('Switch State: ${_switchValue ? 'ON' : 'OFF'}'),
            const SizedBox(height: 20),
            const AtomicText(
              'Loader:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const AtomicLoader(),
            const SizedBox(height: 20),
            const AtomicText(
              'Card:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AtomicCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AtomicText(
                      'This is an Atomic Card',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const AtomicText(
                      'You can put any content inside this card.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
