//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
//import 'dart:html';

//import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
//import 'package:cta_projeto_autonomo/paginas/reusosDrawer.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//import 'package:flutter/services.dart';
//ignore: camel_case_types

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  final Autonomo autonomo = Funcoes.autonomoEscolhido;
  bool expanded = false;
  final String texto = 'Phelipe VI da Espanha';
  final String fotografia = 'felipevi.png';

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      /* appBar: AppBar(
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
      endDrawer: AJDrawer(), */
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
                child: Container(
                    height: altura / 3,
                    width: largura,
                    child: const Image(
                      image: AssetImage('img/felipevi.png'),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ))),
            const Divider(thickness: 5.0, height: 5.0, color: COR_02),
            const ListTile(
              //  leading: Icon(Icons.info, size: 30),
              title: Text(
                '\nFelipe VI de Borbón y Grecia es el rey actual de España, hijo de Juan Carlos I y Sofía de Grecia. Nació en Madrid en 1968 y accedió al trono en 2014 tras la abdicación de su padre. Es el actual jefe de estado y comandante supremo de las Fuerzas Armadas españolas. ',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              textColor: Colors.black54,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: COR_02,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
