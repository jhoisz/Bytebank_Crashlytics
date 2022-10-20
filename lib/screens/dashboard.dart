import 'package:bytebank2/screens/transactions_list.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'contacts_list.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('images/bytebank_logo.png'),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FeatureItem(
                  name: 'Transfer',
                  icon: Icons.monetization_on,
                  onClick: () => _showContactsList(context),
                ),
                _FeatureItem(
                  name: 'Transaction Feed',
                  icon: Icons.description,
                  onClick: () => _showTransactionsList(context),
                ),
                // _FeatureItem(
                //   name: 'Transaction Feed',
                //   icon: Icons.description,
                //   onClick: () {
                //     print('transaction');
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    Key? key,
    required this.name,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  final String name;
  final IconData icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            // height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24.0,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showContactsList(BuildContext context) {
  FirebaseCrashlytics.instance.crash();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const ContactsList(),
    ),
  );
}

void _showTransactionsList(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ),
  );
}
