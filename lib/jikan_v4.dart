import 'dart:convert';

import 'package:http/http.dart' as http;

const apiBaseUrl = 'https://api.jikan.moe/v4-alpha';

class JikanV4 {
  Future<List<dynamic>> getGenreList({bool anime = true}) async {
    final type = anime ? 'anime' : 'manga';
    final response = await http.get('$apiBaseUrl/genres/$type?order_by=name&sort=asc');
    final genresJson = jsonDecode(response.body);
    return genresJson['data'].where((genre) => genre['name'] != 'Hentai').toList();
  }
}
