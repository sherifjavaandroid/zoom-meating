// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_languages.dart';
import 'package:meetup/extensions/buildcontext.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/utils/ui_spacer.dart';
import 'package:meetup/widgets/menu_item.dart';
import 'package:velocity_x/velocity_x.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VStack(
        [
          //
          "Select your preferred language"
              .tr()
              .text
              .xl
              .semiBold
              .make()
              .py20()
              .px12(),
          UiSpacer.divider(),

          //
          VStack(
            [
              ...(AppLanguages.codes.mapIndexed((code, index) {
                return MenuItem(
                  title: AppLanguages.names[index],
                  suffix: Flag.fromString(
                    AppLanguages.flags[index].name,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () => _onSelected(context, code),
                );
              }).toList()),
            ],
          ).scrollVertical().expand(),
        ],
      ),
    ).hThreeForth(context);
  }

  void _onSelected(BuildContext context, String code) async {
    await AuthServices.setLocale(code);
    await Jiffy.setLocale(code);
    //
    await translator.setNewLanguage(
      context,
      newLanguage: code,
      remember: true,
      restart: true,
    );
    //
    context.pop();
  }
}
