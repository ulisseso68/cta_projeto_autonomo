import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/paginas/drawer.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:ccse_mob/funcoes/fAPI.dart';

class QuestionsPage1 extends StatefulWidget {
  const QuestionsPage1({super.key});

  @override
  State<QuestionsPage1> createState() => _QuestionsPage1();
}

class _QuestionsPage1 extends State<QuestionsPage1> {
  // ignore: prefer_final_fields
  List _preguntasSelecionadas = [];
  List _respostasLista = [];

  bool responded = false;
  int respostaErrada = -1;
  int iResp = 0;
  int printed = 0;
  int answeredCorrect = 0;
  bool beat = false;
  bool translate = false;
  List _translatedAnswers = [];
  String translatedQuestion = '';

  @override
  initState() {
    otherLanguage = (language != 2) ? true : false;
    translationAvailable = false;
    translatedDescription = "";
    indexPreguntas = 0;
    respostasCorretas = 0;
    respostasErradas = 0;
    temaPreguntas = Funcoes.categorySelected.toUpperCase();
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    if (Funcoes.categorySelected == examCat) {
      _preguntasSelecionadas.clear();
      _preguntasSelecionadas = Funcoes().selectQuestionsForExam();
    } else {
      if (numberOfQuestions > 0) {
        _preguntasSelecionadas =
            Funcoes().selectQuestions(Funcoes.categorySelected.toUpperCase());
        _preguntasSelecionadas =
            _preguntasSelecionadas.take(numberOfQuestions).toList();
      } else {
        _preguntasSelecionadas =
            Funcoes().wronglyAnsweredQuestions(Funcoes.categorySelected);
        numberOfQuestions = _preguntasSelecionadas.length;
      }
    }

    currentQuestion = _preguntasSelecionadas[indexPreguntas];
    printed = currentQuestion.getAnsQue.printed;
    answeredCorrect = currentQuestion.getAnsQue.correct;
    _respostasLista = _preguntasSelecionadas[indexPreguntas].answers;

    await _Translate();

    setState(() {});
  }

  Future<void> _Translate() async {
    translationAvailable = false;
    translatedDescription = "";
    if (otherLanguage) {
      translation =
          await CallApi().postDataWithHeaders('questions/translation', {
        'deviceid': deviceID,
        'ccse_id': currentQuestion.ccse_id,
        'target_language': Funcoes().languageName
      }, {
        'Authorization': 'Bearer token'
      });

      if (translation is Map<String, dynamic> &&
          translation['success'] == true) {
        translatedQuestion = translation['translated_question'] ?? '';
        _translatedAnswers = [];
        for (var ans in translation['translated_answers']) {
          _translatedAnswers.add(ans ?? '');
        }
        translatedDescription = translation['translated_description'] ?? '';
        if (translatedDescription != "") {
          Funcoes().addTranslatedDescription(
              '${language.toString()}${currentQuestion.ccse_id}',
              translatedDescription);
        }
        translationAvailable = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    // ignore: prefer_typing_uninitialized_variables
    //var textController;

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white, size: 40),
          backgroundColor: COR_02,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Funcoes().logoWidget(opacity: 0),
              /* Hero(
              tag: 'splash_image',
              child: Image(
                width: largura * 0.15,
                image: AssetImage('img/CCSEf.png'),
                fit: BoxFit.fill,
              ),
            ), */
            ],
          ),
          //shadowColor: Colors.white70.withOpacity(0.0),
        ),
        endDrawer: AJDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Container with the question
              Container(
                width: largura,
                //color: COR_02.withOpacity(0.1),
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Funcoes().appLang(
                                "${Funcoes().appLang("Question")}: ${(indexPreguntas + 1).toString()} / ${_preguntasSelecionadas.length.toString()}"),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 20,
                                color: COR_02,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: COR_02,
                            height: 10,
                            thickness: 1,
                          ),
                        ],
                      ),
                      trailing: (otherLanguage && translationAvailable)
                          ? FloatingActionButton(
                              heroTag: 'translate_button',
                              onPressed: () {
                                setState(() {
                                  translate = !translate;
                                });
                              },
                              shape: const StadiumBorder(),
                              backgroundColor: COR_04.shade800,
                              child: const Icon(Icons.translate_rounded,
                                  color: Colors.white, size: 30),
                            )
                          : null,
                    ),
                    ListTile(
                      title: Text(
                        (_preguntasSelecionadas.isEmpty ||
                                indexPreguntas >= _preguntasSelecionadas.length)
                            ? 'No hay preguntas para esta selección'
                            : (translate)
                                ? translatedQuestion
                                : _preguntasSelecionadas[indexPreguntas]
                                    .question,
                        //maxLines: 4,
                        style: TextStyle(
                          color: (!translate) ? COR_01 : COR_04.shade800,
                          fontSize: 24,
                        ),
                      ),
                      trailing: (_preguntasSelecionadas[indexPreguntas]
                              .hasDetails)
                          ? IconButton(
                              icon: Icon(
                                Icons.tips_and_updates,
                                size: 40,
                                color: (translate) ? COR_04.shade800 : COR_02,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'learningPage',
                                );
                              })
                          : null,
                    ),
                  ],
                ),
              ),

              Container(
                color: (!translate) ? COR_02 : COR_04.shade800,
                height: 5,
                margin: EdgeInsets.only(
                    left: screenW * 0.05, right: screenW * 0.05),
              ),

              Container(
                padding: EdgeInsets.all(screenW * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildAnswersTiles(_respostasLista),
                ),
              ),

              (_preguntasSelecionadas[indexPreguntas].hasDetails)
                  ? Container(
                      height: screenH / 4,
                      width: screenW * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: currentQuestion.imagem(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(),
              Divider(
                thickness: 5,
                height: screenH / 10,
                indent: 10,
                endIndent: 10,
                color: Colors.white,
              ),
              // Container with the answers
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          backgroundColor: (responded) ? COR_02 : Colors.grey.shade500,
          onPressed: () {
            if (responded) {
              setState(() {
                indexPreguntas++;
                Funcoes().saveAnsweredQuestionsToLocal();
                if (indexPreguntas >= _preguntasSelecionadas.length) {
                  indexPreguntas--;
                  Navigator.pushNamed(context, 'questionsClosing');
                } else {
                  currentQuestion = _preguntasSelecionadas[indexPreguntas];
                  _respostasLista =
                      _preguntasSelecionadas[indexPreguntas].answers;
                  _Translate().then((_) {
                    setState(() {});
                  });
                  responded = false;
                  respostaErrada = -1;
                  translate = false;
                }
              });
            }
          },
          child: const Icon(Icons.arrow_forward_rounded,
              color: Colors.white, size: 30),
        ),
        bottomNavigationBar: BottomAppBar(
          height: screenH / 15,
          shape: CircularNotchedRectangle(),
          color: COR_02,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Funcoes().appProgressBar(
                    0.7,
                    ((respostasCorretas) / _preguntasSelecionadas.length),
                    ((respostasErradas) / _preguntasSelecionadas.length),
                    barHeight: 25),
              ],
            ),
          ),
        ));
  }

  List<Widget> _buildAnswersTiles(List answers) {
    List<Widget> tiles = [];

    for (var iRep = 0; iRep < answers.length; iRep++) {
      var answer = answers[iRep];

      tiles.add(
        ListTile(
          visualDensity: VisualDensity.comfortable,
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: (responded)
              ? (answer['Correct'])
                  ? Colors.green.shade300
                  : Colors.grey.shade100
              : ((iRep % 2 == 0) ? Colors.grey.shade100 : Colors.white),
          title: Text(
            (translate) ? _translatedAnswers[iRep] : answer['answer'],
            textAlign: TextAlign.left,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 22,
                color: (respostaErrada == iRep)
                    ? Colors.red
                    : (!translate)
                        ? COR_01
                        : COR_04.shade800,
                fontFamily: 'Verdana'),
          ),
          onTap: () => setState(() {
            setState(() {
              if (!responded) {
                if (answer['Correct']) {
                  respostasCorretas++;
                  Funcoes()
                      .findAnsweredQuestion(
                          _preguntasSelecionadas[indexPreguntas].id)
                      .registerCorrect();
                } else {
                  respostasErradas++;
                  respostaErrada = iRep;

                  Funcoes()
                      .findAnsweredQuestion(
                          _preguntasSelecionadas[indexPreguntas].id)
                      .registerIncorrect();
                  //print("Resposta errada: $respostaErrada");
                }
                responded = true;
              }
            });
          }),
          leading: IconButton(
            onPressed: () {
              setState(() {
                setState(() {
                  if (!responded) {
                    responded = true;
                    if (answer["Correct"]) {
                      respostasCorretas++;
                      // Register the answer as correct
                      currentQuestion.getAnsQue.registerCorrect();
                    } else {
                      respostasErradas++;
                      respostaErrada = iRep;
                      // Register the answer as incorrect
                      currentQuestion.getAnsQue.registerIncorrect();
                    }
                  }
                });
              });
            },
            icon: Icon(
              (responded & answer['Correct'])
                  ? Icons.check_circle
                  : (respostaErrada == iRep)
                      ? Icons.cancel
                      : Icons.radio_button_unchecked,
              color: (respostaErrada == iRep) ? Colors.red : COR_01,
              size: 20,
            ),
          ),
        ),
      );
      tiles.add(
        const SizedBox(
          height: 5,
        ),
      );
    }
    return tiles;
  }
}
