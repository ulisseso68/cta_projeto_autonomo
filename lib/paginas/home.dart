import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/catalog.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  List _cidadesSelecionadas = [];
  List<Catalog> _learningCatalog = [];
  bool extended = true;

  @override
  initState() {
    _getDatafromServer();
    super.initState();
  }

  _getDatafromServer() async {
    await Funcoes().iniciarCidades();
    _cidadesSelecionadas = Funcoes.cidades;
    /* Funcoes.screenWidth = MediaQuery.of(context).size.width;
    Funcoes.screenHeight = MediaQuery.of(context).size.height; */
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //var textController;
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    // ignore: prefer_typing_uninitialized_variables
    //var textController;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //Cabeçalho com imagem, Logo e Slogan
          GestureDetector(
              onTap: () {
                extended = !extended;
                setState(() {});
              },
              child:
                  Funcoes().splash(largura, (extended) ? altura : altura / 2)),
          Container(
            width: largura,
            height: 5,
            color: redEspana,
          ), //area de busca
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'sanfona');
              setState(() {});
            },
            child: Container(
              width: largura,
              height: 20,
              color: COR_02,
            ),
          ), //

          //Training Trail
          Container(
              margin:
                  EdgeInsets.only(left: largura * 0.05, right: largura * 0.05),
              height: altura / 2,
              child: (_cidadesSelecionadas.isEmpty)
                  ? const Center(
                      child: Text(
                        'Ocorreu um problema na comunicação com os servidores do AUtonoJobs. Cheque sua internet e tente novamente.',
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontFamily: "Verdana",
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _cidadesSelecionadas.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          tileColor: (index % 2 == 0)
                              ? const Color.fromARGB(255, 227, 223, 223)
                              : Colors.transparent,
                          title: Text(
                            _cidadesSelecionadas[index]['nome'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 199, 17, 32),
                                fontFamily: 'Verdana'),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              extended = true;
                              setState(() {});
                              Funcoes.cidadeEscolhida =
                                  _cidadesSelecionadas[index]['nome'];
                              Navigator.pushNamed(context, 'questionsPage1');
                            },
                            icon: const Icon(
                              Icons.open_in_new,
                              color: Color.fromARGB(255, 199, 17, 32),
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
