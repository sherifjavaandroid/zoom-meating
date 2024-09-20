import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/view_models/profile.vm.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:meetup/widgets/menu_item.dart';
import 'package:meetup/widgets/states/empty.state.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {Key? key}) : super(key: key);

  final ProfileViewModel model;
  @override
  Widget build(BuildContext context) {
    return model.authenticated
        ? VStack(
            [
              //profile card
              HStack(
                [
                  //
                  CachedNetworkImage(
                    imageUrl: model.currentUser!.photo!,
                    progressIndicatorBuilder: (context, imageUrl, progress) {
                      return const BusyIndicator();
                    },
                    errorWidget: (context, imageUrl, progress) {
                      return Image.asset(
                        AppImages.user,
                      );
                    },
                  ).wh(Vx.dp64, Vx.dp64).box.roundedFull.make(),

                  //
                  VStack(
                    [
                      //name
                      model.currentUser!.name!.text.xl.semiBold.make(),
                      //email
                      model.currentUser!.email!.text.light.make(),
                    ],
                  ).px20(),

                  //
                ],
              ).p12(),

              //
              MenuItem(
                title: "Edit Profile".tr(),
                onPressed: model.openEditProfile,
                topDivider: true,
              ),
              MenuItem(
                title: "Logout".tr(),
                onPressed: model.logoutPressed,
                divider: false,
                suffix: const Icon(
                  LineIcons.alternateSignOut,
                  size: 16,
                ),
              ),
              MenuItem(
                child: "Delete Account".tr().text.red500.make(),
                onPressed: model.deleteAccountPressed,
                topDivider: true,
                divider: false,
                suffix: Icon(
                  LineIcons.trash,
                  color: Colors.red[500],
                  size: 16,
                ),
              ),
            ],
          )
            .wFull(context)
            .box
            .border(color: Theme.of(context).cardColor)
            .color(Theme.of(context).cardColor)
            .shadow
            .roundedSM
            .make()
        : EmptyState(
            auth: true,
            showAction: true,
            actionPressed: model.openLogin,
          ).py12();
  }
}
