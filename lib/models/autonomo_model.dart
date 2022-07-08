class Autonomo {
  int id;
  double precohora;
  String nome;
  String descricao;
  String atividade;
  String fotoProfissional;
  String fotoNegocio;
  double estrelas;
  String cep;
  String cadastradoem;

  Autonomo(
      this.id,
      this.precohora,
      this.nome,
      this.descricao,
      this.atividade,
      this.fotoProfissional,
      this.fotoNegocio,
      this.estrelas,
      this.cep,
      this.cadastradoem);

  fromJson(Map json) {
    id = json['id'];
    precohora = json["precohora"] is int
        ? (json['precohora'] as int).toDouble()
        : json['precohora'];
    estrelas = json["estrelas"] is int
        ? (json['estrelas'] as int).toDouble()
        : json['estrelas'];
    nome = json['nome'];
    descricao = json['descricao'];
    atividade = json['atividade'];
    fotoProfissional = json['fotoProfissional'];
    fotoNegocio = json['fotoNegocio'];
    cep = json['cep'];
    cadastradoem = json['cadastradoem'];
  }
}
