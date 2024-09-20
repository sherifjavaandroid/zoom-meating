import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class MyBaseViewModel extends BaseViewModel {
  //
  BuildContext? viewContext;
  final formKey = GlobalKey<FormState>();
  String? firebaseVerificationId;

  void initialise() {}
}
