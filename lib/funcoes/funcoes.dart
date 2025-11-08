//

import 'dart:convert';
//import 'dart:math';

import 'package:ccse_mob/funcoes/fAPI.dart';
import 'package:ccse_mob/models/question_model.dart';
import 'package:ccse_mob/models/answeredQuestion_model.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/languages.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccse_mob/utilidades/questions.dart';

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

// functions to treat descriptionsTranslations into local storage

  Future<void> saveDescriptionsTranslationsToStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(
        'descriptionsTranslations', jsonEncode(descriptionsTranslations));
  }

  Future<void> loadDescriptionsTranslationsFromStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? savedTranslations =
        localStorage.getString('descriptionsTranslations');
    if (savedTranslations != null) {
      descriptionsTranslations =
          Map<String, String>.from(jsonDecode(savedTranslations));
    } else {
      descriptionsTranslations = {};
    }
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
        return appLang('English');
      case 1:
        return appLang('Portuguese');
      case 2:
        return appLang('Spanish');
      case 3:
        return appLang('Moroccan Arabic');
      default:
        return appLang('Unknown');
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
      if (lang[sentence]!.length > language) {
        return lang[sentence]![language];
      }
      return sentence; // if the language is not available
    } else {
      return sentence;
    }
  }

// functions to treat answered questions

  void clearAnsweredQuestions() {
    answeredQuestions.clear();
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

    learnings.clear();
    for (var question in preguntas) {
      if (question.photo != null && question.photo != '') {
        if (learnings
            .where((element) => element.description == question.description)
            .isEmpty) {
          learnings.add(question);
        }
      }
    }
    learnings.shuffle();
  }

  /* Future<dynamic> _Translate() async {
    translationAvailable = false;
    translatedDescription = "";
    var translation;
    if (otherLanguage) {
      translation =
          await CallApi().postDataWithHeaders('questions/translation', {
        'deviceid': deviceID,
        'ccse_id': currentQuestion.ccse_id,
        'target_language': Funcoes().languageName
      }, {
        'Authorization': 'Bearer token'
      });

      if (translation != null && translation['success'] == true) {
        translatedQuestion = translation['translated_question'] ?? '';
        _translatedAnswers = [];
        for (var ans in translation['translated_answers']) {
          _translatedAnswers.add(ans ?? '');
        }
        translatedDescription = translation['translated_description'] ?? '';
        translationAvailable = true;
      }
    }
  } */

  void addTranslatedDescription(String key, String description) {
    descriptionsTranslations[key] = description;
    saveDescriptionsTranslationsToStorage();
  }

  String getTranslatedDescription(String key) {
    return descriptionsTranslations[key] ?? '';
  }

  List selectQuestions(String categoryChosen) {
    List selQue = [];

    if (categoryChosen == examCat || categoryChosen == '') {
      selQue = preguntas;
    } else {
      selQue = preguntas
          .where((element) =>
              element.category.toString().toLowerCase() ==
              categoryChosen.toLowerCase())
          .toList();
    }

    if (selQue.isNotEmpty) {
      selQue.sort((a, b) => a.getAnsQue.printed.compareTo(b.getAnsQue.printed));
    }
    return selQue;
  }

  List selectQuestionsForExam() {
    List selQue = [];
    List tempQue = [];

    for (var i = 0; i < uniqueCategories.length; i++) {
      var category = uniqueCategories[i];
      if (category != examCat) {
        tempQue =
            preguntas.where((element) => element.category == category).toList();
        tempQue.shuffle();
        if (ccseExam[category] is int) {
          selQue.addAll(tempQue.take(ccseExam[category]!));
          //print('selected ${ccseExam[category]} questions from $category');
        } else {
          selQue.addAll(
              tempQue.take(5)); // Default to 5 questions if not specified
        }
      }
    }
    return selQue;
  }

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

  String shortCat(String tarea) {
    if (shortCatMap.containsKey(tarea)) {
      return appLang(shortCatMap[tarea] ?? '');
    } else {
      return tarea;
    }
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
              image: AssetImage('img/ccse1.jpg'),
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
    return SizedBox(
      width: largura * 0.9,
      //padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            tileColor: foreColor,
            dense: true,
            leading: Icon(
              icon,
              size: 25,
              color: backgroundColor,
            ),
            title: Text(
              text1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor),
            ),
            subtitle: Text(
              text2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor),
            ),
            onTap: () {
              // Implement your onTap functionality here
            },
          ),
        ],
      ),
    );
  }

  List wronglyAnsweredQuestions(String category) {
    List categoryQuestions = selectQuestions(category.toUpperCase());
    if (categoryQuestions.isEmpty) {
      return [];
    }

    List wronglyAnswered = categoryQuestions.where((test) {
      answeredQuestion aques = findAnsweredQuestion(test.id);
      return aques.answered && !aques.lastCorrect;
    }).toList();
    if (wronglyAnswered.isEmpty) {
      return [];
    }
    return wronglyAnswered;
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

    return Stack(
      alignment: Alignment.center,
      children: [
        //total answers
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade200),
            value: 1,
            strokeWidth: 8,
            strokeAlign: 2,
            /* color: Funcoes().semaforo(answered / total), */
            semanticsValue: '100%',
            backgroundColor: Colors.transparent),

        //total answers
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(redEspana),
            value: answered / total,
            strokeWidth: 8,
            strokeAlign: 2,
            /* color: Funcoes().semaforo(answered / total), */
            semanticsValue:
                '${(answered / (total > 0 ? total : 1) * 100).toInt()}%',
            backgroundColor: Colors.transparent),

        // Correct Answers
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            value: correct / (total > 0 ? total : 1),
            strokeWidth: 8,
            strokeAlign: 2,
            semanticsValue:
                '${(correct / (total > 0 ? total : 1) * 100).toInt()}%',
            backgroundColor: Colors.transparent),
      ],
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
                (answered > 0)
                    ? '${Funcoes().appLang('You Have practiced')} $answered ${Funcoes().appLang('of')} $total ${Funcoes().appLang('Questions')}'
                    : Funcoes().appLang('No Questions Practiced'),
                style: const TextStyle(fontSize: 14, color: COR_01),
              ),
              appProgressBar(barSize, answered / total, 0, color1: Colors.grey),
              const SizedBox(
                height: 5,
              ),
              if (correct > 0)
                appProgressBar(
                  barSize,
                  correct / (answered > 0 ? answered : 1),
                  0,
                  color1: Funcoes()
                      .semaforo(correct / (answered > 0 ? answered : 1)),
                ),
              if (correct > 0)
                Text(
                  '${Funcoes().appLang('and responded correctly to')} ${('$correct (${int.parse((correct / (answered > 0 ? answered : 1) * 100).toStringAsFixed(0))}%)')}'
                  ' ${Funcoes().appLang('of them')}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Funcoes()
                          .semaforo(correct / (answered > 0 ? answered : 1))),
                ),
              const SizedBox(
                height: 5,
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Funcoes().appLang(
                  'You have not practiced any questions yet. Start practicing to see your progress here!'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
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
          child: Center(
            child: Text(
              appLang('Progress'),
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
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
      {double size = 0.08,
      double opacity = 0.3,
      Color letterColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      height: size * screenH,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Image(
        image: AssetImage('img/LogoHorizontal.png'),
        color: letterColor,
        fit: BoxFit.contain,
      ),
    );
  }

  // Bottom bar used at Home Page
  Widget uxBottomBar(SharePlus sharePlus, {corBottomBar = COR_02}) {
    final params = ShareParams(
      text: 'Check out this app: https://app.ccsefacil.es',
    );
    return BottomAppBar(
      color: corBottomBar,
      height: screenH / 15,
      shape: CircularNotchedRectangle(),
      child: SafeArea(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              IconButton(
                  tooltip: appLang('Follow us on Instagram'),
                  iconSize: 30,
                  onPressed: () {
                    CallApi()
                        .launchUrlOut('https://www.instagram.com/ccsefacil/');
                  },
                  icon: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                  )),
              IconButton(
                  iconSize: 30,
                  tooltip:
                      Funcoes().appLang('Share this app with your friends'),
                  onPressed: () async {
                    final result = await SharePlus.instance.share(params);
                    if (result.status == ShareResultStatus.success) {
                      //print('Thank you for sharing my website!');
                    }
                  },
                  icon: Icon(
                    Icons.upload,
                    color: Colors.white,
                  )),
              IconButton(
                  iconSize: 30,
                  tooltip: Funcoes().appLang('Rank our app on the Store'),
                  onPressed: () {
                    CallApi().launchUrlOut((deviceType == 'iOS')
                        ? 'https://apps.apple.com/es/app/ccse-facil/id6748478239?action=write-review'
                        : 'https://play.google.com/store/apps/details?id=com.ccsefacil.app2');
                  },
                  icon: Icon(
                    Icons.verified,
                    color: Colors.white,
                  )),
            ]),
      ),
    );
  }

  Color semaforo(double value) {
    if (value < 0.6) {
      return redEspana;
    } else if (value < 0.8) {
      return COR_02;
    } else {
      return Colors.green;
    }
  }

  Widget languageFlag(String languageCode, {double size = 40}) {
    // Assuming you have images named 'en.jpg', 'pt.jpg', 'es.jpg', etc. in the 'img' folder
    String code = 'en';
    switch (languageCode) {
      case '0':
        code = 'en';
        break;
      case '1':
        code = 'pt-br';
        break;
      case '2':
        code = 'es';
        break;
      case '3':
        code = 'mo';
        break;
      default:
        code = '';
    }
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipOval(
        child: Image(
          image: AssetImage("img/flags/$code.jpg"),
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }

  Future<void> configureAppForDeveloperMode(bool mode) async {
    developerMode = mode;
    if (mode) {
      //print('used AdMob Test Ids');
      bannerAdUnitIdIOS = 'ca-app-pub-3940256099942544/2934735716';
      bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
      nativeAdUnitIdIOS = 'ca-app-pub-3940256099942544/3986624511';
      nativeAdUnitIdAndroid = 'ca-app-pub-3940256099942544/2247696110';
    } else {
      //print('used AdMob Production Ids');
      await getAdUnitsFromServer();
      /* print('Ad Units from Server:');
      print('bannerAdUnitIdIOS: $bannerAdUnitIdIOS');
      print('bannerAdUnitIdAndroid: $bannerAdUnitIdAndroid');
      print('nativeAdUnitIdIOS: $nativeAdUnitIdIOS');
      print('nativeAdUnitIdAndroid: $nativeAdUnitIdAndroid'); */
    }
  }

  Future<void> toggleDeveloperMode() async {
    modoDeveloper = !modoDeveloper;
    developerMode = modoDeveloper;
    await Funcoes().configureAppForDeveloperMode(modoDeveloper);
  }

  Future<void> getAdUnitsFromServer() async {
    var adUnits = await CallApi().getPublicData('adunits');

    if (adUnits is String) {
      // Use default values already set
    } else {
      bannerAdUnitIdIOS = adUnits['bannerAdUnitIdIOS'] ?? bannerAdUnitIdIOS;
      bannerAdUnitIdAndroid =
          adUnits['bannerAdUnitIdAndroid'] ?? bannerAdUnitIdAndroid;
      nativeAdUnitIdIOS = adUnits['nativeAdUnitIdIOS'] ?? nativeAdUnitIdIOS;
      nativeAdUnitIdAndroid =
          adUnits['nativeAdUnitIdAndroid'] ?? nativeAdUnitIdAndroid;
    }
  }
}
