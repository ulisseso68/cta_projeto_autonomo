import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:ccse_mob/funcoes/funcoes.dart';

class PaginaCreditoProjeto extends StatefulWidget {
  const PaginaCreditoProjeto({super.key});
  // ignore: prefer_typing_uninitialized_variables
  @override
  State<PaginaCreditoProjeto> createState() => _PaginaCreditoProjetoState();
}

class _PaginaCreditoProjetoState extends State<PaginaCreditoProjeto> {
  //int _counter = 0;
  //final Autonomo autonomo = Funcoes.autonomoEscolhido;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 0.08 * screenH,
        backgroundColor: redEspana,
        title: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Funcoes().logoWidget(
                    opacity: 0,
                  ),
                  Text(
                    Funcoes().appLang('Credits and Acknowledgments'),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'Verdana', /* fontWeight: FontWeight.bold */
                    ),
                  ),
                ],
              ),
              Image(image: AssetImage('img/CCSEf.png'), width: 70, height: 70)
            ],
          ),
        ),
        //shadowColor: Colors.white70.withOpacity(0.0),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              child: Column(
                children: buildTiles(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ListTile> buildTiles() {
    List<ListTile> tiles = [];
    tiles.add(
      ListTile(
        title: Text(
          Funcoes().appLang('Cred_Opening_message'),
          style: const TextStyle(fontSize: 15),
        ),
        textColor: Colors.black54,
      ),
    );
    tiles.add(
      ListTile(
        title: Text(
          Funcoes().appLang('List of partners'),
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ),
    );
    for (var element in projetoParticipates) {
      tiles.add(ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: const Icon(Icons.badge),
        title: Text(element['nome'].toString()),
        subtitle: Text(element['cargo'].toString()),
      ));
    }
    return tiles;
  }
}
