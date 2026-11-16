import 'package:material_ui/material_ui.dart';

abstract class CatFeedItem {
  const CatFeedItem();

  Widget buildWidget(BuildContext context);
}

class CatFactModel extends CatFeedItem {
  final String factText;

  const CatFactModel({required this.factText});

  factory CatFactModel.fromString(String text) {
    return CatFactModel(factText: text);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.lightbulb_outline, color: Colors.white),
          ),
          title: Text(
            factText,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class CatPhotoModel extends CatFeedItem {
  final String id;
  final List<String> tags;

  const CatPhotoModel({required this.id, required this.tags});

  String get imageUrl => 'https://cataas.com/cat/$id';

  factory CatPhotoModel.fromJson(Map<String, dynamic> json) {
    return CatPhotoModel(
      id: json['id'] as String,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.black12,
            constraints: const BoxConstraints(maxHeight: 400),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 250,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 200,
                child: Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: tags.isEmpty
                ? const Text(
                    'Теги відсутні',
                    style: TextStyle(color: Colors.grey),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags
                        .map(
                          (tag) => Chip(
                            label: Text('#$tag'),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
