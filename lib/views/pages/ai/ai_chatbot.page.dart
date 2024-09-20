import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_colors.dart';
import 'package:meetup/models/messages.dart';
import 'package:meetup/view_models/ai_chatbot.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class AIChatbotPage extends StatefulWidget {
  const AIChatbotPage({super.key});
  @override
  _AIChatbotPageState createState() => _AIChatbotPageState();
}

class _AIChatbotPageState extends State<AIChatbotPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AIChatBotViewModel>.reactive(
      viewModelBuilder: () => AIChatBotViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          title: "AI Chatbot".tr(),
          showAppBar: true,
          showLeadingAction: true,
          body: VStack(
            [
              //images listview
              Expanded(
                child: ListView.separated(
                  controller: model.chatMessagesScrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  itemBuilder: (context, index) {
                    final chat = model.messages[index];
                    final isBot = chat.role == Role.assistant;
                    final chatMsg = chat.content;
                    return VStack(
                      [
                        ((isBot ? "Bot" : "You").tr() + ":")
                            .text
                            .italic
                            .semiBold
                            .make(),
                        Container(
                          color: isBot
                              ? Colors.grey.shade300
                              : Colors.grey.shade100,
                          padding: const EdgeInsets.all(12),
                          child: chatMsg.text.make(),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => 10.heightBox,
                  itemCount: model.messages.length,
                ),
              ),
              10.heightBox,

              //input and send button
              VStack(
                [
                  //loading here
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: const BusyIndicator(color: AppColor.primaryColor)
                          .wh(30, 30)
                          .centered(),
                    ),
                    visible: model.isBusy,
                  ),
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
                  CustomButton(
                    onPressed: model.sendMessage,
                    child: HStack(
                      [
                        const Icon(LineIcons.paperPlane),
                        10.widthBox,
                        "Send".tr().text.make(),
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                      alignment: MainAxisAlignment.center,
                    ),
                  ).wFull(context).h(50),
                ],
              ).p(12).box.color(context.colors.surface).shadowXl.make(),
            ],
          ),
        );
      },
    );
  }
}
