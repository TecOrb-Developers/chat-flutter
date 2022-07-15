import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [Text("Couldn not fetch data")],
        ),
      ),
    );
  }
}
