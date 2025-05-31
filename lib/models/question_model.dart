//import 'dart:ffi';
//import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
//import 'package:cta_projeto_autonomo/utilidades/env.dart';
//import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/answeredQuestion_model.dart';

class Question {
  int id;
  String question;
  bool hasDetails;
  List answers;
  String category;
  String? description;
  String? photo;

  Question(
      {this.id = 0,
      this.question = '',
      this.answers = const [],
      this.hasDetails = false,
      this.category = ''});

  Question.fromJson(Map json)
      : id = json['id'] is int ? json['id'] : -1,
        question =
            json['pergunta'] is String ? json['pergunta'] : 'sin pregunta',
        hasDetails = json['hasDetails'] is bool ? json['hasDetails'] : false,
        answers = json['respostas'].toList(),
        category = json['tema'] is String ? json['tema'] : 'sin categoria',
        description = json['detalhe'] is String ? json['detalhe'] : '',
        photo = json['fotografia'] is String ? json['fotografia'] : '';

  Question.fromServerJson(Map json)
      : id = json['id'] is int ? json['id'] : -1,
        question =
            json['question'] is String ? json['question'] : 'sin pregunta',
        hasDetails = json['hasDetails'] is bool ? json['hasDetails'] : false,
        answers = json['answers'].toList(),
        category =
            json['category'] is String ? json['category'] : 'sin categoria',
        description = json['description'] is String ? json['description'] : '',
        photo = json['photo'] is String ? json['photo'] : '';

  answeredQuestion get getAnsQue => Funcoes().findAnsweredQuestion(id);

  /* Widget image() {
    return (foto != '')
        ? Hero(
            tag: foto + nome,
            child: Image(
              image: NetworkImage(foto),
              fit: BoxFit.cover,
            ),
          )
        : const Icon(
            Icons.badge,
            size: 40,
            color: COR_04,
          ); }*/

  /* String descricaoLimpa() {
    recomendado();
    getPreco();
    getURL();
    descricao = descricao.trim();
    return descricao;
  }

  bool recomendado() {
    if (descricao.contains('#AJrecomenda')) {
      recomenda = true;
      descricao = descricao.replaceAll('#AJrecomenda', '');
    }
    return recomenda;
  }

  String getPreco() {
    String tag = '#AJpreco{';
    if (descricao.contains(tag)) {
      var posi = descricao.indexOf(tag);
      String parte = descricao.substring(posi, descricao.length);
      String posf = parte.split('}').first;
      if (posf != '') {
        preco = posf.replaceAll(tag, '');
        descricao = descricao.replaceAll('$tag$preco}', '');
      }
    }
    return preco;
  }

  String getURL() {
    String tag = '#AJurl{';
    if (descricao.contains(tag)) {
      var posi = descricao.indexOf(tag);
      String parte = descricao.substring(posi, descricao.length);
      String posf = parte.split('}').first;
      if (posf != '') {
        url = posf.replaceAll(tag, '');
        descricao = descricao.replaceAll('$tag$url}', '');
      }
    }
    return url;
  }

  String localizacao() {
    return "$uf $cidade $cep";
  }

  Widget circledImage({Color bordercolor = Colors.green, double radius = 30}) {
    return (foto == '')
        ? Icon(
            Icons.badge,
            size: radius,
            color: bordercolor,
          )
        : Hero(
            tag: foto + nome,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                        color: bordercolor, blurRadius: 0.0, spreadRadius: 3.0)
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(foto),
                  )),
            ),
          );
  }

  void sendWA() {
    if (telefone != '') {
      var whatsappUrl = "whatsapp://send?phone=+55$telefone";
      print(whatsappUrl);
      CallApi().launchUrlOut(whatsappUrl);
    }
  } */
}
