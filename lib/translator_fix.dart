// ignore_for_file: avoid_print, unnecessary_new, prefer_collection_literals

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:translator/translator.dart';

import 'constants/app_languages.dart';

void main() async {
  final dir = Directory('assets/lang');
  final translator = GoogleTranslator();
  //
  final List<FileSystemEntity> entities = await dir.list().toList();
  //get the new-lang values
  print("Loadding New Lang Strings");
  final fullLanguageStringsEntity = entities.firstWhere(
    (e) => e.path.endsWith("full-lang.txt"),
  );

//
  print("Loadding New Lang Strings");
  File file = File(fullLanguageStringsEntity.path);
  List<String> fullLangStrings = (await file.readAsString()).split("\n");
  //
  for (var code in AppLanguages.codes) {
    //loop through new-lang and use api to translate it
    print("Translating ==> $code");
    try {
      //
      FileSystemEntity langFileEntity = entities.firstWhere(
        (e) => e.path.toLowerCase().contains(code.toLowerCase()),
      );
      //
      File langFile;

      try {
        langFile = File(langFileEntity.path);
      } catch (error) {
        langFile = await File("assets/lang/$code.json").create();
        await langFile.writeAsString("{}");
      }

      //
      final oldLangJson = jsonDecode(await langFile.readAsString());

      //pro 1
      Map<String, String> newTranslatedData = new Map<String, String>();
      int count = 1;

      //
      for (var text in fullLangStrings) {
        //checking if the text is already translated for language code
        if (oldLangJson is Map && oldLangJson.containsKey(text)) {
          // print("Skipped:: $text");
          // count++;
          continue;
        }
        //translate if the text has not been translated before
        if (code != "en") {
          final translation = await translator.translate(text, to: code);
          newTranslatedData[text] = translation.text;
        } else {
          newTranslatedData[text] = text;
        }
        //
        print("Translated:: $text");
        print("Done:: $count/${fullLangStrings.length}");
        count++;
      }

      //
      final newMergedLangJson = {...newTranslatedData, ...oldLangJson};
      log("New JSON ==> ${jsonEncode(newMergedLangJson)}");
      await langFile.writeAsString(jsonEncode(newMergedLangJson));
    } catch (error) {
      print("Error with:: $error");
    }
    print("-----------------------");
    // print("New Json ==> ${jsonEncode(newTranslatedData)}");
    // print("Old Json ==> ${jsonEncode(oldLangJson)}");
    // print("Merged Json ==> ${jsonEncode(newMergedLangJson)}");
    // print("-----------------------");
  }
}
