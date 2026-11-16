import 'package:material_ui/material_ui.dart';

import '../models/cat_feed_item.dart';
import '../services/cat_api_service.dart';
import '../widgets/tri_state_checkbox_group.dart';

class CheckBoxFactsPage extends StatefulWidget {
  const CheckBoxFactsPage({super.key});

  @override
  State<CheckBoxFactsPage> createState() => _CheckBoxFactsPageState();
}

class _CheckBoxFactsPageState extends State<CheckBoxFactsPage> {
  final CatApiService _apiService = CatApiService();
  CheckBoxGroupController<CatFactModel>? _groupController;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacts();
  }

  Future<void> _loadFacts() async {
    try {
      final facts = await _apiService.fetchFactsOnly(count: 6);
      setState(() {
        _groupController = CheckBoxGroupController<CatFactModel>(items: facts);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _groupController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkbox Facts Page')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Back'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Помилка: $_errorMessage'));
    }

    final controller = _groupController!;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Column(
          children: [
            MasterCheckBoxTile<CatFactModel>(
              controller: controller,
              title: 'Обрати всі котячі факти',
            ),
            const Divider(),
            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final fact = controller.items[index];
                      final isChecked = controller.isItemChecked(index);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: CheckboxListTile(
                          value: isChecked,
                          onChanged: (val) => controller.toggleItem(index, val),
                          title: Text(
                            fact.factText,
                            style: TextStyle(
                              decoration: isChecked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isChecked ? Colors.grey : Colors.black87,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
