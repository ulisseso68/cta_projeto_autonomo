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
      : id = '',
        nome = json['nome'],
        descricao = json['descricao'],
        telefone = json['telefone'],
        atividade = json['nome_atividade'],
        foto = json['foto'],
        cidade = json['nome_cidade'],
        cep = json['cep'],
        uf = json['uf'];

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
            color: COR_02,
          );
  }
}
