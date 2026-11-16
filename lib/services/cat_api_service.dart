import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/cat_feed_item.dart';

class CatApiService {
  Future<List<CatFeedItem>> fetchMixedFeed({int count = 5}) async {
    final randomSkip = Random().nextInt(200);

    final results = await Future.wait([
      http
          .get(
            Uri.parse('https://meowfacts.herokuapp.com/?count=$count&lang=ukr'),
          )
          .timeout(const Duration(seconds: 10)),
      http
          .get(
            Uri.parse(
              'https://cataas.com/api/cats?limit=$count&skip=$randomSkip',
            ),
          )
          .timeout(const Duration(seconds: 10)),
    ]);

    final factsResponse = results[0];
    final catsResponse = results[1];

    if (factsResponse.statusCode != 200 || catsResponse.statusCode != 200) {
      throw Exception('Помилка завантаження даних з API');
    }

    final factsJson = jsonDecode(factsResponse.body) as Map<String, dynamic>;
    final List<dynamic> rawFacts = factsJson['data'] ?? [];
    final List<CatFactModel> factModels = rawFacts
        .map((item) => CatFactModel(factText: item.toString()))
        .toList();

    final List<dynamic> rawCats =
        jsonDecode(catsResponse.body) as List<dynamic>;
    final List<CatPhotoModel> photoModels = rawCats
        .map((json) => CatPhotoModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final List<CatFeedItem> mixedList = [];
    final maxLength = max(factModels.length, photoModels.length);

    for (int i = 0; i < maxLength; i++) {
      if (i < photoModels.length) mixedList.add(photoModels[i]);
      if (i < factModels.length) mixedList.add(factModels[i]);
    }

    return mixedList;
  }
}
