import 'dart:io';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cta_projeto_autonomo/utilidadeS/dados.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class CallApi {
  final String _url = API_URL;

  Future<void> sendEmail(String subject, String body) async {
    final Email email = Email(
      body: deviceID + '\n\n' + body,
      subject: subject,
      recipients: ['soporte@ccsefacil.es'],
    );

    await FlutterEmailSender.send(email);
  }

  Future getPublicData(apiUrl) async {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    try {
      print('Fetching public data from: $_url$apiUrl');
      var response = await dio.get(_url + apiUrl);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future postData(apiUrl, data) async {
    try {
      print(_url + apiUrl);
      var response = await Dio().post(_url + apiUrl, data: data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  Future postDataWithHeaders(apiUrl, data, headers) async {
    try {
      var response = await Dio()
          .post(_url + apiUrl, data: data, options: Options(headers: headers));

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Execute a Simple Journal Entry
  Future<void> createJournalEntry(
      {String description = '', String type = 'journal', value = 0.0}) async {
    postDataWithHeaders('journals/process', {
      'deviceid': await getId(),
      'type': type,
      'value': value,
      'description': description
    }, {
      'Authorization': 'Bearer token'
    });
  }

  void showAlert(context, msg, actionMsg) {
    final snackBar = SnackBar(
      backgroundColor: redEspana,
      closeIconColor: Colors.white,
      duration: const Duration(seconds: 3),
      content: msg,
      action: SnackBarAction(
        textColor: Colors.white,
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
