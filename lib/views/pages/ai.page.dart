import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/services/ai.service.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/view_models/history.vm.dart';
import 'package:meetup/views/pages/ai/ai_chatbot.page.dart';
import 'package:meetup/views/pages/ai/ai_image_generator.page.dart';
import 'package:meetup/views/pages/auth/login.page.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AIPage extends StatefulWidget {
  const AIPage({Key? key}) : super(key: key);

  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage>
    with AutomaticKeepAliveClientMixin<AIPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HistoryViewModel>.reactive(
      viewModelBuilder: () => HistoryViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          body: VStack(
            [
              //
              // "AI".tr().text.xl2.semiBold.make(),
              // 20.heightBox,
              //chatbot
              if (ApiService().isAIChatEnabled)
                VStack(
                  [
                    HStack(
                      [
                        //image
                        const Icon(
                          LineIcons.facebookMessenger,
                          size: 30,
                          color: AppColor.primaryColor,
                        ),
                        10.widthBox,
                        //details
                        "Chatbot"
                            .tr()
                            .text
                            .xl
                            .semiBold
                            .color(AppColor.primaryColor)
                            .make()
                            .expand(),
                      ],
                    ),
                    6.heightBox,
                    "Engage in interactive conversations with our intelligent Chatbot powered by state-of-the-art natural language processing. Get answers to your questions, explore various topics, or simply have a friendly chat."
                        .tr()
                        .text
                        .sm
                        .medium
                        .make(),
                  ],
                )
                    .p(8)
                    .box
                    .roundedSM
                    .shadowSm
                    .color(context.colors.surface)
                    .make()
                    .onTap(
                  () {
                    loadNextPage(const AIChatbotPage());
                  },
                ),
              //
              20.heightBox,
              // image generator
              if (ApiService().isAIImageGenerationEnabled)
                VStack(
                  [
                    HStack(
                      [
                        //image
                        const Icon(
                          LineIcons.imageFile,
                          size: 30,
                          color: AppColor.primaryColor,
                        ),
                        10.widthBox,
                        //details
                        "AI Image Generation"
                            .tr()
                            .text
                            .xl
                            .semiBold
                            .color(AppColor.primaryColor)
                            .make()
                            .expand(),
                      ],
                    ),
                    6.heightBox,
                    "Unleash the power of artificial intelligence to generate stunning and creative images. Experience the magic of our AI algorithms that can produce unique artworks, landscapes, portraits, and more. Let your imagination come to life with the help of AI technology."
                        .tr()
                        .text
                        .sm
                        .medium
                        .make(),
                  ],
                )
                    .p(8)
                    .box
                    .roundedSM
                    .shadowSm
                    .color(context.colors.surface)
                    .make()
                    .onTap(
                  () {
                    loadNextPage(const AIImageGeneratorPage());
                  },
                ),
            ],
          ).p20().scrollVertical(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  //
  loadNextPage(Widget page) async {
    //auth_required
    bool authRequired = ApiService().isAIAuthRequired;
    bool authenticated = AuthServices.authenticated();
    if (authRequired && !authenticated) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      //check auth again
      authenticated = AuthServices.authenticated();
      if (!authenticated) {
        return;
      }
    }
    context.nextPage(page);
  }
}
