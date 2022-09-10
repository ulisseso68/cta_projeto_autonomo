import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class CallApi {
  final String _url = API_URL;

  getPublicData(apiUrl) async {
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

  showAlert(context, msg, actionMsg) {
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
      throw 'Could not launch $_url';
    }
  }

  static Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.selectionClick',
    );
  }
}
