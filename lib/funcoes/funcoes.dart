//import 'dart:convert';
//import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
//import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';

class Funcoes {
  var atividadesSelecionadas = <String>[];
  var autonomosSelecionados = [];

  calcular() {
    // ignore: avoid_print
    print(autonomosDados.length);
    //Iterable list = autonomosDados;
    //var things = list.map((model) => Autonomo.fromJson(model)).toList();
    //print(things.length);
  }

  void whatsapp(String phone) {
    /* var whatsappUrl =
                    "whatsapp://send?phone=" + widget.autonomo['telefone'];
     */
    //launch('https://app.reusos.com');
    print(phone);
  }

  seleciona(String digitado) {
    atividadesSelecionadas.clear();
    for (var ativ in atividades) {
      if (ativ.contains(digitado)) {
        atividadesSelecionadas.add(ativ);
      }
    }
    if (atividadesSelecionadas.isEmpty) {
      if (digitado == '') {
        return atividades;
      } else {
        atividadesSelecionadas.add('Categoria Inexistente');
      }
    }
    return atividadesSelecionadas;
  }

  filtraAutonomos(String atividade) {
    autonomosSelecionados.clear();
    for (var autonomo in autonomosDados) {
      if (autonomo['atividade'] == atividade) {
        autonomosSelecionados.add(autonomo);
      }
    }

    return autonomosSelecionados;
  }
}
