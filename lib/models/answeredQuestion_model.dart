//import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
//import 'package:cta_projeto_autonomo/utilidades/env.dart';
//import 'package:flutter/material.dart';
import 'dart:convert';

// ignore: camel_case_types
class answeredQuestion {
  int id;
  int printed;
  int correct;
  int incorrect;
  bool get answered => printed > 0;
  bool lastCorrect = false;

  answeredQuestion.fromJson(Map json)
      : id = json['id'] is int ? json['id'] : 0,
        printed = json['printed'] is int ? json['printed'] : 0,
        correct = json['correct'] is int ? json['correct'] : 0,
        incorrect = json['incorrect'] is int ? json['incorrect'] : 0,
        lastCorrect = json['lastCorrect'] is bool ? json['lastCorrect'] : false;

  toJson() {
    return jsonEncode({
      'id': id,
      'printed': printed,
      'correct': correct,
      'incorrect': incorrect,
      'lastCorrect': lastCorrect,
    });
  }

  answeredQuestion(
      {this.id = 0, this.printed = 0, this.correct = 0, this.incorrect = 0});

  registerCorrect() {
    printed++;
    correct++;
    lastCorrect = true;
  }

  registerIncorrect() {
    printed++;
    incorrect++;
    lastCorrect = false;
  }
}
