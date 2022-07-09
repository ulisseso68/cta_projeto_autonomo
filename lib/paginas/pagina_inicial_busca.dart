import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_detalhe_autonomo.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';

import 'pagina_lista_autonomos.dart';
import 'package:flutter/material.dart';

class PaginaInicialBusca extends StatefulWidget {
  const PaginaInicialBusca({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PaginaInicialBusca> createState() => _PaginaInicialBuscaState();
}

class _PaginaInicialBuscaState extends State<PaginaInicialBusca> {
  // ignore: prefer_final_fields
  var _atividadesSelecionadas = <String>[];

  @override
  initState() {
    _atividadesSelecionadas = Funcoes().seleciona('');
    //print(_atividadesSelecionadas);
    super.initState();
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
        title: Text(
          widget.title,
          style: const TextStyle(
              fontSize: 30, fontFamily: 'Verdana', fontWeight: FontWeight.bold),
        ),
        shadowColor: Colors.white70.withOpacity(0.0),
      ),
      body: Column(
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
            padding: const EdgeInsets.only(top: 5, left: 10),
            child: const Text(
              "Recomendados",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            padding: const EdgeInsets.all(10),
            height: altura / 4,
            width: largura,
            //color: Colors.amber,
            child: PageView.builder(
                controller: PageController(viewportFraction: 1.0),
                itemCount: autonomosDados.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaginaDetalheAutonomo(
                                    autonomo: autonomosDados[i])));
                      },
                      child: SizedBox(
                        height: altura / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image(
                              image: AssetImage(autonomosDados[i]
                                      ['fotoProfissional']
                                  .toString()),
                              width: largura / 4,
                              height: largura / 2,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 5.0),
                              height: altura / 4,
                              width: 0.65 * largura,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    autonomosDados[i]['nome'].toString(),
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
                                    autonomosDados[i]['atividade'].toString(),
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
                                    autonomosDados[i]['descricao'].toString(),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaginaListaAutonomos(atividade: texto)));
              },
              style: const TextStyle(color: Color(0xFF000000), fontSize: 30),
              cursorColor: Colors.red,
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'busca',
                hintStyle: TextStyle(
                    color: Color(0xFF9b9b9b),
                    fontSize: 30,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          //Lista de atividas
          SizedBox(
              height: altura / 4,
              width: largura * 0.9,
              child: ListView.builder(
                  key: const Key('Tags List'),
                  itemCount: min(_atividadesSelecionadas.length, 8),
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaginaListaAutonomos(
                                    atividade: _atividadesSelecionadas[i])));
                      },
                      child: Text(
                        _atividadesSelecionadas[i],
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontFamily: 'Verdana'),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
