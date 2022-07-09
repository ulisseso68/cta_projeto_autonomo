import 'package:cta_projeto_autonomo/utilidades/dados.dart';

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
    //print(phone);
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
