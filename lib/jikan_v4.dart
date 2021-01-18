import 'dart:convert';

import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:http/http.dart' as http;

const apiBaseUrl = 'https://api.jikan.moe/v4-alpha';

class JikanV4 {
  Future<List<dynamic>> getGenreList({bool anime = true}) async {
    final type = anime ? 'anime' : 'manga';
    final response = await http.get('$apiBaseUrl/genres/$type?order_by=name&sort=asc');
    final genresJson = jsonDecode(response.body);
    return genresJson['data'].where((genre) => genre['name'] != 'Hentai').toList();
  }

  Future<BuiltList<Map<String, dynamic>>> getProducerList({bool anime = true, int page = 1}) async {
    final type = anime ? 'producers' : 'magazines';
    final response = await http.get('$apiBaseUrl/$type?order_by=count&sort=desc&page=$page');
    final producersJson = jsonDecode(response.body);
    return BuiltList<Map<String, dynamic>>(producersJson['data']);
  }

  Future<List<dynamic>> getVideos(String type, String subtype) async {
    final response = await http.get('$apiBaseUrl/watch/$type/$subtype');
    final videosJson = jsonDecode(response.body);
    return videosJson['data'];
  }
}
