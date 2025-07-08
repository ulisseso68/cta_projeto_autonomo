import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:flutter/material.dart';

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
      endDrawer: const AJDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    expanded = !expanded;
                    setState(() {});
                  },
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: expanded ? altura / 2 : altura / 4,
                      width: largura,
                      child: const Image(
                        image: AssetImage('img/timeAutonoJobs.jpeg'),
                        fit: BoxFit.cover,
                      )),
                ),
                Positioned(
                    top: 40,
                    left: 10,
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: 'voltaCreditos',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    )),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Image(
                    image: const AssetImage('img/appstore.png'),
                    fit: BoxFit.cover,
                    width: largura / 8,
                    height: largura / 8,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 5.0,
              height: 5.0,
              color: Colors.green,
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
          projetoAJ['descricao'].toString(),
          maxLines: 10,
          style: const TextStyle(fontSize: 15),
        ),
        textColor: Colors.black54,
      ),
    );
    tiles.add(
      ListTile(
        title: Text(
          projetoAJ['msg3'].toString(),
          maxLines: 10,
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
