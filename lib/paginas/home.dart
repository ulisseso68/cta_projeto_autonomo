import 'dart:math';

import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:cta_projeto_autonomo/paginas/drawer.dart'; /* 
import 'package:cta_projeto_autonomo/utilidades/questions.dart'; */
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
  bool extended = false;
  bool totalStatistics = false;

  @override
  initState() {
    super.initState();
    _getDatafromServer();
    super.initState();
  }

  void collapse(int index) {
    if (Funcoes().existsAnyAnsweredQuestion()) {
      totalStatistics = true;
      extended = false;
    } else {
      totalStatistics = false;
      extended = true;
    }
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
    await Funcoes().iniciarPreguntas();
    _categoriesSelected = uniqueCategories;
    _isOpen = List.generate(_categoriesSelected.length, (index) => false);
    extended = !Funcoes().existsAnyAnsweredQuestion();
    totalStatistics = !extended;
    setState(() {});
  }

  void updateStatus() {
    if (Funcoes().existsAnyAnsweredQuestion()) {
      totalStatistics = true;
      extended = false;
    } else {
      totalStatistics = false;
      extended = true;
    }
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
      onDrawerChanged: (isClosed) => updateStatus(),
      drawer: const AJDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        toolbarHeight: (extended) ? altura / 3 : altura / 6,
        title: Row(
          children: [
            Funcoes().logoWidget(fontSize: 35, opacity: 0.4),
            Hero(
              tag: 'splash_image',
              child: Image(
                width: largura * 0.15,
                image: AssetImage('img/CCSEf.png'),
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
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
      body: RefreshIndicator(
        color: COR_02,
        displacement: 50,
        backgroundColor: redEspana.withOpacity(0.5),
        onRefresh: () {
          return _getDatafromServer();
        },
        child: SingleChildScrollView(
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
            GestureDetector(
              onTap: () {
                // Handle tap
                totalStatistics = !totalStatistics;
                extended = !totalStatistics;
                /* 
                if (extended) {
                  _isOpen = List.generate(
                      _categoriesSelected.length, (index) => false);
                } */
                setState(() {});
              },
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  (!totalStatistics)
                      ? Funcoes().appLang('Training Trail')
                      : Funcoes().appLang('How you are progressing'),
                  style: const TextStyle(
                      fontSize: 20, color: COR_02, fontWeight: FontWeight.bold),
                ),
                subtitle: Container(
                  padding: const EdgeInsets.all(1.0),
                  child: (!totalStatistics)
                      ? Text(
                          Funcoes().appLang("Training Trail Description"),
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Funcoes().progressBar(barSize: 0.7),
                            Funcoes().progressRings()
                          ],
                        ),
                ),
              ),
            ),
            Divider(
              color: COR_02,
              height: 10,
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
            //List of categories
            _buildListTile(),

            Divider(
              thickness: 1,
              height: 10,
              indent: 10,
              endIndent: 10,
              color: redEspana,
            ),
            Funcoes()
                .logoWidget(fontSize: 20, opacity: 0, letterColor: Colors.grey),
          ]),
        ),
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
      int qty = Funcoes().selectQuestions(catsel).length;
      if (catsel == examCat) {
        listTiles.add(
          Divider(
            color: redEspana,
            height: 10,
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
        );
      } // Skip the test category
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
            Funcoes().shortCat(catsel),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 17, color: (catsel == examCat) ? redEspana : COR_01),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle:
            questionaryOptions(_isOpen[i], qty.toString(), catsel, context),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Funcoes().progressRings(category: catsel),
            IconButton(
                onPressed: () {
                  setState(() {
                    collapse(i);
                  });
                },
                icon: _isOpen[i]
                    ? Icon(
                        Icons.minimize_outlined,
                        color: Colors.grey,
                        size: 30,
                      )
                    : Container(
                        width: 30,
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
          ],
        ),
      ));
    }

    return Column(
      children: listTiles,
    );
  }

  Widget questionaryOptions(
      bool isOpen, String title, String category, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Color.fromRGBO(255, 224, 178, 1),
          thickness: 1,
          height: 10,
        ),
        !isOpen
            ? Text(
                (category == examCat)
                    ? "25 ${Funcoes().appLang("questions from all categories.")}"
                    : "${Funcoes().appLang('Practice')} $title ${Funcoes().appLang("Questions")}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 15,
                  color: COR_02,
                ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverflowBar(
                    alignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: [
                      /* Icon(Icons.navigate_next_rounded, color: COR_02), */
                      /* if (category != examCat)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: COR_02,
                          ),
                          onPressed: () async {
                            Funcoes.categorySelected = category;
                            numberOfQuestions = 15;
                            await Navigator.pushNamed(context, 'questionsPage1')
                                .then((value) {
                              //This callback is executed when returning from the questions page
                              updateStatus();
                            });
                          },
                          child: Text(Funcoes().appLang("15"),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                        ), */
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor:
                              (category != examCat) ? COR_02 : redEspana,
                        ),
                        onPressed: () async {
                          Funcoes.categorySelected = category;
                          numberOfQuestions = 25;
                          await Navigator.pushNamed(
                                  context,
                                  (category != examCat)
                                      ? 'questionsPage1'
                                      : 'questionsExam')
                              .then((value) {
                            //This callback is executed when returning from the questions page
                            updateStatus();
                          });
                        },
                        child: Text(
                            (category != examCat)
                                ? Funcoes().appLang("25")
                                : Funcoes().appLang("Take the test"),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
                      ),
                      //All questions button
                      if (category != examCat)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: COR_02,
                          ),
                          onPressed: () async {
                            Funcoes.categorySelected = category;
                            numberOfQuestions = 1000;
                            await Navigator.pushNamed(context, 'questionsPage1')
                                .then((value) {
                              // This callback is executed when returning from the questions page
                              updateStatus();
                            });
                          },
                          child: Text(Funcoes().appLang("All"),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                        ),

                      //Wrongly answered questions button
                      if (category != examCat &&
                          Funcoes()
                              .wronglyAnsweredQuestions(category)
                              .isNotEmpty)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            backgroundColor: redEspana,
                          ),
                          onPressed: () async {
                            Funcoes.categorySelected = category;
                            numberOfQuestions = -1;
                            await Navigator.pushNamed(context, 'questionsPage1')
                                .then((value) {
                              // This callback is executed when returning from the questions page
                              updateStatus();
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                  Funcoes()
                                      .wronglyAnsweredQuestions(category)
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}
