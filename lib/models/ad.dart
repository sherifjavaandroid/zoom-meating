import 'dart:convert';

class Ad {
  Ad({
    this.android,
    this.ios,
  });

  AdData? android;
  AdData? ios;

  factory Ad.fromRawJson(String str) => Ad.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        android:
            json["android"] == null ? null : AdData.fromJson(json["android"]),
        ios: json["ios"] == null ? null : AdData.fromJson(json["ios"]),
      );

  Map<String, dynamic> toJson() => {
        "android": android?.toJson(),
        "ios": ios?.toJson(),
      };
}

class AdData {
  AdData({
    this.appId,
    this.bannerAdId,
    this.interstitialAdId,
    this.adEnable,
  });

  String? appId;
  String? bannerAdId;
  dynamic interstitialAdId;
  String? adEnable;

  factory AdData.fromRawJson(String str) => AdData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdData.fromJson(Map<String, dynamic> json) => AdData(
        appId: json["app_id"],
        bannerAdId: json["banner_ad_id"],
        interstitialAdId: json["interstitial_ad_id"],
        adEnable: json["ad_enable"],
      );

  Map<String, dynamic> toJson() => {
        "app_id": appId,
        "banner_ad_id": bannerAdId,
        "interstitial_ad_id": interstitialAdId,
        "ad_enable": adEnable,
      };
}
