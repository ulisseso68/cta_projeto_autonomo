import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
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
  int respostasCorretas = 0;
  int respostasErradas = 0;
  int respostaErrada = -1;

  @override
  initState() {
    indexPreguntas = 1;
    _getData();
    super.initState();
  }

  _getData() async {
    await Funcoes().iniciarPreguntas();
    _preguntasSelecionadas = preguntas;
    //_preguntasSelecionadas.sort(((a, b) => a['nome'].compareTo(b['nome'])));
    //await Funcoes().buscarAutonomos(cidadeNome: Funcoes.cidadeEscolhida);
    /* _preguntasSelecionadas = Funcoes.autonomos
        .where((element) => (element.cidade == Funcoes.cidadeEscolhida &&
            element.recomendado()))
        .toList(); */
    //print(indexPreguntas);
    currentQuestion = _preguntasSelecionadas[indexPreguntas];
    _respostasLista = _preguntasSelecionadas[indexPreguntas].answers;
    //print(_preguntasSelecionadas[indexPreguntas]['pergunta']);
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
          padding: const EdgeInsets.all(8.0),
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
                      temaPreguntas,
                      style: const TextStyle(
                        fontSize: 20,
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
                    child: Text(
                      "Pregunta: ${(indexPreguntas + 1).toString()} / ${_preguntasSelecionadas.length.toString()}",
                      style: const TextStyle(
                        color: COR_02,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    (_preguntasSelecionadas.isEmpty)
                        ? 'No hay preguntas para esta selección'
                        : _preguntasSelecionadas[indexPreguntas].question,
                    maxLines: 3,
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
                        itemBuilder: ((context, index) {
                          return ListTile(
                            //VisualDensity.comfortable,
                            //dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: (responded)
                                ? (_respostasLista[index]['correct'])
                                    ? Colors.green.shade300
                                    : Colors.grey.shade50
                                : (index % 2 == 0)
                                    ? Colors.grey.shade200
                                    : Colors.white,
                            title: Text(
                              _respostasLista[index]['answer'],
                              textAlign: TextAlign.left,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: (respostaErrada == index)
                                      ? Colors.red
                                      : COR_01,
                                  fontFamily: 'Verdana'),
                            ),
                            onTap: () => setState(() {
                              setState(() {
                                if (_respostasLista[index]['correct']) {
                                  respostasCorretas++;
                                } else {
                                  respostasErradas++;
                                  respostaErrada = index;
                                }
                                responded = true;
                              });
                            }),
                            /* trailing: (_respostasLista[index]['correct'] &
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
                                      if (_respostasLista[index]['correct']) {
                                        respostasCorretas++;
                                      } else {
                                        respostasErradas++;
                                        respostaErrada = index;
                                      }
                                    }
                                  });
                                });
                              },
                              icon: Icon(
                                (responded & _respostasLista[index]['correct'])
                                    ? Icons.check_circle
                                    : (respostaErrada == index)
                                        ? Icons.cancel
                                        : Icons.radio_button_unchecked,
                                color: (respostaErrada == index)
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
          child: Text(
            "Respostas: $respostasCorretas | Erros: $respostasErradas",
            style: const TextStyle(
              color: COR_02,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
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
                    if (indexPreguntas >= _preguntasSelecionadas.length) {
                      indexPreguntas = 0;
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
