//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
//import 'dart:html';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              height: altura / 4,
              width: largura,
              child: Image(
                image: AssetImage(widget.autonomo['fotoProfissional']),
                fit: BoxFit.cover,
              )),
          ListTile(
            leading: const Icon(Icons.perm_identity, size: 40),
            title: Text(
              widget.autonomo['nome'],
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
            textColor: Colors.green,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              size: 40,
            ),
            title: Text(widget.autonomo['descricao']),
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
    );
  }
}
