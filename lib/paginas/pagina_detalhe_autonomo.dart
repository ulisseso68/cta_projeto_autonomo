//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
//import 'dart:html';

import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//import 'package:flutter/services.dart';

class PaginaDetalheAutonomo extends StatefulWidget {
  const PaginaDetalheAutonomo({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  @override
  State<PaginaDetalheAutonomo> createState() => _PaginaDetalheAutonomoState();
}

class _PaginaDetalheAutonomoState extends State<PaginaDetalheAutonomo> {
  //int _counter = 0;
  final Autonomo autonomo = Funcoes.autonomoEscolhido;
  bool expanded = false;

  @override
  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

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
                '${Funcoes.cidadeEscolhida} | ${Funcoes.atividadeEscolhida}',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                expanded = !expanded;
                setState(() {});
              },
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: expanded ? altura / 2 : altura / 4,
                  width: largura,
                  child: autonomo.image()),
            ),
            const Divider(
              thickness: 5.0,
              height: 5.0,
              color: Colors.green,
            ),
            ListTile(
              leading: const Icon(Icons.perm_identity, size: 40),
              title: Text(
                autonomo.nome,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
              textColor: Colors.green,
            ),
            RatingBar(
                initialRating: 3,
                unratedColor: Colors.green,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Colors.green),
                    half: const Icon(
                      Icons.star_half,
                      color: Colors.green,
                    ),
                    empty: const Icon(
                      Icons.star_outline,
                      color: Colors.green,
                    )),
                onRatingUpdate: (value) {
                  setState(() {});
                }),
            ListTile(
              leading: const Icon(
                Icons.description,
                size: 40,
              ),
              title: Text(
                autonomo.descricao,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.place,
                size: 40,
              ),
              title: Text(
                "${autonomo.uf} ${autonomo.cidade} ${autonomo.cep}",
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Funcoes().whatsapp(autonomo.telefone);
                },
                child: const Icon(
                  Icons.whatsapp_sharp,
                  size: 40,
                  color: COR_04,
                ),
              ),
              title: Text(
                autonomo.telefone,
                style: const TextStyle(color: COR_04),
              ),
            )
          ],
        ),
      ),
    );
  }
}
