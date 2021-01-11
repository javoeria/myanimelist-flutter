import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:myanimelist/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slack_notifier/slack_notifier.dart';

const clientId = '';
const tokenUri = 'https://myanimelist.net/v1/oauth2/token';
const authorizeUri = 'https://myanimelist.net/v1/oauth2/authorize';
const apiBaseUrl = 'https://api.myanimelist.net/v2';

class MalClient {
  Future<String> login() async {
    final verifier = _generateCodeVerifier();
    final loginUrl = _generateLoginUrl(verifier);

    try {
      final uri = await FlutterWebAuth.authenticate(url: loginUrl, callbackUrlScheme: 'javoeria.animedb');
      final queryParams = Uri.parse(uri).queryParameters;
      print(queryParams);
      if (queryParams['error'] == 'access_denied') return null;

      final tokenJson = await _generateTokens(verifier, queryParams['code']);
      final username = await _getUserName(tokenJson['access_token']);
      if (kReleaseMode) {
        tokenJson['datetime'] = DateTime.now();
        FirebaseFirestore.instance.collection('test').doc(username).set(tokenJson);
        SlackNotifier(kSlackToken).send('User Login $username', channel: 'jikan');
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      return username;
    } on PlatformException {
      return null;
    }
  }

  Future<String> refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    final doc = await FirebaseFirestore.instance.collection('test').doc(username).get();
    final tokenJson = await _refreshTokens(doc.data()['refresh_token']);
    if (kReleaseMode) {
      tokenJson['datetime'] = DateTime.now();
      FirebaseFirestore.instance.collection('test').doc(username).set(tokenJson);
      SlackNotifier(kSlackToken).send('User Refresh $username', channel: 'jikan');
    }
    return tokenJson['access_token'];
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(200, (i) => random.nextInt(256));
    return base64UrlEncode(values).substring(0, 128);
  }

  String _generateLoginUrl(String verifier) {
    return '$authorizeUri?response_type=code&client_id=$clientId&code_challenge=$verifier';
  }

  Future<dynamic> _generateTokens(String verifier, String code) async {
    final params = {
      'client_id': clientId,
      'code': code,
      'code_verifier': verifier,
      'grant_type': 'authorization_code',
    };
    final response = await http.post(tokenUri, body: params);
    return jsonDecode(response.body);
  }

  Future<dynamic> _refreshTokens(String refreshToken) async {
    final params = {
      'client_id': clientId,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };
    final response = await http.post(tokenUri, body: params);
    return jsonDecode(response.body);
  }

  Future<String> _getUserName(String accessToken) async {
    final response = await http.get('$apiBaseUrl/users/@me', headers: {'Authorization': 'Bearer $accessToken'});
    final userJson = jsonDecode(response.body);
    return userJson['name'];
  }
}
