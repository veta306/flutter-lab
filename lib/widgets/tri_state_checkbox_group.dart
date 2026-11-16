import 'package:material_ui/material_ui.dart';

class CheckBoxGroupController<T> extends ChangeNotifier {
  final List<T> items;
  final List<bool> _states;

  CheckBoxGroupController({required this.items})
    : _states = List<bool>.filled(items.length, false);

  bool isItemChecked(int index) => _states[index];

  List<T> get selectedItems {
    final result = <T>[];
    for (int i = 0; i < items.length; i++) {
      if (_states[i]) result.add(items[i]);
    }
    return result;
  }

  bool? get masterState {
    if (_states.isEmpty) return false;

    final checkedCount = _states.where((isChecked) => isChecked).length;

    if (checkedCount == 0) {
      return false; // Непомічений
    } else if (checkedCount == _states.length) {
      return true; // Помічений
    } else {
      return null; // Частково помічений (indeterminate)
    }
  }

  void toggleItem(int index, bool? value) {
    if (index < 0 || index >= _states.length) return;
    _states[index] = value ?? false;
    notifyListeners();
  }

  void toggleGroup() {
    final bool targetState = masterState != true;

    for (int i = 0; i < _states.length; i++) {
      _states[i] = targetState;
    }
    notifyListeners();
  }
}

class MasterCheckBoxTile<T> extends StatelessWidget {
  final CheckBoxGroupController<T> controller;
  final String title;

  const MasterCheckBoxTile({
    super.key,
    required this.controller,
    this.title = 'Обрати всі елементи',
  });

  String _getStatusText(bool? state) {
    if (state == true) return 'Стан: Помічений (обрано всі)';
    if (state == false) return 'Стан: Непомічений (нічого не обрано)';
    return 'Стан: Частково помічений (${controller.selectedItems.length} з ${controller.items.length})';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final currentState = controller.masterState;

        return Card(
          color: Colors.orange.shade50,
          margin: const EdgeInsets.all(12),
          child: CheckboxListTile(
            tristate: true,
            value: currentState,
            onChanged: (_) => controller.toggleGroup(),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_getStatusText(currentState)),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }
}
