import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/models/user.dart';
import 'package:meetup/requests/auth.request.dart';
import 'package:meetup/services/auth.service.dart';
import 'package:meetup/view_models/base.view_model.dart';
import 'package:stacked/stacked.dart';

class EditProfileViewModel extends MyBaseViewModel {
  late User? currentUser;
  late File? newPhoto;
  //the textediting controllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController phoneTEC = TextEditingController();

  //
  final AuthRequest _authRequest = AuthRequest();
  final picker = ImagePicker();

  EditProfileViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  void initialise() async {
    //
    currentUser = await AuthServices.getCurrentUser();
    nameTEC.text = currentUser!.name!;
    emailTEC.text = currentUser!.email!;
    phoneTEC.text = currentUser!.phone!;
    notifyListeners();
  }

  //
  void changePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      newPhoto = File(pickedFile.path);
    } else {
      newPhoto = null;
    }

    notifyListeners();
  }

  //
  processUpdate() async {
    //
    if (formKey.currentState!.validate()) {
      //
      setBusy(true);

      //
      final apiResponse = await _authRequest.updateProfile(
        photo: newPhoto,
        name: nameTEC.text,
        email: emailTEC.text,
        phone: phoneTEC.text,
      );

      //
      setBusy(false);

      //update local data if all good
      if (apiResponse.allGood) {
        //everything works well
        await AuthServices.saveUser(apiResponse.body["user"]);
      }

      //
      CoolAlert.show(
        context: viewContext!,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Profile Update".tr(),
        text: apiResponse.message,
        onConfirmBtnTap: apiResponse.allGood
            ? () {
                //
                viewContext!.popRoute();
                viewContext!.popRoute(true);
              }
            : null,
      );
    }
  }
}
