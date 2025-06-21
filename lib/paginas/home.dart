import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/catalog.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  List _categoriesSelected = [];
  List<Catalog> _learningCatalog = [];
  List<bool> _isOpen = [];
  bool extended = true;

  @override
  initState() {
    _getDatafromServer();

    super.initState();
  }

  _getDatafromServer() async {
    answeredQuestions = await Funcoes().loadAnsweredQuestionsFromLocal();
    await Funcoes().initializeCatalog();
    _categoriesSelected = uniqueCategories;
    _isOpen = List.generate(_categoriesSelected.length, (index) => false);
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
              child: (_categoriesSelected.isEmpty)
                  ? Center(
                      child: Text(
                        Funcoes().appLang("Problem loading data"),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontFamily: "Verdana",
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _categoriesSelected.length,
                      itemBuilder: ((context, index) {
                        String catsel = _categoriesSelected[index];
                        int qty = Funcoes()
                            .selectQuestions(catsel.toUpperCase())
                            .length;
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          tileColor: (index % 2 == 0)
                              ? const Color.fromARGB(255, 227, 223, 223)
                              : Colors.transparent,
                          title: Text(
                            _categoriesSelected[index],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 199, 17, 32),
                                fontFamily: 'Verdana'),
                          ),
                          subtitle:
                              /* Text("$qty ${Funcoes().appLang("Questions")}",
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: COR_02,
                                  )) */
                              Funcoes().questionaryOptions(
                                  _isOpen[index],
                                  largura,
                                  altura,
                                  qty.toString(),
                                  _categoriesSelected[index]),
                          leading: IconButton(
                            onPressed: () {
                              /* extended = true;
                              setState(() {});
                              Funcoes.categorySelected =
                                  _categoriesSelected[index];
                              Navigator.pushNamed(context, 'questionsPage1'); */
                              setState(() {
                                _isOpen[index] = !_isOpen[index];
                              });
                            },
                            icon: Icon(
                              _isOpen[index]
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: const Color.fromARGB(255, 199, 17, 32),
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
