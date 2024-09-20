import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/extensions/buildcontext.dart';
import 'package:meetup/models/messages.dart';
import 'package:meetup/view_models/ai_image_generator.vm.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AIImageGeneratorSettingsBottomsheet extends StatelessWidget {
  const AIImageGeneratorSettingsBottomsheet({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final AIImageGeneratorViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AIImageGeneratorViewModel>.reactive(
      viewModelBuilder: () => viewModel,
      onViewModelReady: (model) => model.initialise(),
      disposeViewModel: false,
      builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //
              "Settings".tr().text.xl2.semiBold.make(),
              20.heightBox,
              //options
              VStack(
                [
                  //image size
                  HStack(
                    [
                      "Image Size".tr().text.make().expand(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButton<ImageSize>(
                          isExpanded: true,
                          underline: Container(),
                          value: model.imageSize,
                          items: ImageSize.values.reversed
                              .map(
                                (e) => DropdownMenuItem<ImageSize>(
                                  child: e.name.text.make(),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            model.imageSize = value!;
                            model.notifyListeners();
                          },
                        ),
                      ).expand(),
                    ],
                  ),
                  //
                  10.heightBox,
                  //number of images
                  HStack(
                    [
                      "Number of Images".tr().text.make().expand(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButton<int>(
                          value: model.numberOfImages,
                          isExpanded: true,
                          underline: Container(),
                          items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  child: e.toString().text.make(),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            model.numberOfImages = value!;
                            model.notifyListeners();
                          },
                        ),
                      ).expand(),
                    ],
                  ),
                ],
              ),

              //
              20.heightBox,
              HStack(
                [
                  CustomButton(
                    title: "Reset".tr(),
                    color: Colors.grey.shade700,
                    onPressed: () {
                      model.resetAISettings();
                    },
                  ).h(40).expand(),
                  20.widthBox,

                  //
                  CustomButton(
                    title: "Apply".tr(),
                    onPressed: () {
                      context.pop();
                    },
                  ).h(40).expand(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
