import 'dart:math';

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
  bool extended = false;
  bool totalStatistics = false;
  bool practiceTileDetailed = false;
  bool flashCardsDetailed = false;

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
      CallApi().postDataWithHeaders('journals/process', {
        'deviceid': deviceID,
        'type': 'access',
        'value': 0,
        'devicetype': deviceType
      }, {
        'Authorization': 'Bearer token'
      });
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
        deviceType = 'iOS';
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        deviceType = 'Android';
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
    final colorCCSE = COR_02;

    return Scaffold(
      onDrawerChanged: (isClosed) => updateStatus(),
      drawer: const AJDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 40,
        ),
        toolbarHeight: (extended) ? altura / 3 : altura / 6,
        title: Row(
          children: [
            Funcoes().logoWidget(fontSize: 35, opacity: 0.4),
            /* Hero(
              tag: 'splash_image',
              child: Image(
                width: largura * 0.15,
                image: AssetImage('img/CCSEf.png'),
                fit: BoxFit.fill,
              ),
            ), */
          ],
        ),
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'img/ccse1.jpg',
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: largura,
                height: 5,
                color: COR_02,
              ),
            ),
            Positioned(
              right: screenW * 0.05 / 2,
              bottom: 20,
              width: screenW * 0.20,
              height: 50,
              child: GestureDetector(
                onTap: () async {
                  // Handle language change
                  uxToChangeLanguage(context, altura, largura);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: COR_02,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      Funcoes().languageFlag(language.toString(), size: 25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: COR_02,
        displacement: 50,
        backgroundColor: Colors.grey.shade300,
        onRefresh: () {
          return _getDatafromServer();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Cabeçalho com imagem, Logo e Slogan
                const SizedBox(
                  height: 10,
                ),

                //Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container for the exam button
                    GestureDetector(
                      onTap: () async {
                        Funcoes.categorySelected = examCat;
                        numberOfQuestions = 25;
                        await Navigator.pushNamed(context, 'questionsExam')
                            .then((value) {
                          //This callback is executed when returning from the questions page
                          updateStatus();
                        });
                      },
                      child: Container(
                        height: altura / 12,
                        width: largura * 0.95,
                        decoration: BoxDecoration(
                          border: Border.all(color: colorCCSE, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorCCSE,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Funcoes().progressRings(),
                                  Icon(
                                    Icons.edit_note,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ],
                              ),
                              title: Text(
                                Funcoes().appLang('Take the CCSE Exam'),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //Divider
                Divider(
                  color: COR_02,
                  height: 40,
                  thickness: 1,
                ),

                //Title - Study by Category
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    Funcoes().appLang('Study by Category'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: COR_02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: FloatingActionButton(
                      backgroundColor: COR_02,
                      heroTag: 'btnInfo',
                      onPressed: () {
                        setState(() {
                          practiceTileDetailed = !practiceTileDetailed;
                        });
                      },
                      child: Icon(
                        color: Colors.white,
                        (!practiceTileDetailed)
                            ? Icons.info_outline_rounded
                            : Icons.expand_less_rounded,
                      )),
                  subtitle: (practiceTileDetailed)
                      ? Text(
                          Funcoes().appLang(
                              'You can chose how many questions to practice, and will have: Immediate validation of your response, knowledge cards to help you memorize, and translation to your language if you want.'),
                          style: TextStyle(color: COR_01),
                        )
                      : Container(),
                ),

                Divider(
                  color: Colors.transparent,
                  height: 10,
                  thickness: 1,
                ),

                //List of categories
                _buildListTile(),

                //Study with flash cards
                Divider(
                  color: COR_02,
                  height: 40,
                  thickness: 1,
                ),

                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    Funcoes().appLang('Study Cards'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: COR_02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: FloatingActionButton(
                      backgroundColor: COR_02,
                      heroTag: 'btnCards',
                      onPressed: () {
                        setState(() {
                          flashCardsDetailed = !flashCardsDetailed;
                        });
                      },
                      child: Icon(
                        color: Colors.white,
                        (!flashCardsDetailed)
                            ? Icons.tips_and_updates
                            : Icons.expand_less_rounded,
                      )),
                  subtitle: (flashCardsDetailed)
                      ? Text(
                          Funcoes().appLang(
                              'You can also choose to look at interesting facts that can help you learn about Spanish Government, Economics, Society and Culture.'),
                          style: TextStyle(color: COR_01),
                        )
                      : Container(),
                ),

                Divider(
                  color: Colors.transparent,
                  height: 10,
                  thickness: 1,
                ),

                if (learnings.isNotEmpty)
                  SizedBox(
                    height: screenH * 0.2,
                    /* width: screenW * 0.6, */
                    child: PageView.builder(
                      itemCount: learnings.length,
                      onPageChanged: (index) {
                        currentQuestion = learnings[index];
                      },
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'learningPage');
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.grey.shade400, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: COR_02,
                                    ),
                                  ),
                                  Container(
                                    width: screenW * 0.4,
                                    decoration: BoxDecoration(
                                      color: COR_02,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                      border:
                                          Border.all(color: COR_02, width: 1),
                                      image: DecorationImage(
                                        image: learnings[index].imagem(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (learnings[index]
                                      .hasTranslationForCurrentLanguage)
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: FloatingActionButton.small(
                                        heroTag: 'translate_button_$index',
                                        shape: const StadiumBorder(),
                                        backgroundColor: COR_04,
                                        onPressed: () {
                                          // Handle translation button press
                                          Navigator.pushNamed(
                                              context, 'learningPage');
                                        },
                                        child: Icon(Icons.translate_rounded,
                                            color: Colors.white, size: 20),
                                      ),
                                    )
                                ],
                              ),
                              Container(
                                width: screenW * 0.3,
                                padding: EdgeInsets.all(3.0),
                                child: Text(
                                  Funcoes()
                                      .appLang(learnings[index].description),
                                  maxLines: 12,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: (learnings[index]
                                            .hasTranslationForCurrentLanguage)
                                        ? COR_04
                                        : COR_01,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                      controller: PageController(
                        viewportFraction: 0.80,
                        initialPage: 1,
                      ),
                    ),
                  ),

                //Footer
                Divider(
                  thickness: 1,
                  height: 30,
                  indent: 10,
                  endIndent: 10,
                  color: COR_02,
                ),
                Funcoes().logoWidget(
                    fontSize: 20, opacity: 0, letterColor: Colors.grey),
                Divider(
                  thickness: 1,
                  height: 100,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.white,
                )
              ]),
        ),
      ),
      bottomSheet: Container(
        width: largura,
        height: altura / 15,
        color: COR_02b,
      ),
    );
  }

  //Builds the list of tiles for the categories
  Widget _buildListTile() {
    List<Widget> listTiles = [];
    Color catTileColor = Colors.grey.shade100;

    for (int i = 1; i < _categoriesSelected.length; i++) {
      String catsel = _categoriesSelected[i];
      int qty = Funcoes().selectQuestions(catsel).length;
      catTileColor = (_isOpen[i])
          ? Colors.orange.shade200 // Color for the open category
          : Colors.grey.shade400; // Color for the exam category

      // Skip the test category
      if (qty > 0) {
        listTiles.add(Container(
          //width: screenW * 0.90,
          decoration: BoxDecoration(
            border: Border.all(color: catTileColor, width: 2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: catTileColor,
              dense: true,
              visualDensity: VisualDensity.compact,
              title: GestureDetector(
                onTap: () => setState(() {
                  collapse(i);
                }),
                child: Text(
                  Funcoes().shortCat(catsel),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17, color: COR_01),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: questionaryOptions(
                  _isOpen[i], qty.toString(), catsel, context),
              trailing: Stack(
                alignment: Alignment.center,
                children: [
                  Funcoes().progressRings(category: catsel),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          collapse(i);
                        });
                      },
                      icon: Icon(
                        Icons.auto_stories,
                        color: COR_02,
                        size: 20,
                      )),
                ],
              )),
        ));
      }
    }

    return Column(
      spacing: 10,
      children: listTiles,
    );
  }

  //build the expanded view of each tile
  Widget questionaryOptions(
      bool isOpen, String title, String category, BuildContext context,
      {Color mainColor = COR_02}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: Colors.transparent,
          thickness: 1,
          height: 10,
        ),
        !isOpen
            ? Text(
                (category == examCat)
                    ? "25 ${Funcoes().appLang("questions from all categories.")}"
                    : "$title ${Funcoes().appLang("Questions")}",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  color: mainColor,
                ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OverflowBar(
                    alignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: [
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
                          await Navigator.pushNamed(context, 'questionsPage1')
                              .then((value) {
                            //This callback is executed when returning from the questions page
                            updateStatus();
                          });
                        },
                        child: Text(Funcoes().appLang("25"),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white)),
                      ),
                      //All questions button

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

  void uxToChangeLanguage(context, double altura, double largura) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Funcoes().appLang('Available Languages'),
            style: const TextStyle(fontSize: 20, color: COR_02),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: altura * 0.25,
            child: Column(
              spacing: 8,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: (language == 0) ? COR_04 : COR_02,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Funcoes().setLanguage(0);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: SizedBox(
                    width: largura * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Funcoes().languageFlag('0', size: 30),
                        Text(Funcoes().appLang('English'),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: (language == 1) ? COR_04 : COR_02,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Funcoes().setLanguage(1);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: SizedBox(
                    width: largura * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Funcoes().languageFlag('1', size: 30),
                        Text(Funcoes().appLang('Portuguese'),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: (language == 2) ? COR_04 : COR_02,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Funcoes().setLanguage(2);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: SizedBox(
                    width: largura * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Funcoes().languageFlag('2', size: 30),
                        Text(Funcoes().appLang('Spanish'),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: (language == 3) ? COR_04 : COR_02,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Funcoes().setLanguage(3);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: SizedBox(
                    width: largura * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Funcoes().languageFlag('3', size: 30),
                        Text(Funcoes().appLang('Marroquí'),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
