import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/view_models/splash.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(context),
      onViewModelReady: (model) => model.loadAppSettings(),
      builder: (context, model, child) {
        return BasePage(
          body: VStack(
            [
              //logo
              Image.asset(
                AppImages.appLogo,
              ).wh(Vx.dp64, Vx.dp64).centered(),
              //loading indicator
              BusyIndicator(
                color: context.textTheme.bodyLarge!.color!,
              )
                  .box
                  .margin(
                    const EdgeInsets.only(top: Vx.dp20),
                  )
                  .makeCentered(),
            ],
          ).centered(),
        );
      },
    );
  }
}
