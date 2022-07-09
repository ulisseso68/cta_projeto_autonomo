import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
//import 'package:cta_projeto_autonomo/utilidades/dados.dart';

import 'pagina_detalhe_autonomo.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class PaginaListaAutonomos extends StatefulWidget {
  const PaginaListaAutonomos({Key? key, required this.atividade})
      : super(key: key);
  final String atividade;

  @override
  State<PaginaListaAutonomos> createState() => _PaginaListaAutonomosState();
}

class _PaginaListaAutonomosState extends State<PaginaListaAutonomos> {
  //int _counter = 0;

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;
    var autonomosListar = Funcoes().filtraAutonomos(widget.atividade);
    print(widget.atividade);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AutonoJobs',
          style: TextStyle(
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
            child: Text(
              "Atividade: ${widget.atividade}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(5),
                controller: PageController(viewportFraction: 1.0),
                itemCount: autonomosListar.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaginaDetalheAutonomo(
                                  autonomo: autonomosListar[i])));
                    },
                    child: Container(
                      //color: Colors.amber,
                      height: altura / 4,
                      width: largura * 0.9,
                      padding: EdgeInsets.all(largura * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage(autonomosListar[i]
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
                                  autonomosListar[i]['nome'].toString(),
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
                                  autonomosListar[i]['atividade'],
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
                                  autonomosListar[i]['descricao'].toString(),
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
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
