import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:flutter/material.dart';

class PaginaTermosUsoPrivacidade extends StatefulWidget {
  const PaginaTermosUsoPrivacidade({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  @override
  State<PaginaTermosUsoPrivacidade> createState() =>
      _PaginaTermosUsoPrivacidadeState();
}

class _PaginaTermosUsoPrivacidadeState
    extends State<PaginaTermosUsoPrivacidade> {
  //int _counter = 0;
  //final Autonomo autonomo = Funcoes.autonomoEscolhido;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      endDrawer: AJDrawer(),
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
                        image: AssetImage('img/tncs.png'),
                        fit: BoxFit.cover,
                      )),
                ),
                Positioned(
                    top: 40,
                    left: 10,
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: 'voltaTnCs',
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
      const ListTile(
        title: Text(
          'Termos de Uso e Privacidade',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        textColor: Colors.black54,
      ),
    );

    for (var element in tncs) {
      tiles.add(
        ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          leading: const Icon(Icons.comment),
          title: Text(
            element['clausula'].toString(),
            style: const TextStyle(
                fontSize: 14, color: Colors.black54, fontFamily: 'Verdana'),
          ),
        ),
      );
    }
    return tiles;
  }
}
