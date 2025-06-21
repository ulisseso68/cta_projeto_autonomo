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
  bool _isOpenTotal = false;

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
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;

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
          const SizedBox(
            height: 10,
          ),

          //Espaço entre a área de busca e o título
          //Training Trail
          Funcoes().titleWithIcon(Funcoes().appLang("Training Trail"),
              Funcoes().appLang("Training Trail Description"), context,
              isOpen: true),

          Divider(
            color: COR_02.withOpacity(0.2),
            height: 10,
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),

          Column(
            children: [
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  "${Funcoes().appLang("All")} ${Funcoes().appLang("Questions")}",
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18, color: COR_01),
                ),
                /* subtitle: Funcoes().questionaryOptions(
                                  _isOpen[index],
                                  qty.toString(),
                                  _categoriesSelected[index],
                                  context), */
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _isOpenTotal = !_isOpenTotal;
                    });
                  },
                  icon: Icon(
                    _isOpenTotal ? Icons.expand_less : Icons.expand_more,
                    color: COR_01,
                    size: 30,
                  ),
                ),
              ),
              Container(
                  color: Colors.transparent,
                  height: screenH,
                  child: /* (_categoriesSelected.isEmpty)
                      ? const SizedBox(
                          height: 0,
                        )
                      :  */
                      ListView.builder(
                          itemCount: _categoriesSelected.length,
                          itemBuilder: ((context, index) {
                            String catsel = _categoriesSelected[index];
                            int qty = Funcoes()
                                .selectQuestions(catsel.toUpperCase())
                                .length;
                            return ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              title: Text(
                                _categoriesSelected[index],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: COR_01,
                                    fontFamily: 'Verdana'),
                              ),
                              subtitle: Funcoes().questionaryOptions(
                                  _isOpen[index],
                                  qty.toString(),
                                  _categoriesSelected[index],
                                  context),
                              leading: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isOpen[index] = !_isOpen[index];
                                  });
                                },
                                icon: Icon(
                                  _isOpen[index]
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: COR_01,
                                  size: 30,
                                ),
                              ),
                            );
                          }))),
            ],
          ),
        ]),
      ),
    );
  }
}
