import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class PaginaInicialBusca extends StatefulWidget {
  const PaginaInicialBusca({Key? key}) : super(key: key);

  @override
  State<PaginaInicialBusca> createState() => _PaginaInicialBuscaState();
}

class _PaginaInicialBuscaState extends State<PaginaInicialBusca> {
  // ignore: prefer_final_fields
  List _atividadesSelecionadas = [];
  List<Autonomo> topAutonomos = <Autonomo>[];

  @override
  initState() {
    _getDatafromServer();
    super.initState();
  }

  _getDatafromServer() async {
    await Funcoes().iniciarAtividades();
    _atividadesSelecionadas = Funcoes.atividades;
    await Funcoes().buscarAutonomos(cidadeNome: Funcoes.cidadeEscolhida);
    topAutonomos = Funcoes.autonomos
        .where((element) => element.cidade == Funcoes.cidadeEscolhida)
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    // ignore: prefer_typing_uninitialized_variables
    var textController;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'AutonoJobs',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Funcoes.cidadeEscolhida,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Verdana', /* fontWeight: FontWeight.bold */
                ),
              ),
            ],
          ),
        ),
        shadowColor: Colors.white70.withOpacity(0.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            //Carrossel com selecionados
            Container(
              color: Colors.green,
              height: 30,
              width: largura,
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
              child: const Text(
                "Recomendados",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            (topAutonomos.isEmpty)
                ? SizedBox(
                    height: altura / 4,
                    child: const Center(
                      child: Text(
                        'Não temos ainda Autonomos recomendados nesta cidade',
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontFamily: "Verdana",
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.black12,
                    padding: const EdgeInsets.all(0),
                    height: altura / 4,
                    width: largura,
                    //color: Colors.amber,
                    child: PageView.builder(
                        controller: PageController(viewportFraction: 1.0),
                        itemCount: min(topAutonomos.length, 3),
                        itemBuilder: (_, i) {
                          return GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: altura / 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: COR_02,
                                      width: largura / 3,
                                      height: altura / 3,
                                      child: topAutonomos[i].image(),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0, top: 5.0),
                                      height: altura / 4,
                                      width: 0.65 * largura,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            topAutonomos[i].nome,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.deepPurple,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: "Verdana",
                                            ),
                                          ),
                                          Text(
                                            topAutonomos[i].atividade,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Verdana",
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.black,
                                          ),
                                          Text(
                                            topAutonomos[i].descricao,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Verdana",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }),
                  ),
            Container(
              width: largura,
              height: 5,
              color: Colors.green,
            ), //area de busca
            //Campo de Busca

            SizedBox(
              height: 70,
              width: largura * 0.9,
              child: TextField(
                onChanged: (texto) {
                  setState(() {
                    _atividadesSelecionadas = Funcoes().seleciona(texto);
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
            ),
            //Lista de atividades
            SizedBox(
              height: altura,
              width: largura * 0.9,
              child: ListView.builder(
                  itemCount: _atividadesSelecionadas.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      tileColor: (index % 2 == 0)
                          ? const Color.fromARGB(255, 227, 223, 223)
                          : Colors.transparent,
                      title: Text(
                        _atividadesSelecionadas[index]['nome'].toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 20, color: COR_04, fontFamily: 'Verdana'),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (_atividadesSelecionadas[index]['id'] != 0) {
                            Funcoes.atividadeEscolhida =
                                _atividadesSelecionadas[index]['nome'];
                            Navigator.pushNamed(context, 'listaAutonomos');
                          }
                        },
                        icon: Icon(
                          Icons.open_in_new,
                          color: (_atividadesSelecionadas[index]['id'] != 0)
                              ? COR_04
                              : COR_LightGrey,
                          size: 30,
                        ),
                      ),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
