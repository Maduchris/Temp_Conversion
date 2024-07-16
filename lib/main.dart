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

  runApp(const TempConverter());
}

class TempConverter extends StatelessWidget {
  const TempConverter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: const TempConverterHome(),
    );
  }
}

class TempConverterHome extends StatefulWidget {
  const TempConverterHome({Key? key}) : super(key: key);

  @override
  _TempConverterHomeState createState() => _TempConverterHomeState();
}

class _TempConverterHomeState extends State<TempConverterHome> {
  String _conversionType = 'F to C';
  final TextEditingController _controller = TextEditingController();
  String _convertedTemp = '';
  final List<String> _history = [];

  void _convertTemperature() {
    setState(() {
      double inputTemp = double.tryParse(_controller.text) ?? 0.0;
      double convertedTemp;

      if (_conversionType == 'F to C') {
        convertedTemp = (inputTemp - 32) * 5 / 9;
      } else {
        convertedTemp = inputTemp * 9 / 5 + 32;
      }

      _convertedTemp = convertedTemp.toStringAsFixed(1);
      _history.add(
          '$_conversionType: ${inputTemp.toStringAsFixed(1)} => $_convertedTemp');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
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
            labelText: 'Enter temperature',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _convertTemperature,
          child: const Text('Convert'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Converted temperature: $_convertedTemp',
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