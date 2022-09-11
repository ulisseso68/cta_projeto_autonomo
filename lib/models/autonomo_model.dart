import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class Autonomo {
  String id = '';
  String nome;
  String descricao;
  String atividade;
  String telefone;
  String foto;
  String uf;
  String cep;
  String cidade;
  bool recomenda = false;
  String preco = '';
  String url = '';

  Autonomo(
      {this.id = '',
      this.nome = '',
      this.descricao = '',
      this.atividade = '',
      this.telefone = '',
      this.foto = '',
      this.uf = '',
      this.cep = '',
      this.cidade = ''});

  Autonomo.fromJson(Map json)
      : id = json['id'] is String ? json['id'] : '',
        nome = json['nome'] is String ? json['nome'] : '',
        descricao = json['descricao'] is String ? json['descricao'] : '',
        telefone = json['telefone'] is String ? json['telefone'] : '',
        atividade =
            json['nome_atividade'] is String ? json['nome_atividade'] : '',
        foto = json['foto'] is String ? json['foto'] : '',
        cidade = json['nome_cidade'] is String ? json['nome_cidade'] : '',
        cep = json['cep'] is String ? json['cep'] : '',
        uf = json['uf'] is String ? json['uf'] : '';

  Widget image() {
    return (foto != '')
        ? Hero(
            tag: foto + nome,
            child: Image(
              image: NetworkImage(foto),
              fit: BoxFit.cover,
            ),
          )
        : const Icon(
            Icons.badge,
            size: 40,
            color: COR_04,
          );
  }

  String descricaoLimpa() {
    recomendado();
    getPreco();
    getURL();
    descricao = descricao.trim();
    return descricao;
  }

  bool recomendado() {
    if (descricao.contains('#AJrecomenda')) {
      recomenda = true;
      descricao = descricao.replaceAll('#AJrecomenda', '');
    }
    return recomenda;
  }

  String getPreco() {
    String tag = '#AJpreco{';
    if (descricao.contains(tag)) {
      var posi = descricao.indexOf(tag);
      String parte = descricao.substring(posi, descricao.length);
      String posf = parte.split('}').first;
      if (posf != '') {
        preco = posf.replaceAll(tag, '');
        descricao = descricao.replaceAll('$tag$preco}', '');
      }
    }
    return preco;
  }

  String getURL() {
    String tag = '#AJurl{';
    if (descricao.contains(tag)) {
      var posi = descricao.indexOf(tag);
      String parte = descricao.substring(posi, descricao.length);
      String posf = parte.split('}').first;
      if (posf != '') {
        url = posf.replaceAll(tag, '');
        descricao = descricao.replaceAll('$tag$url}', '');
      }
    }
    return url;
  }

  String localizacao() {
    return "$uf $cidade $cep";
  }

  Widget circledImage({Color bordercolor = Colors.green, double radius = 30}) {
    return (foto == '')
        ? Icon(
            Icons.badge,
            size: radius,
            color: bordercolor,
          )
        : Hero(
            tag: foto + nome,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                        color: bordercolor, blurRadius: 0.0, spreadRadius: 3.0)
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(foto),
                  )),
            ),
          );
  }

  void sendWA() {
    if (telefone != '') {
      var whatsappUrl = "whatsapp://send?phone=+55$telefone";
      print(whatsappUrl);
      CallApi().launchUrlOut(whatsappUrl);
    }
  }
}
