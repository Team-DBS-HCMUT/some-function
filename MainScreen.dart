import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome!', style: Theme.of(context).textTheme.headline2),
      ),
    );
  }
}



