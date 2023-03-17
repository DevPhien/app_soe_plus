import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InlineLoadding extends StatelessWidget {
  final String? txt;
  const InlineLoadding({Key? key, this.txt}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitCircle(color: Colors.black45, size: 32.0),
    );
  }
}
