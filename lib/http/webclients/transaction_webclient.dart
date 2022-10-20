import 'dart:convert';

import 'package:http/http.dart';

import '../../models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>?> findAll() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));

      final List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson
          .map((dynamic json) => Transaction.fromJson(json))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    // await Future.delayed(const Duration(seconds: 10));

    final Response response = await client
        .post(
          Uri.parse(baseUrl),
          headers: {
            'Content-type': 'application/json',
            'password': password,
          },
          body: transactionJson,
        )
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    // throwHttpError(response.statusCode);
    // throw HttpException(_getMessage(500));
    throw HttpException(_getMessage(response.statusCode));
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }
    return 'Unknown error';
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'there was an error submitting transaction',
    401: 'authentication failed',
    409: 'transaction already exists'
  };
}

class HttpException implements Exception {
  final String? message;
  HttpException(this.message);
}
