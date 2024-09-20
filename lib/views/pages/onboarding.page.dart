import 'package:flutter/material.dart';
import 'package:meetup/view_models/onboarding.vm.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.nonReactive(
      viewModelBuilder: () => OnboardingViewModel(context),
      builder: (context, model, child) {
        return OnBoardingScreen(
          onSkip: model.onDonePressed,
          showPrevNextButton: true,
          showIndicator: true,
          backgourndColor: context.theme.colorScheme.surface,
          activeDotColor: context.theme.primaryColor,
          deactiveDotColor: Colors.grey,
          iconColor: Colors.black,
          leftIcon: Icons.arrow_circle_left_rounded,
          rightIcon: Icons.arrow_circle_right_rounded,
          iconSize: 30,
          pages: model.onBoardData.map(
            (e) {
              return OnBoardingModel(
                image: Image.asset(e.imgUrl!),
                title: e.title ?? "",
                body: e.description ?? "",
              );
            },
          ).toList(),
        );
/*
        return Onboard(
          primaryColor: const Color(0xff6C63FF),
          onboardPages: model.onBoardData.map((e) {
            return OnboardModel(
              imagePath: e.imgUrl!,
              title: e.title ?? "",
              subTitle: e.description ?? "",
            );
          }).toList(),
          lastText: 'Done',
          nextText: 'Next',
          skipText: 'Skip',
          skipButtonPressed: model.onDonePressed,
        );
        */
      },
    );
  }
}
