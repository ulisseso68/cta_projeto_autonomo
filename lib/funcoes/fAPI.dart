import 'dart:io';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CallApi {
  final String _url = API_URL;

  Future getPublicData(apiUrl) async {
    try {
      var response = await Dio().get(_url + apiUrl);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  void showAlert(context, msg, actionMsg) {
    final snackBar = SnackBar(
      backgroundColor: COR_02,
      content: msg,
      action: SnackBarAction(
        label: actionMsg,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Open Web Page
  void launchUrlOut(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }

      return 'test_device_001';
    } catch (e) {
      return 'test_device_001';
    }
  }
}
