import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class PaginaSelecaoCidade extends StatefulWidget {
  const PaginaSelecaoCidade({Key? key}) : super(key: key);

  @override
  State<PaginaSelecaoCidade> createState() => _PaginaSelecaoCidadeState();
}

class _PaginaSelecaoCidadeState extends State<PaginaSelecaoCidade> {
  // ignore: prefer_final_fields
  List _cidadesSelecionadas = [];

  @override
  initState() {
    _getDatafromServer();
    super.initState();
  }

  _getDatafromServer() async {
    await Funcoes().iniciarCidades();
    _cidadesSelecionadas = Funcoes.cidades;
    Funcoes.screenWidth = MediaQuery.of(context).size.width;
    Funcoes.screenHeight = MediaQuery.of(context).size.height;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    // ignore: prefer_typing_uninitialized_variables
    var textController;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //Cabeçalho com imagem, Logo e Slogan
          Funcoes().splash(largura, altura),
          Container(
            width: largura,
            height: 5,
            color: Colors.green,
          ), //area de busca

          //Campo de Busca
          SizedBox(
            height: 70,
            width: largura * 0.9,
            child: TextField(
              onChanged: (texto) {
                setState(() {
                  _cidadesSelecionadas = Funcoes().selecionaCidade(texto);
                });
              },
              onSubmitted: (texto) {
                Navigator.pushNamed(context, 'listaAutonomos');
              },
              style: const TextStyle(color: Color(0xFF000000), fontSize: 30),
              cursorColor: COR_02,
              controller: textController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'selecione sua cidade',
                hintStyle: TextStyle(
                    color: Color(0xFF9b9b9b),
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          //Lista de atividas
          Container(
              margin:
                  EdgeInsets.only(left: largura * 0.05, right: largura * 0.05),
              height: altura / 3,
              child: ListView.builder(
                  itemCount: _cidadesSelecionadas.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      tileColor: (index % 2 == 0)
                          ? const Color.fromARGB(255, 227, 223, 223)
                          : Colors.transparent,
                      title: Text(
                        _cidadesSelecionadas[index]['nome'],
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 20, color: COR_04, fontFamily: 'Verdana'),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Funcoes.cidadeEscolhida =
                              _cidadesSelecionadas[index]['nome'];
                          Navigator.pushNamed(context, 'selecionaAtividade');
                        },
                        icon: const Icon(
                          Icons.open_in_new,
                          color: COR_04,
                          size: 30,
                        ),
                      ),
                    );
                  }))),
        ]),
      ),
    );
  }
}
