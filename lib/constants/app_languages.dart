import 'package:flag/flag_enum.dart';

class AppLanguages {
  //
  static List<String> get codes => [
        "en",
        "ar",
        "fr",
        "es",
        "ko",
        "de",
        "pt",
        "hi",
        "tr",
        "ru",
        "my",
        "zh-cn",
        "ja"
      ];
  static List<String> get names => [
        "English",
        "Arabic",
        "French",
        "Spanish",
        "Korean",
        "German",
        "Portuguese",
        "Hindi",
        "Turkish",
        "Russian",
        "Myanmar",
        "Chinese",
        "Japanese"
      ];

  static List<FlagsCode> get flags => [
        FlagsCode.US,
        FlagsCode.AE,
        FlagsCode.FR,
        FlagsCode.ES,
        FlagsCode.KR,
        FlagsCode.DE,
        FlagsCode.PT,
        FlagsCode.IN,
        FlagsCode.TR,
        FlagsCode.RU,
        FlagsCode.MY,
        FlagsCode.CN,
        FlagsCode.JP,
      ];
}
