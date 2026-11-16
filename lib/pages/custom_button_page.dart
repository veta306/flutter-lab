import 'package:material_ui/material_ui.dart';

import '../widgets/custom_canvas_button.dart';

class CustomButtonPage extends StatefulWidget {
  const CustomButtonPage({super.key});

  @override
  State<CustomButtonPage> createState() => _CustomButtonPageState();
}

class _CustomButtonPageState extends State<CustomButtonPage> {
  int _clickCounter = 0;
  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Button')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Кількість натискань: $_clickCounter',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            CustomCanvasButton(
              label: _isButtonEnabled ? 'Натисни мене' : 'Кнопка вимкнена',
              onPressed: _isButtonEnabled
                  ? () {
                      setState(() => _clickCounter++);
                    }
                  : null,
            ),
            const SizedBox(height: 20),

            CustomCanvasButton(
              label: 'Скинути лічильник',
              width: 220,
              height: 48,
              style: const CustomButtonStyle(
                normalColor: Colors.white,
                hoverColor: Color(0xFFFFF3E0),
                pressedColor: Color(0xFFFFE0B2),
                textColor: Color(0xFFE65100),
                borderColor: Color(0xFFFF9800),
                borderWidth: 2.0,
                borderRadius: 24.0,
                elevation: 2.0,
              ),
              onPressed: () {
                setState(() => _clickCounter = 0);
              },
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Активувати кнопку: '),
                Switch(
                  value: _isButtonEnabled,
                  onChanged: (val) => setState(() => _isButtonEnabled = val),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Back'),
      ),
    );
  }
}
