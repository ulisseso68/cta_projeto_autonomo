import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:cta_projeto_autonomo/paginas/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  List _categoriesSelected = [];
  List<bool> _isOpen = [];
  bool extended = true;

  @override
  initState() {
    _getDatafromServer();
    super.initState();
  }

  Future<void> _getDatafromServer() async {
    answeredQuestions = await Funcoes().loadAnsweredQuestionsFromLocal();
    await Funcoes().initializeCatalog();
    _categoriesSelected = uniqueCategories;
    _isOpen = List.generate(_categoriesSelected.length, (index) => false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;

    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const AJDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        toolbarHeight: (extended) ? altura / 3 : altura / 6,
        title: Funcoes().logoWidget(fontSize: 35, opacity: 0.4),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(extended ? Icons.zoom_out : Icons.zoom_in),
            iconSize: 40,
            onPressed: () {
              extended = !extended;
              setState(() {});
              // Implement search functionality here
            },
          ),
        ],
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'img/ccse1.gif',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: largura,
                height: 5,
                color: redEspana,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //Cabeçalho com imagem, Logo e Slogan

          //area de busca
          Container(
            width: largura,
            height: 10,
            color: COR_02,
          ),
          const SizedBox(
            height: 10,
          ),

          //Training Trail
          Funcoes().titleWithIcon(Funcoes().appLang("Training Trail"),
              Funcoes().appLang("Training Trail Description"), context,
              isOpen: true),

          Divider(
            color: Colors.orange.shade100,
            height: 10,
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
          _buildListTile(),
        ]),
      ),
    );
  }

  Widget _buildListTile() {
    List<Widget> listTiles = [];

    for (int i = 0; i < _categoriesSelected.length; i++) {
      String catsel = _categoriesSelected[i];
      int qty = Funcoes().selectQuestions(catsel.toUpperCase()).length;
      listTiles.add(ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(
          catsel,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 18, color: COR_01),
        ),
        subtitle: Funcoes()
            .questionaryOptions(_isOpen[i], qty.toString(), catsel, context),
        leading: IconButton(
          onPressed: () {
            setState(() {
              extended = false;
              _isOpen[i] = !_isOpen[i];
            });
          },
          icon: Icon(
            _isOpen[i] ? Icons.expand_less : Icons.expand_more,
            color: COR_01,
            size: 30,
          ),
        ),
      ));
    }
    return Column(
      children: listTiles,
    );
  }
}
