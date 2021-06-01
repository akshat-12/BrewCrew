import 'package:flutter/material.dart';
import 'package:brewcrew/screens/home/home.dart';
import 'package:brewcrew/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:brewcrew/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ModelUser?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
