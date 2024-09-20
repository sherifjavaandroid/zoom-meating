import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/services/validator.service.dart';
import 'package:meetup/view_models/edit_profile.vm.dart';
import 'package:meetup/widgets/base.page.dart';
import 'package:meetup/widgets/busy_indicator.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:meetup/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "Edit Profile".tr(),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //
                  Stack(
                    children: [
                      //
                      model.currentUser == null
                          ? const BusyIndicator()
                          : model.newPhoto == null
                              ? CachedNetworkImage(
                                  imageUrl: model.currentUser?.photo ?? "",
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return const BusyIndicator();
                                  },
                                  errorWidget: (context, imageUrl, progress) {
                                    return Image.asset(
                                      AppImages.user,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                  .box
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make()
                              : Image.file(
                                  model.newPhoto!,
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                  .box
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make(),

                      //
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: const Icon(
                          LineIcons.camera,
                          size: 16,
                        )
                            .p8()
                            .box
                            .color(context.theme.colorScheme.surface)
                            .roundedFull
                            .shadow
                            .make()
                            .onInkTap(model.changePhoto),
                      ),
                    ],
                  ).box.makeCentered(),

                  //form
                  Form(
                    key: model.formKey,
                    child: VStack(
                      [
                        //
                        CustomTextFormField(
                          labelText: "Name".tr(),
                          textEditingController: model.nameTEC,
                          validator: FormValidator.validateName,
                        ).py12(),
                        //
                        CustomTextFormField(
                          labelText: "Phone".tr(),
                          hintText: "+233-----",
                          keyboardType: TextInputType.phone,
                          textEditingController: model.phoneTEC,
                          validator: FormValidator.validatePhone,
                        ).py12(),
                        //
                        CustomTextFormField(
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: model.emailTEC,
                          validator: FormValidator.validateEmail,
                        ).py12(),

                        //
                        CustomButton(
                          title: "Update Profile".tr(),
                          loading: model.isBusy,
                          onPressed: model.processUpdate,
                        ).centered().py12(),
                      ],
                    ),
                  ).py20(),
                ],
              ).p20().scrollVertical()),
        );
      },
    );
  }
}
