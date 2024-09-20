import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_strings.dart';
import 'package:meetup/extensions/dynamic.dart';
import 'package:meetup/view_models/profile.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/cards/profile.card.dart';
import 'package:meetup/widgets/menu_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          body: VStack(
            [
              //
              // "Settings".tr().text.xl2.semiBold.make(),
              // "Profile & App Settings".tr().text.lg.light.make(),
              // 20.heightBox,

              //profile card
              ProfileCard(model),
              20.heightBox,
              //menu
              VxBox(
                child: VStack(
                  [
                    //
                    MenuItem(
                      title: "Notifications".tr(),
                      onPressed: model.openNotification,
                    ),

                    //
                    MenuItem(
                      title: "Rate & Review".tr(),
                      onPressed: model.openReviewApp,
                    ),

                    //
                    MenuItem(
                      title: "Verison".tr(),
                      suffix: model.appVersionInfo.text.make(),
                    ),

                    //
                    MenuItem(
                      title: "Privacy Policy".tr(),
                      onPressed: model.openPrivacyPolicy,
                    ),
                    //
                    MenuItem(
                      title: "Language".tr(),
                      divider: false,
                      suffix: const Icon(
                        LineIcons.globeWithAfricaShown,
                      ),
                      onPressed: model.changeLanguage,
                    ),
                  ],
                ),
              )
                  .border(color: Theme.of(context).cardColor)
                  .color(Theme.of(context).cardColor)
                  .shadowSm
                  .roundedSM
                  .make(),

              //
              "Copyright ©%s %s all right reserved"
                  .tr()
                  .fill([
                    "${DateTime.now().year}",
                    AppStrings.companyName,
                  ])
                  .text
                  .center
                  .sm
                  .makeCentered()
                  .py20(),

              (context.percentHeight * 15).heightBox,
            ],
          ).p20().scrollVertical(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
