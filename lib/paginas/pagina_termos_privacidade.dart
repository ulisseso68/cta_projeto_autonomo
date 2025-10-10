import 'package:ccse_mob/utilidades/dados.dart';
import 'package:flutter/material.dart';
import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:ccse_mob/utilidades/policy.dart';

class PaginaTermosUsoPrivacidade extends StatefulWidget {
  const PaginaTermosUsoPrivacidade({super.key});
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
                    Funcoes().appLang('Terms of Use'),
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
    final tncs = DocumentContent().getSessionsbyLanguage(language.toString());

    for (var element in tncs) {
      tiles.add(
        ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          //leading: const Icon(Icons.comment),
          title: Text(
            element['title'].toString(),
            style: const TextStyle(
                fontSize: 14, color: COR_02, fontFamily: 'Verdana'),
          ),
          subtitle: Text(
            element['content'].toString(),
            style: const TextStyle(
                fontSize: 14, color: Colors.grey, fontFamily: 'Verdana'),
          ),
        ),
      );
    }
    return tiles;
  }
}
