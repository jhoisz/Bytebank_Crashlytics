import 'dart:async';

import 'package:bytebank2/components/response_dialog.dart';
import 'package:bytebank2/components/transaction_auth_dialog.dart';
import 'package:bytebank2/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    // print('transaction form id $transactionId');
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: const Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      // if (value != null) {
                      final transactionCreated =
                          Transaction(transactionId, value, widget.contact);
                      showDialog(
                        context: context,
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (String password) {
                              _save(transactionCreated, password, context);
                            },
                          );
                        },
                      );
                      // }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction? transaction =
        await _send(transactionCreated, password, context);

    if (transaction != null) {
      if (!mounted) return;
      await _showSuccessfullMessage(context);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future<void> _showSuccessfullMessage(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (contextDialog) {
        return const SuccessDialog('successful transaction');
      },
    );
  }

  Future<Transaction?> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    final Transaction? transaction =
        await _webClient.save(transactionCreated, password).catchError((e) {
      _showFailureMessage(context, e.message);
      // print(e);
    }, test: (e) => e is HttpException).catchError((e) {
      _showFailureMessage(context, 'timeout submitting the transaction');
      // print(e);
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context, e.message);
      // print(e);
    });
    return transaction;
  }

  void _showFailureMessage(
    BuildContext context,
    String? message,
  ) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return FailureDialog(message ?? 'Unknown Error');
      },
    );
  }
}
