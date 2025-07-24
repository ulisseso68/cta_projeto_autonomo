//

import 'dart:convert';

import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/models/question_model.dart';
import 'package:cta_projeto_autonomo/models/answeredQuestion_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/languages.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cta_projeto_autonomo/utilidades/questions.dart';

class Funcoes {
  static List atividadesSelecionadas = [];
  static List cidadesSelecionadas = [];
  static List cidades = [];
  static String categorySelected = '';
  static String atividadeEscolhida = '';
  static double screenHeight = 800;
  static double screenWidth = 300;

  void calcular() {
    //print(autonomos.length);
  }

// functions to treat userName
  void setUserName(String name) {
    userName = name;
    setUserNameToStorage(name);
  }

  Future<void> setUserNameToStorage(String name) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('userName', name);
    userName = name;
  }

  Future<void> getUserNameFromStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userName = localStorage.getString('userName') ?? '';
  }

// functions to treat tcsAccepted
  void setTcsAccepted(bool value) {
    tcsAccepted = value;
    setTcsAcceptedToStorage(value);
  }

  Future<void> setTcsAcceptedToStorage(bool value) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setBool('tcsAccepted', value);
    tcsAccepted = value;
  }

  Future<void> getTcsAcceptedFromStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    tcsAccepted = localStorage.getBool('tcsAccepted') ?? false;
  }

  // functions to treat language settings
  void setLanguage(int lang) {
    language = lang;
    setLanguageToStorage(lang);
  }

  void setCountry(String country, String flag) {
    citizenship = country;
    countryFlag = flag;
    setCountryToStorage(country, flag);
  }

  Future<void> setCountryToStorage(String country, String flag) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('country', country);
    localStorage.setString('countryFlag', flag);
    await getCountryFromStorage();
  }

  Future<void> getCountryFromStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var savedCountry = localStorage.getString('country');
    var savedCountryFlag = localStorage.getString('countryFlag');
    if (savedCountry != null) {
      citizenship = savedCountry;
    } else {
      citizenship = ""; // Default value
    }
    if (savedCountryFlag != null) {
      countryFlag = savedCountryFlag;
    } else {
      countryFlag = ""; // Default value
    }
  }

// functions to treat language settings

  Future<void> getLanguageFromStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var savedlanguage = localStorage.getString('language');
    if (savedlanguage != null) {
      language = int.parse(savedlanguage);
    } else {
      language = 2;
    }
  }

  String get languageName {
    switch (language) {
      case 0:
        return 'English';
      case 1:
        return 'Português';
      case 2:
        return 'Español';
      default:
        return 'Unknown';
    }
  }

  Future<void> setLanguageToStorage(int value) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('language', value.toString());
    language = value;
    await getLanguageFromStorage();
  }

  String appLang(String sentence) {
    if (lang.containsKey(sentence)) {
      return lang[sentence]![language];
    } else {
      return sentence;
    }
  }

// functions to treat answered questions

  void clearAnsweredQuestions() {
    print(answeredQuestions.length);

    print('Clearing answered questions');
    answeredQuestions.clear();
    print(answeredQuestions.length);
    saveAnsweredQuestionsToLocal();
  }

  Future<void> saveAnsweredQuestionsToLocal() async {
    // You need to add shared_preferences to your pubspec.yaml
    // import 'package:shared_preferences/shared_preferences.dart';
    final prefs = await SharedPreferences.getInstance();
    List<String> questionsJson =
        answeredQuestions.map((q) => q.toJson().toString()).toList();
    await prefs.setStringList('answeredQuestions', questionsJson);
  }

  Future<void> deleteAnsweredQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('answeredQuestions');
    answeredQuestions.clear();
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

  dynamic findAnsweredQuestion(int id) {
    for (var i = 0; i < answeredQuestions.length; i++) {
      if (answeredQuestions[i].id == id) {
        return answeredQuestions[i];
      }
    }
    answeredQuestion newQuestion = answeredQuestion(id: id);
    answeredQuestions.add(newQuestion);
    return newQuestion;
  }

  Future<void> iniciarPreguntas() async {
    var questionsFromServer = await CallApi().getPublicData('questions/index');
    if (questionsFromServer is String) {
      questionsFromServer = questions;
      offlineMode = true;
    } else {
      offlineMode = false;
    }
    preguntas =
        questionsFromServer.map((e) => Question.fromServerJson(e)).toList();
  }

  List selectQuestions(String categoryChosen) {
    List selQue = [];
    selQue = preguntas
        .where((element) => element.category == categoryChosen)
        .toList();

    if (selQue.isEmpty) {
      selQue = preguntas;
    }
    selQue.sort((a, b) => a.getAnsQue.printed.compareTo(b.getAnsQue.printed));
    return selQue;
  }

  Future<void> initializeCatalog() async {
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
    uniqueCategories.add('Simulación del Examen');
    uniqueCategories = uniqueCategories.map((category) {
      return category
          .toString()
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }).toList();
  }

  // DEPRICATED

  /* Future<void> iniciarCidades() async {
    //cidades = await CallApi().getPublicData('cidades');
    cidades = cidadesConfig.toList();
    cidadesSelecionadas.addAll(cidades);
  } */

  List seleciona(String digitado) {
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
/* 
  List selecionaCidade(String digitado) {
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
 */
  // Statistics

  Map<String, int> statistics() {
    int total = 0;
    int answered = 0;
    int correct = 0;
    int printed = 0;

    List ques = selectQuestions(categorySelected.toUpperCase());
    total = ques.length;

    for (var i = 0; i < ques.length; i++) {
      answeredQuestion aques = findAnsweredQuestion(ques[i].id);
      printed += aques.printed;
      aques.answered ? answered++ : null;
      aques.lastCorrect ? correct++ : null;
    }

    return {
      'total': total,
      'answered': answered,
      'correct': correct,
      'printed': printed
    };
  }

  // WIDGETS

  // Used at Home Page
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
            color: Colors.red,
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

  // Used at Questionaire Closing
  // ignore: non_constant_identifier_names
  Widget KPIbox(
      double largura, String text1, String text2, Color backgroundColor,
      {Color foreColor = Colors.white, IconData icon = Icons.check}) {
    return Container(
      width: largura * 0.9,
      padding: const EdgeInsets.all(5),
      height: 95,
      child: ListTile(
        tileColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        leading: Icon(
          icon,
          size: 35,
          color: foreColor,
        ),
        title: Text(
          text1,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: foreColor),
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

  // HOME Page
  Widget questionaryOptions(
      bool isOpen, String title, String category, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Color.fromRGBO(255, 224, 178, 1),
          thickness: 1,
          height: 10,
        ),
        !isOpen
            ? Text("$title ${Funcoes().appLang("Questions")}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 15,
                  color: COR_02,
                ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverflowBar(
                    alignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: [
                      /* Icon(Icons.navigate_next_rounded, color: COR_02), */
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: COR_02,
                        ),
                        onPressed: () {
                          Funcoes.categorySelected = category;
                          numberOfQuestions = 10;
                          Navigator.pushNamed(context, 'questionsPage1');
                        },
                        child: Text(Funcoes().appLang("10"),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
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
                          numberOfQuestions = 25;
                          Navigator.pushNamed(context, 'questionsPage1');
                        },
                        child: Text(Funcoes().appLang("25"),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
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
                          numberOfQuestions = 1000;
                          Navigator.pushNamed(context, 'questionsPage1');
                        },
                        child: Text(Funcoes().appLang("All"),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
                      ),
                      if (Funcoes()
                          .wronglyAnsweredQuestions(category)
                          .isNotEmpty)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: redEspana,
                          ),
                          onPressed: () {
                            Funcoes.categorySelected = category;
                            numberOfQuestions = -1;
                            Navigator.pushNamed(context, 'questionsPage1');
                          },
                          child: Text(
                              Funcoes()
                                  .wronglyAnsweredQuestions(category)
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                        ),
                    ],
                  ),
                  /* SizedBox(
                    width: screenW * 0.6,
                    child: Divider(
                      color: Colors.white,
                      height: 10,
                      thickness: 1,
                    ),
                  ),
                  progressBar(category: category), */
                ],
              ),
      ],
    );
  }

  List wronglyAnsweredQuestions(String category) {
    List categoryQuestions = selectQuestions(category.toUpperCase());
    if (categoryQuestions.isEmpty) {
      return [];
    }
    categoryQuestions = categoryQuestions.map((e) => e.getAnsQue).toList();

    categoryQuestions = categoryQuestions
        .where((element) => element.answered && !element.lastCorrect)
        .toList();

    return categoryQuestions;
  }
  // Used at the HOME page and DRAWER

  Widget progressRings(
      {int total = 0,
      int answered = 0,
      int correct = 0,
      int printed = 0,
      double barSize = 0.6,
      String category = ''}) {
    List ques = Funcoes().selectQuestions(category.toUpperCase());
    total = ques.length;

    for (var i = 0; i < ques.length; i++) {
      answeredQuestion aques = Funcoes().findAnsweredQuestion(ques[i].id);
      printed += aques.printed;
      aques.answered ? answered++ : null;
      aques.lastCorrect ? correct++ : null;
    }

    return answered > 0
        ? Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Funcoes().semaforo(correct / (answered > 0 ? answered : 1)),
                  ),
                  value: correct / (answered > 0 ? answered : 1),
                  strokeWidth: 5,
                  strokeAlign: 4,
                  trackGap: 1,
                  /* color: Colors.grey, */
                  semanticsValue:
                      '${(correct / (answered > 0 ? answered : 1) * 100).toInt()}%',
                  backgroundColor: Colors.transparent),
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  value: answered / total,
                  strokeWidth: 5,
                  strokeAlign: 1,
                  /* color: Funcoes().semaforo(answered / total), */
                  semanticsValue: '${(answered / total * 100).toInt()}%',
                  backgroundColor: Colors.transparent),
            ],
          )
        : const SizedBox(
            height: 0,
          );
  }

  bool existsAnyAnsweredQuestion() {
    for (var i = 0; i < answeredQuestions.length; i++) {
      if (answeredQuestions[i].printed > 0) {
        return true;
      }
    }
    return false;
  }

  Widget progressBar(
      {int total = 0,
      int answered = 0,
      int correct = 0,
      int printed = 0,
      double barSize = 0.6,
      String category = ''}) {
    List ques = Funcoes().selectQuestions(category.toUpperCase());
    total = ques.length;

    for (var i = 0; i < ques.length; i++) {
      answeredQuestion aques = Funcoes().findAnsweredQuestion(ques[i].id);
      printed += aques.printed;
      aques.answered ? answered++ : null;
      aques.lastCorrect ? correct++ : null;
    }

    return answered > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Funcoes().appLang('Answered'),
                style: const TextStyle(fontSize: 14, color: COR_01),
              ),
              appProgressBar(barSize, answered / total, 0, color1: Colors.grey),
              const SizedBox(
                height: 5,
              ),
              appProgressBar(
                barSize,
                correct / (answered > 0 ? answered : 1),
                0,
                color1:
                    Funcoes().semaforo(correct / (answered > 0 ? answered : 1)),
              ),
              Text(
                Funcoes().appLang('Correctly'),
                style: const TextStyle(fontSize: 14, color: COR_01),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )
        : const SizedBox(
            height: 0,
          );
  }

  Widget appProgressBar(double barSize, double progress1, double progress2,
      {Color color1 = Colors.green,
      Color color2 = Colors.red,
      double barHeight = 20}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade100),
          height: barHeight,
          width: screenW * barSize,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: color2),
          height: barHeight,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 10),
          width: screenW * barSize * (progress1 + progress2),
          child: (progress2 > 0.20)
              ? Text(
                  '${(progress2 * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                )
              : const SizedBox(
                  width: 0,
                ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: color1),
          height: barHeight,
          width: screenW * barSize * progress1,
          child: Center(
            child: (progress1 > 0.20)
                ? Text(
                    '${(progress1 * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                    textAlign: TextAlign.end,
                  )
                : const SizedBox(
                    width: 0,
                  ),
          ),
        ),
      ],
    );
  }

  // Used at Home, Questionaire Closing
  Widget titleWithIcon(String title, String subTitle, BuildContext context,
      {bool isOpen = false,
      bool hasIcon = true,
      IconData icon = Icons.question_answer_rounded}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Funcoes().appLang(title),
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontSize: 20, color: COR_02, fontWeight: FontWeight.bold),
          ),
          const Divider(
            color: COR_02,
            height: 10,
            thickness: 1,
          ),
        ],
      ),
      subtitle: isOpen
          ? Text(
              Funcoes().appLang(subTitle),
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 14, color: COR_01),
            )
          : const SizedBox(
              height: 0,
            ),
      leading: hasIcon
          ? const Icon(
              Icons.question_answer_rounded,
              color: COR_02,
              size: 30,
            )
          : null,
    );
  }

  // Used at Many Pages
  Widget logoWidget(
      {double fontSize = 40,
      double opacity = 0.3,
      Color letterColor = Colors.white}) {
    return Container(
      //padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(opacity),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "CCSE",
            style: TextStyle(
                fontSize: fontSize,
                color: letterColor,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "fácil",
            style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'Bradley Hand',
                color: letterColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color semaforo(double value) {
    if (value < 0.6) {
      return Colors.red;
    } else if (value < 0.8) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
