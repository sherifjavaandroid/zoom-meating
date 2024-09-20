import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox()
        .roundedFull
        .clip(Clip.antiAlias)
        .make()
        .backgroundColor(
          Colors.grey[900],
        )
        .h16(context)
        .wFull(context)
        .shimmer(
          primaryColor: context.theme.colorScheme.surface,
          secondaryColor: context.theme.highlightColor,
        );
  }
}
