import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class Funcoes {
  static List atividadesSelecionadas = [];
  static List<Autonomo> autonomosSelecionados = <Autonomo>[];
  static List cidadesSelecionadas = [];
  static List atividades = [];
  static List cidades = [];
  static List<Autonomo> autonomos = <Autonomo>[];
  static String cidadeEscolhida = '';
  static String atividadeEscolhida = '';
  static Autonomo autonomoEscolhido = Autonomo();
  static double screenHeight = 800;
  static double screenWidth = 300;

  calcular() {
    print(autonomos.length);
  }

  iniciarAtividades() async {
    atividades = await CallApi().getPublicData('atividades');
  }

  iniciarCidades() async {
    cidades = await CallApi().getPublicData('cidades');
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

  void whatsapp(String phone) {
    /* var whatsappUrl =
                    "whatsapp://send?phone=" + widget.autonomo['telefone'];
     */
    //print(phone);
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

  Widget splash(double largura, double altura, {double fSize = 16}) {
    return Stack(
      children: [
        Container(
            color: COR_04,
            height: altura / 3,
            width: largura,
            child: const Image(
              image: AssetImage('img/autonojobs.gif'),
              fit: BoxFit.cover,
            )),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            height: largura / 4,
            color: Colors.black.withOpacity(0.3),
            width: largura / 3 * 2,
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Text(
              "Sempre que precisar, recorra a um profissional conhecido, perto de você.",
              textAlign: TextAlign.end,
              maxLines: 4,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fSize,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Image(
            image: const AssetImage('img/appstore.png'),
            fit: BoxFit.cover,
            width: largura / 4,
            height: largura / 4,
          ),
        ),
      ],
    );
  }
}
