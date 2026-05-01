import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:veloquent_sdk/veloquent_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config.dart';

class VeloquentService {
  VeloquentService._();
  static VeloquentService? _instance;
  static VeloquentService get instance {
    _instance ??= VeloquentService._();
    return _instance!;
  }

  late Veloquent sdk;
  Map<String, dynamic>? currentUser;

  Future<void> init() async {
    http.Client? client;
    if (!kIsWeb && Platform.isAndroid) {
      client = _HostHeaderClient(AppConfig.domain);
    }

    sdk = Veloquent(
      apiUrl: AppConfig.apiUrl,
      http: _HeaderAwareFetchAdapter(client: client),
      storage: createSecureStorageAdapter(),
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await sdk.auth.login(
      AppConfig.usersCollection,
      email,
      password,
    );
    currentUser = Map<String, dynamic>.from(result['record'] ?? {});
    return result;
  }

  Future<Map<String, dynamic>> loginWithGoogleNative() async {
    final redirectUrl = await sdk.auth.getOAuthRedirectUrl(
      AppConfig.usersCollection,
      'google',
    );
    final uri = Uri.parse(redirectUrl);
    final state = uri.queryParameters['state'];

    if (state == null) {
      throw Exception('Failed to obtain OAuth state from Veloquent.');
    }

    final googleSignIn = GoogleSignIn(
      serverClientId: AppConfig.googleServerClientId,
    );

    final account = await googleSignIn.signIn();
    if (account == null) {
      throw Exception('Login cancelled');
    }

    final serverAuthCode = account.serverAuthCode;
    if (serverAuthCode == null) {
      throw Exception('Failed to get server auth code from Google');
    }

    // Relay the Google code and Veloquent state to the Veloquent callback endpoint.
    final callbackResponse = await http.get(
      Uri.parse(
        '${AppConfig.apiUrl}/api/oauth2/callback?code=$serverAuthCode&state=$state&native=1',
      ),
      headers: {'Accept': 'application/json'},
    );

    if (callbackResponse.statusCode != 200) {
      throw Exception('Veloquent callback failed: ${callbackResponse.body}');
    }

    final callbackData = jsonDecode(callbackResponse.body);
    final data = callbackData['data'] ?? callbackData;
    final exchangeCode = data['code'] ?? data['exchange_code'];

    if (exchangeCode == null) {
      throw Exception('No exchange code received from Veloquent');
    }

    final result = await sdk.auth.exchangeOAuthCode(exchangeCode);

    currentUser = Map<String, dynamic>.from(result['record'] ?? {});
    return result;
  }

  Future<Map<String, dynamic>> me() async {
    final result = await sdk.auth.me(AppConfig.usersCollection);
    currentUser = Map<String, dynamic>.from(result);
    return currentUser!;
  }

  Future<dynamic> register(String name, String email, String password) async {
    return await sdk.records.create(AppConfig.usersCollection, {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
  }

  Future<void> logout() async {
    try {
      await sdk.auth.logout(AppConfig.usersCollection);
      currentUser = null;
    } catch (e) {
      debugPrint('Logout error (handled): $e');
    }
  }

  Future<bool> hasSession() async {
    try {
      final result = await sdk.auth.me(AppConfig.usersCollection);
      currentUser = Map<String, dynamic>.from(result);
      return true;
    } catch (_) {
      currentUser = null;
      return false;
    }
  }
}

class _HeaderAwareFetchAdapter extends FetchAdapter {
  final http.Client _customClient;

  _HeaderAwareFetchAdapter({super.client})
    : _customClient = client ?? http.Client();

  @override
  Future<HttpResponse> sendMultipartRequest({
    required String method,
    required Uri uri,
    required http.MultipartRequest multipartRequest,
    required Map<String, String> fields,
    required List<Map<String, dynamic>> files,
    required Map<String, String> headers,
    required Duration timeout,
  }) async {
    final streamedResponse = await _customClient
        .send(multipartRequest)
        .timeout(timeout);
    final response = await http.Response.fromStream(streamedResponse);

    final contentType = response.headers['content-type'] ?? '';
    dynamic data;
    if (contentType.contains('application/json') && response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } on FormatException {
        data = response.body;
      }
    } else if (response.body.isNotEmpty) {
      data = response.body;
    }

    return HttpResponse(
      status: response.statusCode,
      statusText: response.reasonPhrase ?? '',
      headers: response.headers,
      data: data,
    );
  }
}

class _HostHeaderClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final String host;

  _HostHeaderClient(this.host);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Host'] = host;
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
