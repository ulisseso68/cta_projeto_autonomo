import 'dart:async';
import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/utilidades/policy.dart';

class QuestionsExam extends StatefulWidget {
  const QuestionsExam({super.key});

  @override
  State<QuestionsExam> createState() => _QuestionsExam();
}

class _QuestionsExam extends State<QuestionsExam> {
  // ignore: prefer_final_fields
  List _preguntasSelecionadas = [];
  List _respostasLista = [];
  bool responded = false;
  int respostaErrada = -1;
  int printed = 0;
  int answeredCorrect = 0;
  bool beat = false;
  bool examPresented = false;
  var counter = 45 * 60;
  late Timer clock;

  void updateTimer(Timer timer) {
    counter--;
    setState(() {});
    if (counter == 0) {
      timer.cancel();
      respostasErradas = 25 - respostasCorretas;
      CallApi().showAlert(
          context,
          Text(
            Funcoes().appLang('Time is up!'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Verdana',
                overflow: TextOverflow.ellipsis),
          ),
          'OK');
      Navigator.pushReplacementNamed(context, 'examClosing');
    }
  }

  @override
  initState() {
    indexPreguntas = 0;
    respostasCorretas = 0;
    respostasErradas = 0;
    temaPreguntas = Funcoes.categorySelected.toUpperCase();
    _getData();

    clock = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTimer(timer);
    });

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
    setState(() {});
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 30),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(Funcoes().appLang('Exit Exam?'),
                      style: TextStyle(
                          color: COR_02,
                          fontFamily: 'Verdana',
                          fontWeight: FontWeight.bold)),
                  content: Text(
                    Funcoes()
                        .appLang('Are you sure you want to exit the exam?'),
                    style: TextStyle(
                        color: COR_01, fontFamily: 'Verdana', fontSize: 15),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: COR_02,
                      ),
                      child: Text(Funcoes().appLang('Cancel'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Verdana')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: COR_02,
                      ),
                      child: Text(Funcoes().appLang('Yes'),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Verdana')),
                      onPressed: () {
                        clock.cancel();
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),

        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        backgroundColor: COR_02,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Funcoes().logoWidget(fontSize: 35, opacity: 0),
            Hero(
              tag: 'splash_image',
              child: Image(
                width: largura * 0.15,
                image: AssetImage('img/CCSEf.png'),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        //shadowColor: Colors.white70.withOpacity(0.0),
      ),
      body: SingleChildScrollView(
        child: (examPresented)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Container with the question
                  Container(
                    width: largura,
                    //color: COR_02.withOpacity(0.1),
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Funcoes().titleWithIcon(
                            Funcoes().appLang('CCSE - Simulated Exam'),
                            "${Funcoes().appLang("Question")}(${_preguntasSelecionadas[indexPreguntas].ccse_id}): ${(indexPreguntas + 1).toString()} / ${_preguntasSelecionadas.length.toString()}",
                            context,
                            isOpen: true,
                            hasIcon: false),
                        ListTile(
                          title: Text(
                            (_preguntasSelecionadas.isEmpty ||
                                    indexPreguntas >=
                                        _preguntasSelecionadas.length)
                                ? 'No hay preguntas para esta selección'
                                : _preguntasSelecionadas[indexPreguntas]
                                    .question,
                            //maxLines: 4,
                            style: const TextStyle(
                              color: COR_01,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: COR_02,
                    height: 5,
                    margin: EdgeInsets.only(
                        left: screenW * 0.05, right: screenW * 0.05),
                  ),

                  // Container with the answers
                  Container(
                    padding: EdgeInsets.all(screenW * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildAnswersTiles(_respostasLista),
                    ),
                  ),

                  Divider(
                    thickness: 5,
                    height: screenH / 10,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.white,
                  ),
                  /* Funcoes()
                .logoWidget(fontSize: 20, opacity: 0, letterColor: Colors.grey), */
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Divider(
                    thickness: 5.0,
                    height: 5.0,
                    color: COR_02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        Funcoes().appLang('The CCSE Exam'),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: COR_02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                          color: COR_02,
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(Icons.edit_note)),
                    ),
                  ),
                  const Divider(
                    thickness: 5.0,
                    height: 5.0,
                    color: COR_02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: buildTiles(),
                    ),
                  ),
                ],
              ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: screenH * 0.10,
            color: COR_02,
            width: screenW,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Funcoes().appProgressBar(
                    1.0,
                    ((respostasCorretas) / _preguntasSelecionadas.length),
                    ((respostasErradas) / _preguntasSelecionadas.length),
                    barHeight: 15,
                    color1: COR_02b,
                    color2: COR_02b),
                Text(
                  clockFormat((examPresented) ? counter : 45 * 60),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: (examPresented)
              ? FloatingActionButton(
                  shape: const StadiumBorder(),
                  backgroundColor: (responded) ? COR_02b : Colors.grey,
                  onPressed: () {
                    if (responded) {
                      indexPreguntas++;
                      Funcoes().saveAnsweredQuestionsToLocal();
                      if (indexPreguntas >= _preguntasSelecionadas.length) {
                        indexPreguntas--;
                        //counter = 1;
                        clock.cancel();
                        Navigator.pushReplacementNamed(context, 'examClosing');
                      } else {
                        currentQuestion =
                            _preguntasSelecionadas[indexPreguntas];
                        _respostasLista =
                            _preguntasSelecionadas[indexPreguntas].answers;
                        responded = false;
                        respostaErrada = -1;
                      }
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 30),
                )
              : FloatingActionButton(
                  shape: const StadiumBorder(),
                  backgroundColor: COR_02b,
                  onPressed: () {
                    examPresented = true;
                    counter = 45 * 60;
                    setState(() {});
                  },
                  child: const Icon(Icons.play_circle_fill_rounded,
                      color: Colors.white, size: 30),
                )),
    );
  }

// Build the tiles for the answer options
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
          tileColor: (responded && respostaDada == iRep)
              ? Colors.grey
              : ((iRep % 2 == 0) ? Colors.grey.shade100 : Colors.white),
          title: Text(
            answer['answer'],
            textAlign: TextAlign.left,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 22,
                color:
                    (responded && respostaDada == iRep) ? Colors.white : COR_01,
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
                }
                responded = true;
                respostaDada = iRep;
              }
            });
          }),
          leading: IconButton(
            onPressed: () {
              setState(() {
                setState(() {
                  if (!responded) {
                    responded = true;
                    respostaDada = iRep;
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
              (responded && respostaDada == iRep)
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: COR_01,
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

// Format the timer display
  String clockFormat(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

// Build the tiles for the exam explanation
  List<ListTile> buildTiles() {
    List<ListTile> tiles = [];
    final tncs = DocumentContent().getSessionsbyLanguage(language.toString());

    for (var element in tncs) {
      tiles.add(
        ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          //leading: const Icon(Icons.comment),
          title: Text(
            element['title'].toString(),
            style: const TextStyle(
                fontSize: 17, color: COR_02, fontFamily: 'Verdana'),
          ),
          subtitle: Text(
            element['content'].toString(),
            style: const TextStyle(
                fontSize: 14, color: Colors.grey, fontFamily: 'Verdana'),
          ),
        ),
      );
    }
    return tiles;
  }
}
