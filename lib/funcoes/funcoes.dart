//

import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class Funcoes {
  static List atividadesSelecionadas = [];
  static List<Autonomo> autonomosSelecionados = <Autonomo>[];
  static List cidadesSelecionadas = [];
  static List preguntas = [];
  static List cidades = [];
  static List<Autonomo> autonomos = <Autonomo>[];
  static String cidadeEscolhida = '';
  static String atividadeEscolhida = '';
  static Autonomo autonomoEscolhido = Autonomo();
  static double screenHeight = 800;
  static double screenWidth = 300;

  calcular() {
    //print(autonomos.length);
  }

  iniciarPreguntas() async {
    //atividades = await CallApi().getPublicData('atividades');
    preguntas = preguntasConfig.toList();
  }

  iniciarCidades() async {
    //cidades = await CallApi().getPublicData('cidades');
    cidades = cidadesConfig.toList();
    cidadesSelecionadas.addAll(cidades);
  }

  buscarAutonomos({String cidadeNome = '', String nomeAtividade = ''}) async {
    Iterable res = await CallApi().getPublicData(
        'autonomos?cidade__nome=$cidadeNome&nome_atividade=$nomeAtividade');

    autonomos = res.map((e) => Autonomo.fromJson(e)).toList();
    autonomosSelecionados.addAll(autonomos);
  }

  adicionarAutonomos(List<Autonomo> novos) {
    autonomos.addAll(novos);
  }

  seleciona(String digitado) {
    atividadesSelecionadas.clear();
    for (var ativ in atividades) {
      if (ativ['nome']
          .toString()
          .toLowerCase()
          .contains(digitado.toLowerCase())) {
        atividadesSelecionadas.add(ativ);
      }
    }
    if (atividadesSelecionadas.isEmpty) {
      if (digitado == '') {
        return atividades;
      } else {
        atividadesSelecionadas.add({'id': 0, 'nome': 'Categoria Inexistente'});
      }
    }
    return atividadesSelecionadas;
  }

  selecionaCidade(String digitado) {
    cidadesSelecionadas.clear();
    for (var ativ in cidades) {
      if (ativ['nome']
          .toString()
          .toLowerCase()
          .contains(digitado.toLowerCase())) {
        cidadesSelecionadas.add(ativ);
      }
    }
    if (cidadesSelecionadas.isEmpty) {
      if (digitado == '') {
        return cidades;
      } else {
        cidadesSelecionadas.add({'id': 0, 'nome': 'Cidade Inexistente'});
      }
    }
    return cidadesSelecionadas;
  }

  filtraAutonomos(String nomeatividade) {
    Funcoes.autonomosSelecionados.clear();
    for (var autonomo in Funcoes.autonomos) {
      if (autonomo.atividade
          .toString()
          .toLowerCase()
          .contains(nomeatividade.toLowerCase())) {
        autonomosSelecionados.add(autonomo);
      }
    }
    return autonomosSelecionados;
  }

  Widget splash(double largura, double altura, {double fSize = 15}) {
    return Stack(
      children: [
        Container(
            color: COR_02,
            height: altura / 2,
            width: largura,
            child: const Image(
              image: AssetImage('img/ccse1.gif'),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            height: largura / 4,
            color: Colors.red.withOpacity(0.8),
            width: largura / 3 * 2 * 0.95,
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Text(
              "CCSE es una prueba de examen que evalúa el conocimiento de la Constitución y de la realidad social y cultural españolas",
              textAlign: TextAlign.end,
              maxLines: 4,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Image(
            image: const AssetImage('img/ccse.png'),
            fit: BoxFit.cover,
            width: largura / 4,
            height: largura / 4,
          ),
        ),
      ],
    );
  }

  Widget answerDetails(double largura, double altura, String answerImageAddress,
      String answerDetails,
      {double fSize = 15}) {
    return Stack(
      children: [
        Container(
            color: COR_02,
            height: altura / 2,
            width: largura,
            child: Image(
              image: AssetImage(answerImageAddress),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            height: largura / 4,
            color: Colors.red.withOpacity(0.8),
            width: largura / 3 * 2 * 0.95,
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Text(
              answerDetails,
              textAlign: TextAlign.end,
              maxLines: 4,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        /* Positioned(
          bottom: 10,
          right: 10,
          child: Image(
            image: const AssetImage('img/ccse.png'),
            fit: BoxFit.cover,
            width: largura / 4,
            height: largura / 4,
          ),
        ), */
      ],
    );
  }
}
