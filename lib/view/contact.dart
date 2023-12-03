import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Jabatan Siasatan Jenayah Komersial Bukit Aman',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Polis Diraja Malaysia,\n'
              'Aras 33, Menara 238,\n'
              'Jalan Tun Razak,\n'
              '50400 Kuala Lumpur.\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Tel: 03-26101222',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Fax: 03-26101000',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Bilik Gerakan: 03-26101599',
              style: TextStyle(fontSize: 16),
            ),
            // ... add more contact details if needed
          ],
        ),
      ),
    );
  }
}
