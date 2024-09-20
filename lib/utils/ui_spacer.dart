import 'package:flutter/material.dart';

class UiSpacer {
  //space between widgets vertically
  static Widget verticalSpace({double space = 20}) => SizedBox(height: space);

  //space between widgets horizontally
  static Widget horizontalSpace({double space = 20}) => SizedBox(width: space);

  static Widget formVerticalSpace({double space = 15}) =>
      SizedBox(height: space);

  static Widget emptySpace() => const SizedBox.shrink();

  static Widget divider({double height = 1, double thickness = 1}) => Divider(
        height: height,
        thickness: thickness,
      );
}
