//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
//import 'dart:html';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//import 'package:flutter/services.dart';

class PaginaDetalheAutonomo extends StatefulWidget {
  const PaginaDetalheAutonomo({Key? key, required this.autonomo})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final autonomo;

  @override
  State<PaginaDetalheAutonomo> createState() => _PaginaDetalheAutonomoState();
}

class _PaginaDetalheAutonomoState extends State<PaginaDetalheAutonomo> {
  //int _counter = 0;

  @override
  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AutonoJobs',
          style: TextStyle(
              fontSize: 30, fontFamily: 'Verdana', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: altura / 4,
                width: largura,
                child: Image(
                  image: AssetImage(widget.autonomo['fotoProfissional']),
                  fit: BoxFit.cover,
                )),
            const Divider(
              thickness: 5.0,
              height: 5.0,
              color: Colors.green,
            ),
            ListTile(
              leading: const Icon(Icons.perm_identity, size: 40),
              title: Text(
                widget.autonomo['nome'],
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
              textColor: Colors.green,
            ),
            RatingBar(
                initialRating: widget.autonomo['rating'] is int
                    ? (widget.autonomo['rating'] as int).toDouble()
                    : widget.autonomo['rating'],
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
              title: Text(widget.autonomo['descricao']),
            ),
            ListTile(
              leading: const Icon(
                Icons.money,
                size: 40,
              ),
              title: Text("BRL ${widget.autonomo['precohora']}"),
            ),
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Funcoes().whatsapp(widget.autonomo['telefone']);
                },
                child: const Icon(
                  Icons.whatsapp_sharp,
                  size: 40,
                  color: Colors.green,
                ),
              ),
              title: Text(widget.autonomo['telefone']),
            )
          ],
        ),
      ),
    );
  }
}
