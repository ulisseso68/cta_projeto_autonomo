import 'dart:async';
import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/paginas/drawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';

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
                  Funcoes().titleWithIcon(
                      Funcoes().appLang('Exam Simulation'),
                      "${Funcoes().appLang("Question")}: ${(indexPreguntas + 1).toString()} / ${_preguntasSelecionadas.length.toString()} \n${Funcoes().appLang("CCSE ID")}: ${_preguntasSelecionadas[indexPreguntas].ccse_id}",
                      context,
                      isOpen: true,
                      hasIcon: false),
                  ListTile(
                    title: Text(
                      (_preguntasSelecionadas.isEmpty ||
                              indexPreguntas >= _preguntasSelecionadas.length)
                          ? 'No hay preguntas para esta selección'
                          : _preguntasSelecionadas[indexPreguntas].question,
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
              margin:
                  EdgeInsets.only(left: screenW * 0.05, right: screenW * 0.05),
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
              color: COR_02,
            ),
            /* Funcoes()
                .logoWidget(fontSize: 20, opacity: 0, letterColor: Colors.grey), */
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
                Text(
                  clockFormat(counter),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: (responded)
            ? FloatingActionButton(
                shape: const StadiumBorder(),
                backgroundColor: COR_02,
                onPressed: () {
                  indexPreguntas++;
                  Funcoes().saveAnsweredQuestionsToLocal();
                  if (indexPreguntas >= _preguntasSelecionadas.length) {
                    indexPreguntas--;
                    //counter = 1;
                    clock.cancel();
                    Navigator.pushReplacementNamed(context, 'examClosing');
                  } else {
                    currentQuestion = _preguntasSelecionadas[indexPreguntas];
                    _respostasLista =
                        _preguntasSelecionadas[indexPreguntas].answers;
                    responded = false;
                    respostaErrada = -1;
                  }
                  setState(() {});
                },
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 30),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ),
    );
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
          tileColor: (responded && respostaDada == iRep)
              ? Colors.grey
              : ((iRep % 2 == 0) ? Colors.grey.shade300 : Colors.white),
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

  String clockFormat(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
