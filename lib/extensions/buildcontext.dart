import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  //pop
  void pop() {
    Navigator.of(this).pop();
  }

  //next page
  Future<dynamic> push(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
