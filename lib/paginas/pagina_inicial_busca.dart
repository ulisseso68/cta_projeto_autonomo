import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class PaginaInicialBusca extends StatefulWidget {
  const PaginaInicialBusca({Key? key}) : super(key: key);

  @override
  State<PaginaInicialBusca> createState() => _PaginaInicialBuscaState();
}

class _PaginaInicialBuscaState extends State<PaginaInicialBusca> {
  // ignore: prefer_final_fields
  List _preguntasSelecionadas = [];
  //List<Autonomo> _preguntasSelecionadas = <Autonomo>[];

  @override
  initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    await Funcoes().iniciarPreguntas();
    _preguntasSelecionadas = Funcoes.preguntas;
    //_preguntasSelecionadas.sort(((a, b) => a['nome'].compareTo(b['nome'])));
    //await Funcoes().buscarAutonomos(cidadeNome: Funcoes.cidadeEscolhida);
    /* _preguntasSelecionadas = Funcoes.autonomos
        .where((element) => (element.cidade == Funcoes.cidadeEscolhida &&
            element.recomendado()))
        .toList(); */
    indexPreguntas = 0;
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
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                appname,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.bold),
              ),
              (temaPreguntas != '')
                  ? Text(
                      temaPreguntas,
                      style: const TextStyle(
                        fontSize: 12,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.white,
            height: altura * 0.02,
          ),
          // Counter with number of Answers Correct
          Container(
            width: largura,
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
            child: const Text(
              "(n) Preguntas correctas",
              style: TextStyle(
                color: redEspana,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Container with the divider
          Divider(
            color: Colors.white,
            height: altura * 0.02,
          ),
          // Container with the question
          Container(
            width: largura,
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Text(
              (_preguntasSelecionadas.isEmpty)
                  ? 'No hay preguntas para esta selección'
                  : _preguntasSelecionadas[indexPreguntas]['pergunta'],
              maxLines: 3,
              style: const TextStyle(
                color: COR_01,
                fontSize: 24,
              ),
            ),
          ),
          // Container with the divider
          const Divider(
            color: Colors.white,
            height: 1,
          ),
          // Container with the answers
          (_preguntasSelecionadas[indexPreguntas]['respostas'].toList().isEmpty)
              ? SizedBox(
                  height: altura / 4,
                  child: const Center(
                    child: Text(
                      'No hay preguntas para esta selección',
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: COR_01,
                        fontSize: 20,
                        fontFamily: "Verdana",
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  height: altura * 0.35,
                  width: largura * 0.9,
                  child: ListView.builder(
                      itemCount: _preguntasSelecionadas[indexPreguntas]
                              ['respostas']
                          .toList()
                          .length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          title: Text(
                            _preguntasSelecionadas[indexPreguntas]['respostas']
                                .toList()[index]['resposta'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 22,
                                color: COR_01,
                                fontFamily: 'Verdana'),
                          ),
                          leading: IconButton(
                            onPressed: () {
                              /* if (_preguntasSelecionadas[index]['id'] != 0) {
                          Funcoes.atividadeEscolhida =
                              _preguntasSelecionadas[index]['nome'];
                          Navigator.pushNamed(context, 'listaAutonomos');
                        } */
                            },
                            icon: const Icon(
                              Icons.radio_button_unchecked,
                              color: COR_01,
                              /* (_preguntasSelecionadas[index]['id'] != 0)
                            ? COR_04
                            : COR_LightGrey, */
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
          const Divider(
            height: 5,
            color: Colors.white,
          ), //area de busca

          //Campo de Busca
          /* SizedBox(
            height: altura * 0.1,
            width: largura * 0.9,
            child: TextField(
              onChanged: (texto) {
                setState(() {
                  _preguntasSelecionadas = Funcoes().seleciona(texto);
                });
              },
              onSubmitted: (texto) {
                Funcoes.atividadeEscolhida = texto;
                Navigator.pushNamed(context, 'listaAutonomos');
              },
              style: const TextStyle(color: Color(0xFF000000), fontSize: 30),
              cursorColor: Colors.red,
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'busca da atividade',
                hintStyle: TextStyle(
                    color: Color(0xFF9b9b9b),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ), */
          //Lista de preguntas
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: COR_01,
          onPressed: () {
            setState(() {
              indexPreguntas++;
              if (indexPreguntas >= _preguntasSelecionadas.length) {
                indexPreguntas = 0;
              }
            });
          },
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
