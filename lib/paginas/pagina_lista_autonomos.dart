import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class PaginaListaAutonomos extends StatefulWidget {
  const PaginaListaAutonomos({Key? key}) : super(key: key);

  @override
  State<PaginaListaAutonomos> createState() => _PaginaListaAutonomosState();
}

class _PaginaListaAutonomosState extends State<PaginaListaAutonomos> {
  //int _counter = 0;
  List<Autonomo> autonomosListar = <Autonomo>[];

  @override
  void initState() {
    _getDatafromServer();
    super.initState();
  }

  _getDatafromServer() async {
    await Funcoes().buscarAutonomos(
        nomeAtividade: Funcoes.atividadeEscolhida,
        cidadeNome: Funcoes.cidadeEscolhida);
    autonomosListar = Funcoes.autonomosSelecionados;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;
    final atividade = Funcoes.atividadeEscolhida;
    autonomosListar = Funcoes().filtraAutonomos(atividade);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'AutonoJobs',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${Funcoes.cidadeEscolhida} | $atividade',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Verdana', /* fontWeight: FontWeight.bold */
                ),
              ),
            ],
          ),
        ),
        /* shadowColor: Colors.white70.withOpacity(0.0), */
      ),
      endDrawer: AJDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: (autonomosListar.isEmpty)
                ? Container(
                    padding: const EdgeInsets.all(20),
                    height: altura / 4,
                    child: const Center(
                      child: Text(
                        'Não temos ainda Autonomos cadastrados nesta atividade e nesta cidade. Tente em locais próximos.',
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
                : ListView.builder(
                    //padding: const EdgeInsets.all(5),
                    controller: PageController(viewportFraction: 1.0),
                    itemCount: autonomosListar.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        tileColor: (i % 2) == 0
                            ? Colors.grey.shade300
                            : Colors.transparent,
                        onTap: () {
                          Funcoes.autonomoEscolhido = autonomosListar[i];
                          Navigator.pushNamed(context, 'detalheAutonomo');
                        },
                        leading: autonomosListar[i].circledImage(radius: 50),
                        title: Text(
                          autonomosListar[i].nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Verdana",
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              autonomosListar[i].localizacao(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: "Verdana",
                              ),
                            ),
                            Text(
                              autonomosListar[i].telefone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: "Verdana",
                              ),
                            ),
                          ],
                        ),
                      );
                      /*   return GestureDetector(
                    onTap: () {
                      Funcoes.autonomoEscolhido = autonomosListar[i];
                      Navigator.pushNamed(context, 'detalheAutonomo');
                    },
                    child: Container(
                      //color: Colors.amber,
                      height: altura / 4,
                      width: largura * 0.9,
                      padding: EdgeInsets.all(largura * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: COR_02,
                            width: largura / 4,
                            height: largura / 2,
                            child: autonomosListar[i].image(),
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
                                  autonomosListar[i].nome,
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
                                  autonomosListar[i].atividade,
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
                                  autonomosListar[i].descricao,
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
                 */
                    }),
          ),
        ],
      ),
    );
  }
}
