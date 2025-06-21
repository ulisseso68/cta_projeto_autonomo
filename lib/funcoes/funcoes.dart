//

import 'dart:convert';

import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/models/question_model.dart';
import 'package:cta_projeto_autonomo/models/answeredQuestion_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/languages.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Funcoes {
  static List atividadesSelecionadas = [];
  static List<Autonomo> autonomosSelecionados = <Autonomo>[];
  static List cidadesSelecionadas = [];

  static List cidades = [];
  static List<Autonomo> autonomos = <Autonomo>[];
  static String categorySelected = '';
  static String atividadeEscolhida = '';
  static Autonomo autonomoEscolhido = Autonomo();
  static double screenHeight = 800;
  static double screenWidth = 300;

  calcular() {
    //print(autonomos.length);
  }

  // functions to treat language settings
  void setLanguage(int lang) {
    language = lang;
    setLanguageToStorage(lang);
  }

  Future<void> getLanguageFromStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var savedlanguage = localStorage.getString('language');
    if (savedlanguage != null) {
      language = int.parse(savedlanguage);
    } else {
      language = 2;
    }
  }

  Future<void> setLanguageToStorage(int value) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('language', value.toString());
    await getLanguageFromStorage();
  }

  String appLang(String sentence) {
    if (lang.containsKey(sentence)) {
      return lang[sentence]![language];
    } else {
      return sentence;
    }
  }

  Future<void> saveAnsweredQuestionsToLocal() async {
    // You need to add shared_preferences to your pubspec.yaml
    // import 'package:shared_preferences/shared_preferences.dart';
    final prefs = await SharedPreferences.getInstance();
    List<String> questionsJson =
        answeredQuestions.map((q) => q.toJson().toString()).toList();
    await prefs.setStringList('answeredQuestions', questionsJson);
  }

  Future<List<answeredQuestion>> loadAnsweredQuestionsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? questionsJson = prefs.getStringList('answeredQuestions');
    if (questionsJson != null) {
      return questionsJson
          .map((q) => answeredQuestion.fromJson(jsonDecode(q)))
          .toList();
    }
    return [];
  }

  findAnsweredQuestion(int id) {
    for (var i = 0; i < answeredQuestions.length; i++) {
      if (answeredQuestions[i].id == id) {
        return answeredQuestions[i];
      }
    }
    answeredQuestion newQuestion = answeredQuestion(id: id);
    answeredQuestions.add(newQuestion);
    return newQuestion;
  }

  iniciarPreguntas() async {
    var questionsFromServer = await CallApi().getPublicData('questions/index');
    //preguntas = preguntasConfig.map((e) => Question.fromJson(e)).toList();
    preguntas =
        questionsFromServer.map((e) => Question.fromServerJson(e)).toList();
  }

  List selectQuestions(String categoryChosen) {
    return preguntas
        .where((element) => element.category == categoryChosen)
        .toList();
  }

  initializeCatalog() async {
    //catalogConfig = await CallApi().getPublicData('catalog');

    await iniciarPreguntas();
    uniqueCategories.clear();

    for (var i = 0; i < preguntas.length; i++) {
      if (!uniqueCategories
          .toString()
          .contains(preguntas[i].category.toString())) {
        uniqueCategories.add(preguntas[i].category);
      }
    }

    uniqueCategories = uniqueCategories.map((category) {
      return category
          .toString()
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }).toList();
  }

  iniciarCidades() async {
    //cidades = await CallApi().getPublicData('cidades');
    cidades = cidadesConfig.toList();
    cidadesSelecionadas.addAll(cidades);
  }

  buscarAutonomos({String cidadeNome = '', String nomeAtividade = ''}) async {
    Iterable res = await CallApi().getPublicData(
        'autonomos?cidade__nome=$cidadeNome&nome_atividade=$nomeAtividade');

    autonomos = res.map((e) => Autonomo.fromJson(e)).toList();
    autonomosSelecionados.addAll(autonomos);
  }

  adicionarAutonomos(List<Autonomo> novos) {
    autonomos.addAll(novos);
  }

  seleciona(String digitado) {
    atividadesSelecionadas.clear();
    for (var ativ in atividades) {
      if (ativ['nome']
          .toString()
          .toLowerCase()
          .contains(digitado.toLowerCase())) {
        atividadesSelecionadas.add(ativ);
      }
    }
    if (atividadesSelecionadas.isEmpty) {
      if (digitado == '') {
        return atividades;
      } else {
        atividadesSelecionadas.add({'id': 0, 'nome': 'Categoria Inexistente'});
      }
    }
    return atividadesSelecionadas;
  }

  selecionaCidade(String digitado) {
    cidadesSelecionadas.clear();
    for (var ativ in cidades) {
      if (ativ['nome']
          .toString()
          .toLowerCase()
          .contains(digitado.toLowerCase())) {
        cidadesSelecionadas.add(ativ);
      }
    }
    if (cidadesSelecionadas.isEmpty) {
      if (digitado == '') {
        return cidades;
      } else {
        cidadesSelecionadas.add({'id': 0, 'nome': 'Cidade Inexistente'});
      }
    }
    return cidadesSelecionadas;
  }

  filtraAutonomos(String nomeatividade) {
    Funcoes.autonomosSelecionados.clear();
    for (var autonomo in Funcoes.autonomos) {
      if (autonomo.atividade
          .toString()
          .toLowerCase()
          .contains(nomeatividade.toLowerCase())) {
        autonomosSelecionados.add(autonomo);
      }
    }
    return autonomosSelecionados;
  }

  Widget splash(double largura, double altura, {double fSize = 15}) {
    return Stack(
      children: [
        Container(
            color: COR_02,
            height: altura / 2,
            width: largura,
            child: const Image(
              image: AssetImage('img/ccse1.gif'),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            height: largura / 4,
            color: Colors.red.withOpacity(0.8),
            width: largura / 3 * 2 * 0.95,
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Text(
              "CCSE es una prueba de examen que evalúa el conocimiento de la Constitución y de la realidad social y cultural españolas",
              textAlign: TextAlign.end,
              maxLines: 4,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Image(
            image: const AssetImage('img/ccse.png'),
            fit: BoxFit.cover,
            width: largura / 4,
            height: largura / 4,
          ),
        ),
      ],
    );
  }

  //KPIbox widget to display key performance indicators
  Widget KPIbox(
      double largura, String text1, String text2, Color backgroundColor,
      {Color foreColor = Colors.white, IconData icon = Icons.check}) {
    return SizedBox(
      width: largura * 0.5,
      height: 95,
      child: ListTile(
        tileColor: backgroundColor,
        trailing: Icon(
          icon,
          size: 30,
          color: foreColor,
        ),
        title: Text(
          text1,
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: foreColor),
        ),
        subtitle: Text(
          text2,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: foreColor),
        ),
        onTap: () {
          // Implement your onTap functionality here
        },
      ),
    );
  }

  Widget questionaryOptions(bool isOpen, double largura, double altura,
      String title, String category) {
    return isOpen
        ? Text("$title ${Funcoes().appLang("Questions")}",
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 15,
              color: COR_02,
            ))
        : ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: COR_02,
                ),
                onPressed: () {
                  Funcoes.categorySelected = category;
                  //Navigator.pushNamed(context, 'questionsPage1');
                },
                child: Text(Funcoes().appLang("25"),
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: COR_02,
                ),
                onPressed: () {
                  Funcoes.categorySelected = category;
                  //Navigator.pushNamed(context, 'questionsPage1');
                },
                child: Text(Funcoes().appLang("All"),
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
              ),
            ],
          );
  }
}
