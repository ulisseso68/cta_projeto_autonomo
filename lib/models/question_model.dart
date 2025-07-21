//import 'dart:ffi';
//import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
//import 'package:cta_projeto_autonomo/utilidades/env.dart';
//import 'package:flutter/material.dart';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/answeredQuestion_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class Question {
  int id;
  String ccse_id;
  String question;
  //bool hasDetails;
  List answers;
  String category;
  String? description;
  String? photo;

  Question(
      {this.id = 0,
      this.ccse_id = '',
      this.question = '',
      this.answers = const [],
      //this.hasDetails = false,
      this.category = ''});

  Question.fromJson(Map json)
      : id = json['id'] is int ? json['id'] : -1,
        ccse_id = json['ccse_id'] is String ? json['ccse_id'] : '',
        question =
            json['pergunta'] is String ? json['pergunta'] : 'sin pregunta',
        //hasDetails = json['hasDetails'] is bool ? json['hasDetails'] : false,
        answers = json['respostas'].toList(),
        category = json['tema'] is String ? json['tema'] : 'sin categoria',
        description = json['description'] is String ? json['description'] : '',
        photo = json['photo'] is String ? json['photo'] : '';

  Question.fromServerJson(Map json)
      : id = json['id'] is int ? json['id'] : -1,
        ccse_id = json['ccse_id'] is String ? json['ccse_id'] : '',
        question =
            json['question'] is String ? json['question'] : 'sin pregunta',
        //hasDetails = json['hasDetails'] is bool ? json['hasDetails'] : false,
        answers = json['answers'].toList(),
        category =
            json['category'] is String ? json['category'] : 'sin categoria',
        description = json['description'] is String ? json['description'] : '',
        photo = json['photo'] is String ? json['photo'] : '';

  bool get hasDetails {
    return (description != '');
  }

  answeredQuestion get getAnsQue => Funcoes().findAnsweredQuestion(id);

  ImageProvider imagem() {
    if (photo != null && photo!.isNotEmpty) {
      if (offlineMode) {
        return AssetImage('img/${ccse_id.toString()}.jpg');
      } else {
        return NetworkImage("$APP_URL/img$photo");
      }
    } else {
      return const AssetImage('img/ccse1.gif');
    }
  }
}
