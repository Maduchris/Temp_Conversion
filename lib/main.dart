import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Allow both portrait and landscape orientations
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const temperatureConverter());
}

class temperatureConverter extends StatelessWidget {
  const temperatureConverter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'temperatureerature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: const temperatureConverterHome(),
    );
  }
}

class temperatureConverterHome extends StatefulWidget {
  const temperatureConverterHome({Key? key}) : super(key: key);

  @override
  _temperatureConverterHomeState createState() => _temperatureConverterHomeState();
}

class _temperatureConverterHomeState extends State<temperatureConverterHome> {
  String _conversionType = 'F to C';
  final TextEditingController _controller = TextEditingController();
  String _convertedtemperature = '';
  final List<String> _history = [];

  void _converttemperatureerature() {
    setState(() {
      double inputtemperature = double.tryParse(_controller.text) ?? 0.0;
      double convertedtemperature;

      if (_conversionType == 'F to C') {
        convertedtemperature = (inputtemperature - 32) * 5 / 9;
      } else {
        convertedtemperature = inputtemperature * 9 / 5 + 32;
      }

      _convertedtemperature = convertedtemperature.toStringAsFixed(1);
      _history.add(
          '$_conversionType: ${inputtemperature.toStringAsFixed(1)} => $_convertedtemperature');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('temperatureerature Converter'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = orientation == Orientation.portrait;

            return Column(
              children: [
                if (isPortrait) ...[
                  Expanded(
                    child: Column(
                      children: [
                        _buildInputSection(),
                        const SizedBox(height: 20),
                        _buildHistorySection(),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildInputSection()),
                        const SizedBox(width: 20),
                        Expanded(child: _buildHistorySection()),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: 'F to C',
              groupValue: _conversionType,
              onChanged: (value) {
                setState(() {
                  _conversionType = value!;
                });
              },
              activeColor: Colors.green,
            ),
            const Text('Fahrenheit to Celsius'),
            Radio<String>(
              value: 'C to F',
              groupValue: _conversionType,
              onChanged: (value) {
                setState(() {
                  _conversionType = value!;
                });
              },
              activeColor: Colors.green,
            ),
            const Text('Celsius to Fahrenheit'),
          ],
        ),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter temperatureerature',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _converttemperatureerature,
          child: const Text('Convert'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Converted temperatureerature: $_convertedtemperature',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_history[index]),
          );
        },
      ),
    );
  }
}