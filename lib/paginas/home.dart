import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:cta_projeto_autonomo/paginas/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

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
    super.initState();
    _getDatafromServer();
    super.initState();
  }

  void collapse(int index) {
    extended = false;
    for (int i = 0; i < _isOpen.length; i++) {
      if (i != index) {
        _isOpen[i] = false;
      } else {
        _isOpen[i] = !_isOpen[i];
      }
    }
    setState(() {});
  }

  Future<void> _getDatafromServer() async {
    await Funcoes().getCountryFromStorage();
    await Funcoes().getLanguageFromStorage();
    await Funcoes().getTcsAcceptedFromStorage();
    await Funcoes().getUserNameFromStorage();

    deviceID = (await _getId()).toString();

    if (!loginRegistered) {
      CallApi().postDataWithHeaders(
          'journals/process',
          {'deviceid': deviceID, 'type': 'access', 'value': 0},
          {'Authorization': 'Bearer token'});
      loginRegistered = true;
    }

    // redirect to splash page if TCS not accepted
    if (!tcsAccepted) {
      Navigator.pushNamed(context, 'splashPage');
    }
    // Load unique categories from the questions
    answeredQuestions = await Funcoes().loadAnsweredQuestionsFromLocal();
    await Funcoes().initializeCatalog();
    _categoriesSelected = uniqueCategories;
    _isOpen = List.generate(_categoriesSelected.length, (index) => false);
    setState(() {});
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }
      return 'test_device_001';
    } catch (e) {
      return 'test_device_001';
    }
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
              right: 10,
              child: Hero(
                tag: 'splash_image',
                child: Image(
                  width: largura * 0.3,
                  image: AssetImage('img/CCSEf.png'),
                  fit: BoxFit.fill,
                ),
              ),
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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
      bottomSheet: Container(
        width: largura,
        height: 40,
        color: redEspana,
      ),
    );
  }

  Widget _buildListTile() {
    List<Widget> listTiles = [];

    for (int i = 0; i < _categoriesSelected.length; i++) {
      String catsel = _categoriesSelected[i];
      int qty = Funcoes().selectQuestions(catsel.toUpperCase()).length;
      listTiles.add(ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: _isOpen[i] ? Colors.orange.shade100 : null,
        dense: true,
        visualDensity: VisualDensity.compact,
        title: GestureDetector(
          onTap: () => setState(() {
            collapse(i);
          }),
          child: Text(
            catsel,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 18, color: COR_01),
          ),
        ),
        subtitle: Funcoes()
            .questionaryOptions(_isOpen[i], qty.toString(), catsel, context),
        leading: IconButton(
            onPressed: () {
              setState(() {
                collapse(i);
              });
            },
            icon: _isOpen[i]
                ? Icon(
                    Icons.close_rounded,
                    color: COR_02,
                    size: 30,
                  )
                : Container(
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: COR_02,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text((i + 1).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  )),
      ));
    }
    return Column(
      children: listTiles,
    );
  }
}
