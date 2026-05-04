import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLPinning {
  static const String _certificateAssetPath = 'cert/tmdb.pem';

  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<http.Client> createSecurityClient() async {
    final context = SecurityContext(withTrustedRoots: false);

    try {
      final bytes =
          (await rootBundle.load(_certificateAssetPath)).buffer.asUint8List();
      context.setTrustedCertificatesBytes(bytes);
    } on TlsException catch (e) {
      final message = e.osError?.message ?? '';
      if (!message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        rethrow;
      }
    }

    final httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return IOClient(httpClient);
  }

  static Future<void> init() async {
    _clientInstance ??= await createSecurityClient();
  }
}
