import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    this.title,
    this.child,
    this.divider = true,
    this.topDivider = false,
    this.suffix,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  //
  final String? title;
  final Widget? child;
  final bool divider;
  final bool topDivider;
  final Widget? suffix;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        topDivider
            ? const Divider(
                height: 1,
                thickness: 2,
              )
            : const SizedBox.shrink(),

        //
        HStack(
          [
            //
            (child ?? "$title".text.lg.light.make()).expand(),
            //
            suffix ??
                Icon(
                  !translator.isDirectionRTL(context)
                      ? LineIcons.arrowRight
                      : LineIcons.arrowLeft,
                  size: 16,
                ),
          ],
        ).py12().px8(),

        //
        divider
            ? const Divider(
                height: 1,
                thickness: 2,
              )
            : const SizedBox.shrink(),
      ],
    ).onInkTap(
      () => onPressed != null ? onPressed!() : null,
    );
  }
}
