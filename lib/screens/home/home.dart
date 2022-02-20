// buttons to scan/ logout/ view scan history

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:qr_scanner/screens/home/history.dart';
import 'package:qr_scanner/services/auth.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<HomePage> createState() => _HomePageState(uid);
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  final String uid;
  _HomePageState(this.uid);
  CollectionReference urlcollections =
      FirebaseFirestore.instance.collection('urls');

  Future<void> _scanQR() async {
    AppBar(
      backgroundColor: const Color(0xFFFF7D54),
      title: const Text(
        'Scanning Code',
        style: TextStyle(
          fontFamily: 'Product Sans',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
    );
    try {
      var qrResult = await BarcodeScanner.scan();
      setState(
        () {
          urlcollections.doc(uid).collection('url').add(
            {
              'url': qrResult.rawContent,
              'time': DateTime.now(),
            },
          );
        },
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HistoryPage(uid: uid)));
    } on FormatException catch (ex) {
      print('Pressed the Back Button before Scanning');
    } catch (ex) {
      print('Unknown Error $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: const Text(
              'Sign Out',
              style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Color(0xFF1E1E1E)),
            ),
            onPressed: () async {
              await _auth.signOut().whenComplete(
                    () => Navigator.of(context).pushNamed('/login'),
                  );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 40.0),
              child: Image.asset(
                'assets/logo.png',
                height: 200,
                width: 200,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'Welcome to QR-Scanner',
                style: TextStyle(
                    fontFamily: 'Product Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                    color: Color(0xFF1E1E1E)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 20.0),
              child: const Text(
                'Please give access to your Camera so that\n we can scan and provide you what is\n inside the code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  height: 1.4,
                  color: Color(0xFFA0A0A0),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: 60.0,
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: _scanQR,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            backgroundColor: const Color(0XFFFF7D54),
            label: const Text(
              "Scan QR Code",
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
