import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/paginas/drawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

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

  @override
  initState() {
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
                  Funcoes().titleWithIcon(
                      "${Funcoes().appLang("Question")}: ${(indexPreguntas + 1).toString()} / ${_preguntasSelecionadas.length.toString()}",
                      "${Funcoes().appLang("CCSE id")}: ${_preguntasSelecionadas[indexPreguntas].ccse_id}\n${Funcoes().appLang("Printed")}: ${currentQuestion.getAnsQue.printed} \n${Funcoes().appLang("Correctly")}: ${currentQuestion.getAnsQue.correct}",
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
                    trailing:
                        (_preguntasSelecionadas[indexPreguntas].hasDetails)
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedContainer(
                                    onEnd: () {
                                      setState(() {
                                        beat = !beat;
                                      });
                                    },
                                    duration: const Duration(milliseconds: 300),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: COR_02.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  IconButton(
                                    onHover: (value) {
                                      setState(() {
                                        beat = value;
                                      });
                                    },
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.pushNamed(
                                        context,
                                        'learningPage',
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.fact_check_rounded,
                                      color: COR_02,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )
                            : null,
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

            Container(
              padding: EdgeInsets.all(screenW * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildAnswersTiles(_respostasLista),
              ),
            ),
            // Container with the answers
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Funcoes().appProgressBar(
                    1.0,
                    ((respostasCorretas) / _preguntasSelecionadas.length),
                    ((respostasErradas) / _preguntasSelecionadas.length),
                    barHeight: 25),
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
                      responded = false;
                      respostaErrada = -1;
                    }
                  });
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
          tileColor: (responded)
              ? (answer['Correct'])
                  ? Colors.green.shade300
                  : Colors.grey.shade50
              : ((iRep % 2 == 0) ? Colors.grey.shade300 : Colors.white),
          title: Text(
            answer['answer'],
            textAlign: TextAlign.left,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 22,
                color: (respostaErrada == iRep) ? Colors.red : COR_01,
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
                  print("Resposta errada: $respostaErrada");
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
