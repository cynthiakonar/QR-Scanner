import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/screens/home/home.dart';

import '../models/user.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    //return either home or authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return HomePage(uid: user.uid);
    }
  }
}
