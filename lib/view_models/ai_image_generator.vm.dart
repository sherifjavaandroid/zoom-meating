import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/models/messages.dart';
import 'package:meetup/requests/ai.request.dart';
import 'package:meetup/views/pages/ai/widgets/ai_image_generator_settings.bottomsheet.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'base.view_model.dart';

class AIImageGeneratorViewModel extends MyBaseViewModel {
  AIImageGeneratorViewModel(BuildContext context) {
    viewContext = context;
  }

  List<dynamic> images = [];
  //settings
  int numberOfImages = 2;
  ImageSize imageSize = ImageSize.size256;
  AIRequest aiRequest = AIRequest();

  final TextEditingController textEditingController = TextEditingController();

  //open bottom sheet
  openAISettings() async {
    showModalBottomSheet(
      context: viewContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AIImageGeneratorSettingsBottomsheet(viewModel: this);
      },
    );
  }

  resetAISettings() {
    numberOfImages = 2;
    imageSize = ImageSize.size256;
    notifyListeners();
  }

  //
  generateImage() async {
    //validate input
    final generateInput = textEditingController.text;
    if (generateInput.isEmpty) {
      viewContext!.showToast(msg: "Please enter text to generate image".tr());
      return;
    }
    //if word is les than 3 characters
    if (generateInput.length < 3) {
      viewContext!.showToast(
          msg: "Please enter more than 3 characters to generate image".tr());
      return;
    }

    //
    setBusy(true);

    try {
      //generate image
      final response = await aiRequest.generateImage(
        prompt: generateInput,
        numberOfImages: numberOfImages,
        size: imageSize,
      );
      //if response is successful
      if (response.data.isNotEmpty) {
        //clear images
        images.clear();
        //
        for (var element in response.data) {
          images.add(element!["url"]);
        }

        //clear input
        textEditingController.clear();
        //notify listeners
        notifyListeners();
      } else {
        viewContext!.showToast(
          bgColor: Colors.red,
          textColor: Colors.white,
          msg: "Failed to generate image".tr(),
          position: VxToastPosition.top,
        );
      }
    } catch (error) {
      viewContext!.showToast(
        bgColor: Colors.red,
        textColor: Colors.white,
        msg: error.toString(),
        position: VxToastPosition.top,
      );
    }
    setBusy(false);
  }

  //
  previewImage(String imageUrl) {
    try {
      showModalBottomSheet(
        context: viewContext!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return CachedNetworkImage(
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
            width: double.infinity,
          )
              .h(context.percentHeight * 85)
              .wFull(context)
              .box
              .white
              .topRounded(value: 20)
              .make();
        },
      );
    } catch (error) {
      viewContext!.showToast(
        bgColor: Colors.red,
        textColor: Colors.white,
        msg: error.toString(),
        position: VxToastPosition.top,
      );
    }
  }

  //
  downloadImage(link) async {
    //download image from link
    setBusyForObject(link, true);
    try {
      var response = await Dio().get(
        link,
        options: Options(responseType: ResponseType.bytes),
      );
      await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
      );
      viewContext!.showToast(
        bgColor: Colors.green,
        textColor: Colors.white,
        msg: "Image downloaded successfully".tr(),
        position: VxToastPosition.top,
      );
    } catch (error) {
      viewContext!.showToast(
        bgColor: Colors.red,
        textColor: Colors.white,
        msg: error.toString(),
        position: VxToastPosition.top,
      );
    }
    //
    setBusyForObject(link, false);
  }
}
