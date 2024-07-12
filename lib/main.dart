import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _controller = TextEditingController();
  bool _isFahrenheitToCelsius = true;
  String _result = '';
  final List<String> _history = [];

  void _convert() {
    double? inputValue = double.tryParse(_controller.text);

    if (inputValue == null) {
      setState(() {
        _result = '';
      });
      return;
    }

    double convertedValue;
    String conversion;

    if (_isFahrenheitToCelsius) {
      convertedValue = (inputValue - 32) * 5 / 9;
      conversion = 'F to C';
    } else {
      convertedValue = inputValue * 9 / 5 + 32;
      conversion = 'C to F';
    }

    setState(() {
      _result = convertedValue.toStringAsFixed(2);
      _history.insert(0, '$conversion: $inputValue ➔ $_result');
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
        backgroundColor: const Color.fromARGB(255, 7, 193, 255),
        toolbarHeight: isPortrait ? kToolbarHeight : 40,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isPortrait ? buildPortraitLayout() : buildLandscapeLayout(),
      ),
    );
  }

  Widget buildPortraitLayout() {
    return Column(
      children: <Widget>[
        buildConversionLabel(),
        const SizedBox(height: 10),
        buildConversionSelectors(),
        const SizedBox(height: 20),
        buildTemperatureRow(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildConvertButton(),
            Container(width: 10),
            buildClearButton(),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(height: 300, child: buildHistoryList()),  // Adjusted height
      ],
    );
  }

  Widget buildLandscapeLayout() {
    return Column(
      children: <Widget>[
        buildConversionLabel(),
        const SizedBox(height: 5),
        buildConversionSelectors(),
        const SizedBox(height: 10),
        buildTemperatureRow(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildConvertButton(),
            Container(width: 5),
            buildClearButton(),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(height: 200, child: buildHistoryList()),  // Set a fixed height for the history list
      ],
    );
  }

  Widget buildConversionLabel() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Conversion:',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget buildConversionSelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<bool>(
          value: true,
          groupValue: _isFahrenheitToCelsius,
          onChanged: (bool? value) {
            setState(() {
              _isFahrenheitToCelsius = value!;
              _result = '';
            });
          },
          activeColor: Colors.white,
        ),
        const SizedBox(
          width: 80,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Fahrenheit to Celsius',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Radio<bool>(
          value: false,
          groupValue: _isFahrenheitToCelsius,
          onChanged: (bool? value) {
            setState(() {
              _isFahrenheitToCelsius = value!;
              _result = '';
            });
          },
          activeColor: Colors.white,
        ),
        const SizedBox(
          width: 80,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Celsius to Fahrenheit',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTemperatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _result = '';
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Enter temperature',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          '=',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
        const SizedBox(width: 10),
        Container(
          width: 100,
          padding: const EdgeInsets.all(8.0),
          color: Colors.lightGreen.shade100,
          child: Text(
            _result,
            style: const TextStyle(fontSize: 20, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget buildConvertButton() {
    return ElevatedButton(
      onPressed: _convert,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        minimumSize: const Size(100, 40),
      ),
      child: const Text('CONVERT', style: TextStyle(fontSize: 12)),
    );
  }

  Widget buildClearButton() {
    return ElevatedButton(
      onPressed: _clearHistory,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.red,
        minimumSize: const Size(100, 40),
      ),
      child: const Text('CLEAR HISTORY', style: TextStyle(fontSize: 12)),
    );
  }

  Widget buildHistoryList() {
    return ListView.builder(
      itemCount: _history.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blue.shade50,
          child: ListTile(
            title: Text(
              _history[index],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
