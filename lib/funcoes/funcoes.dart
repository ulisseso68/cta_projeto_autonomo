import 'dart:convert';

import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';

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

  calcular() {
    print(autonomosDados.length);
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
}
