import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//ignore: camel_case_types

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  // ignore: prefer_typing_uninitialized_variables

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  bool expanded = false;
  //final String texto = 'Phelipe VI da Espanha';
  //final String fotografia = 'felipevi.png';

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
                child: SizedBox(
                    height: altura / 3,
                    width: largura,
                    child: Image(
                      image: preguntas[indexPreguntas].imagem(),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ))),
            const Divider(thickness: 5.0, height: 5.0, color: COR_02),
            ListTile(
              //  leading: Icon(Icons.info, size: 30),
              title: Text(
                preguntas[indexPreguntas].description,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 15),
              ),
              textColor: Colors.black54,
            ),
            RatingBar(
                initialRating: 3,
                unratedColor: COR_02,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: COR_02),
                    half: const Icon(
                      Icons.star_half,
                      color: COR_02,
                    ),
                    empty: const Icon(
                      Icons.star_outline,
                      color: COR_02,
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
