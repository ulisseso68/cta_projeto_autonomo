import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/models/answeredQuestion_model.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class QuestionsPage1 extends StatefulWidget {
  const QuestionsPage1({Key? key}) : super(key: key);

  @override
  State<QuestionsPage1> createState() => _QuestionsPage1();
}

class _QuestionsPage1 extends State<QuestionsPage1> {
  // ignore: prefer_final_fields
  List _preguntasSelecionadas = [];
  List _respostasLista = [];
  bool responded = false;
  int respostaErrada = -1;
  int printed = 0;
  int answeredCorrect = 0;

  @override
  initState() {
    indexPreguntas = 0;
    respostasCorretas = 0;
    respostasErradas = 0;
    temaPreguntas = Funcoes.categorySelected.toUpperCase();
    _getData();
    super.initState();
  }

  _getData() async {
    _preguntasSelecionadas =
        Funcoes().selectQuestions(Funcoes.categorySelected.toUpperCase());

    if (numberOfQuestions > 0) {
      _preguntasSelecionadas =
          _preguntasSelecionadas.take(numberOfQuestions).toList();
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
        backgroundColor: COR_02,
        title: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                appname,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.bold),
              ),
              (temaPreguntas != '')
                  ? Text(
                      Funcoes.categorySelected,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: 'Verdana', /* fontWeight: FontWeight.bold */
                      ),
                    )
                  : Container(),
            ],
          ),
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
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Container(
                    width: largura,
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Funcoes().appLang("Question")}: ${(indexPreguntas + 1).toString()} / ${_preguntasSelecionadas.length.toString()}",
                          style: const TextStyle(
                            color: COR_02,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${Funcoes().appLang("Printed")}: ${currentQuestion.getAnsQue.printed} | ${Funcoes().appLang("Correct")}: ${currentQuestion.getAnsQue.correct}",
                          style: const TextStyle(
                            color: COR_02,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (_preguntasSelecionadas.isEmpty)
                        ? 'No hay preguntas para esta selección'
                        : _preguntasSelecionadas[indexPreguntas].question,
                    maxLines: 4,
                    style: const TextStyle(
                      color: COR_01,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: COR_02,
              height: 5,
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 10),
            ),

            // Container with the answers
            (indexPreguntas.isNaN)
                ? SizedBox(
                    height: altura / 4,
                    child: const Center(
                      child: Text(
                        'No hay preguntas para esta selección',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: COR_01,
                          fontSize: 20,
                          fontFamily: "Verdana",
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: altura * 0.40,
                    width: largura - 20,
                    child: ListView.builder(
                        itemCount: _respostasLista.length,
                        itemBuilder: ((context, indexAnswers) {
                          return ListTile(
                            //VisualDensity.comfortable,
                            //dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: (responded)
                                ? (_respostasLista[indexAnswers]['Correct'])
                                    ? Colors.green.shade300
                                    : Colors.grey.shade50
                                : (indexAnswers % 2 == 0)
                                    ? Colors.grey.shade200
                                    : Colors.white,
                            title: Text(
                              _respostasLista[indexAnswers]['answer'],
                              textAlign: TextAlign.left,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: (respostaErrada == indexAnswers)
                                      ? Colors.red
                                      : COR_01,
                                  fontFamily: 'Verdana'),
                            ),
                            onTap: () => setState(() {
                              setState(() {
                                if (_respostasLista[indexAnswers]['Correct']) {
                                  respostasCorretas++;
                                  Funcoes()
                                      .findAnsweredQuestion(
                                          _preguntasSelecionadas[indexPreguntas]
                                              .id)
                                      .registerCorrect();
                                } else {
                                  respostasErradas++;
                                  Funcoes()
                                      .findAnsweredQuestion(
                                          _preguntasSelecionadas[indexPreguntas]
                                              .id)
                                      .registerIncorrect();
                                  respostaErrada = indexAnswers;
                                }
                                responded = true;
                              });
                            }),
                            /* trailing: (_respostasLista[index]['Correct'] &
                                    responded &
                                    _preguntasSelecionadas[indexPreguntas]
                                        .hasDetails)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {});
                                      Navigator.pushNamed(
                                          context, 'learningPage',
                                          arguments: _respostasLista[index]);
                                    },
                                    icon: const Icon(
                                      Icons.info_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : const SizedBox(height: 0, width: 0), */
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  setState(() {
                                    if (!responded) {
                                      responded = true;
                                      if (_respostasLista[indexAnswers]
                                          ["Correct"]) {
                                        respostasCorretas++;
                                        // Register the answer as correct
                                        currentQuestion.getAnsQue
                                            .registerCorrect();
                                      } else {
                                        respostasErradas++;
                                        // Register the answer as incorrect
                                        currentQuestion.getAnsQue
                                            .registerIncorrect();
                                        respostaErrada = indexAnswers;
                                      }
                                    }
                                  });
                                });
                              },
                              icon: Icon(
                                (responded &
                                        _respostasLista[indexAnswers]
                                            ['Correct'])
                                    ? Icons.check_circle
                                    : (respostaErrada == indexAnswers)
                                        ? Icons.cancel
                                        : Icons.radio_button_unchecked,
                                color: (respostaErrada == indexAnswers)
                                    ? Colors.red
                                    : COR_01,
                                size: 20,
                              ),
                            ),
                          );
                        })),
                  ),
            /* Container(
                    color: Colors.black12,
                    padding: const EdgeInsets.all(0),
                    height: altura / 4,
                    width: largura,
                    //color: Colors.amber,
                    child: PageView.builder(
                        controller: PageController(viewportFraction: 1.0),
                        itemCount: min(_preguntasSelecionadas.length, 3),
                        itemBuilder: (_, i) {
                          return GestureDetector(
                              onTap: () {
                                Funcoes.autonomoEscolhido =
                                    _preguntasSelecionadas[i];
                                Navigator.pushNamed(context, 'detalheAutonomo');
                              },
                              child: SizedBox(
                                height: altura / 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /* Container(
                                      color: COR_02,
                                      width: largura * 0.4,
                                      height: altura / 3,
                                      child: _preguntasSelecionadas[i].image(),
                                    ), */
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0, top: 5.0),
                                      height: altura / 4,
                                      width: largura,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _preguntasSelecionadas[i]["pergunta"],
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: redEspana,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Verdana",
                                            ),
                                          ),
                                          /* Text(
                                            _preguntasSelecionadas[i].atividade,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                              fontFamily: "Verdana",
                                            ),
                                          ), */
                                          const Divider(
                                            color: Colors.black54,
                                          ),
                                          /* Text(
                                            _preguntasSelecionadas[i]
                                                .descricaoLimpa(),
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Verdana",
                                              color: Colors.black54,
                                            ),
                                          ), */
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }),
                  ), */
            /* const Divider(
              height: 5,
              color: COR_02,
            ), */
          ],
        ),
      ),
      persistentFooterButtons: [
        /* Container(
          color: COR_02,
          height: 5,
        ), */
        Container(
          width: largura,

          ///color: Colors.yellow.shade100,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Respostas: $respostasCorretas | Erros: $respostasErradas",
                style: const TextStyle(
                  color: COR_02,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: (responded)
            ? FloatingActionButton(
                backgroundColor: COR_02,
                onPressed: () {
                  setState(() {
                    indexPreguntas++;
                    Funcoes().saveAnsweredQuestionsToLocal();
                    if (indexPreguntas >= _preguntasSelecionadas.length) {
                      Navigator.pushNamed(context, 'questionsClosing',
                          arguments: {
                            'respostasCorretas': respostasCorretas,
                            'respostasErradas': respostasErradas,
                            'tema': temaPreguntas,
                          });
                    }
                    currentQuestion = _preguntasSelecionadas[indexPreguntas];
                    _respostasLista =
                        _preguntasSelecionadas[indexPreguntas].answers;
                    responded = false;
                    respostaErrada = -1;
                  });
                },
                child: const Icon(Icons.arrow_forward),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
      ),
    );
  }
}
