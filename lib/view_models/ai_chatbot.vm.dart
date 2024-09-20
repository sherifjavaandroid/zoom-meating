import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/models/messages.dart';
import 'package:meetup/requests/ai.request.dart';
import 'package:velocity_x/velocity_x.dart';
import 'base.view_model.dart';

class AIChatBotViewModel extends MyBaseViewModel {
  AIChatBotViewModel(BuildContext context) {
    viewContext = context;
  }

  List<Messages> messages = [];
  // String conversionId = "";
  ScrollController chatMessagesScrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();
  AIRequest aiRequest = AIRequest();

  //
  sendMessage() async {
    //validate input
    final generateInput = textEditingController.text;
    if (generateInput.isEmpty) {
      viewContext!.showToast(
        msg: "Please enter message".tr(),
        textColor: Colors.white,
        bgColor: Colors.red,
      );
      return;
    }
    //if word is les than 3 characters
    if (generateInput.length < 2) {
      viewContext!.showToast(
        msg: "Please enter more than 2 characters to send message".tr(),
        textColor: Colors.white,
        bgColor: Colors.red,
      );
      return;
    }

    //
    messages.add(
      Messages(
        role: Role.user,
        content: generateInput,
      ),
    );
    textEditingController.clear();
    //scroll to bottom
    scrollToBottom();

    //
    setBusy(true);

    try {
      //
      final response = await aiRequest.chatCompletion(
        messages: messages,
        newMessage: generateInput,
      );
      //
      // conversionId = response.body['conversation_id'];
      for (var element in response.body['choices'] ?? []) {
        if (element["message"] == null) continue;
        messages.add(
          Messages(
            role: Role.assistant,
            content: element["message"]["content"],
          ),
        );
        //
        scrollToBottom();
      }
    } catch (error) {
      viewContext!.showToast(msg: error.toString());
    }
    setBusy(false);
  }

  //
  scrollToBottom() async {
    //download image from link
    try {
      chatMessagesScrollController
          .jumpTo(chatMessagesScrollController.position.maxScrollExtent);
      //
      chatMessagesScrollController.animateTo(
        chatMessagesScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (error) {
      viewContext!.showToast(msg: error.toString());
    }
  }
}
