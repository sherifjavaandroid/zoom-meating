import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/view_models/ai_image_generator.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AIImageGeneratorPage extends StatefulWidget {
  const AIImageGeneratorPage({super.key});
  @override
  _AIImageGeneratorPageState createState() => _AIImageGeneratorPageState();
}

class _AIImageGeneratorPageState extends State<AIImageGeneratorPage> {
  @override
  Widget build(BuildContext context) {
    //
    double imgHeight = context.percentHeight * 20;
    double itemHeight = imgHeight + 50;
    //generate the right aspect ratio
    double itemWidth = context.percentWidth * 45;
    double aspectRatio = itemWidth / itemHeight;

    //
    return ViewModelBuilder<AIImageGeneratorViewModel>.reactive(
      viewModelBuilder: () => AIImageGeneratorViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          title: "AI Image Generator".tr(),
          showAppBar: true,
          showLeadingAction: true,
          body: VStack(
            [
              //images listview
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: aspectRatio,
                  padding: const EdgeInsets.all(10),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: model.images.map(
                    (imageUrl) {
                      return VStack(
                        [
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            progressIndicatorBuilder: (context, url, progress) {
                              return const BusyIndicator();
                            },
                            errorWidget: (context, imageUrl, progress) {
                              return Image.asset(
                                AppImages.appLogo,
                              );
                            },
                            fit: BoxFit.contain,
                            height: imgHeight,
                            width: double.infinity,
                          ).onTap(() {
                            model.previewImage(imageUrl);
                          }),
                          //
                          CustomButton(
                            loading: model.busy(imageUrl),
                            onPressed: () {
                              model.downloadImage(imageUrl);
                            },
                            child: HStack(
                              [
                                const Icon(
                                  LineIcons.download,
                                  color: Colors.white,
                                ),
                                5.widthBox,
                                "Download".tr().text.white.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.center,
                            ),
                          ).wFull(context),
                          5.heightBox,
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),

              //input and send button
              VStack(
                [
                  //input
                  TextField(
                    minLines: 2,
                    maxLines: 4,
                    controller: model.textEditingController,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: "Enter text here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  10.heightBox,
                  //send button
                  HStack(
                    [
                      //options bottomsheet
                      CustomButton(
                        child: const Icon(LineIcons.cog),
                        onPressed: model.openAISettings,
                      ).w(60).h(50),
                      10.widthBox,
                      //
                      CustomButton(
                        loading: model.isBusy,
                        onPressed: model.generateImage,
                        child: HStack(
                          [
                            const Icon(LineIcons.magic),
                            5.widthBox,
                            "Generate".tr().text.make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                          alignment: MainAxisAlignment.center,
                        ),
                      ).wFull(context).h(50).expand(),
                    ],
                  ),
                ],
              ).p(12).box.color(context.colors.surface).shadowXl.make(),
            ],
          ),
        );
      },
    );
  }
}
