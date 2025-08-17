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
  bool practiceTileDetailed = false;

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

                //header
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
                        width: largura * 0.6,
                        height: altura / 12,
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
                              leading: Icon(
                                Icons.edit_note,
                                color: Colors.white,
                                size: 40,
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
                    // Container for the language button
                    GestureDetector(
                      onTap: () async {
                        // Handle language change
                        uxToChangeLanguage(context, altura, largura);
                      },
                      child: Container(
                        width: largura * 0.32,
                        height: altura / 12,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade400, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.translate_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Funcoes().languageFlag(language.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //Divider
                Divider(
                  color: Colors.transparent,
                  height: 10,
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
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  trailing: IconButton(
                      color: COR_02,
                      onPressed: () {
                        setState(() {
                          practiceTileDetailed = !practiceTileDetailed;
                        });
                      },
                      icon: Icon(
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
                      : Divider(
                          color: COR_02,
                          height: 10,
                          thickness: 1,
                        ),
                ),

                //List of categories
                _buildListTile(),

                Divider(
                  thickness: 1,
                  height: 30,
                  indent: 10,
                  endIndent: 10,
                  color: COR_02,
                ),
                Funcoes().logoWidget(
                    fontSize: 20, opacity: 0, letterColor: Colors.grey),
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

    for (int i = 1; i < _categoriesSelected.length; i++) {
      String catsel = _categoriesSelected[i];
      int qty = Funcoes().selectQuestions(catsel).length;

      // Skip the test category
      listTiles.add(Container(
        //width: screenW * 0.95,
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  (_isOpen[i]) ? Colors.orange.shade200 : Colors.grey.shade300,
              width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: _isOpen[i] ? Colors.orange.shade100 : Colors.grey.shade100,
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
          subtitle:
              questionaryOptions(_isOpen[i], qty.toString(), catsel, context),
          leading: (i != 0)
              ? Stack(
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
                                (catsel == examCat)
                                    ? Icons.edit_document
                                    : Icons.auto_stories,
                                color: Colors.grey,
                                size: 20,
                              )
                            : Container(
                                width: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: (i > 0) ? COR_02 : Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: (i > 0)
                                    ? Text((i).toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : Icon(
                                        Icons.verified,
                                        color: redEspana,
                                        size: 20,
                                      ),
                              )),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      collapse(i);
                    }); // Handle tap
                  },
                  child: Container(
                    width: screenW / 10,
                    height: screenW / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: redEspana,
                    ),
                    child: Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
        ),
      ));

      /* if (catsel == examCat) {
        listTiles.add(
          Divider(
            color: COR_02,
            height: 10,
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
        );
        listTiles.add(
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(Funcoes().appLang('Practice'),
                style: const TextStyle(
                    fontSize: 20, color: COR_02, fontWeight: FontWeight.bold)),
            subtitle: (practiceTileDetailed)
                ? Text(
                    Funcoes().appLang(
                        'You can chose how many questions to practice, and will have: Immediate validation of your response, knowledge cards to help you memorize, and translation to your language if you want.'),
                    style: TextStyle(fontSize: 12, color: Colors.grey))
                : null,
            trailing: IconButton(
              icon: Icon(
                (practiceTileDetailed)
                    ? Icons.arrow_drop_up_rounded
                    : Icons.info,
                color: COR_02,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  practiceTileDetailed = !practiceTileDetailed;
                });
              },
            ),
          ),
        );
      } */
    }

    return Column(
      spacing: 10,
      children: listTiles,
    );
  }

  //build the expanded view of each tile
  Widget questionaryOptions(
      bool isOpen, String title, String category, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: (category == examCat)
              ? redEspana
              : Color.fromRGBO(255, 224, 178, 1),
          thickness: 1,
          height: 10,
        ),
        !isOpen
            ? Text(
                (category == examCat)
                    ? "25 ${Funcoes().appLang("questions from all categories.")}"
                    : "${Funcoes().appLang('Practice')} $title ${Funcoes().appLang("Questions")}",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  color: (category == examCat) ? redEspana : COR_02,
                ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (category == examCat)
                      ? Text(
                          Funcoes().appLang(
                              'The CCSE exam includes 25 questions extracted from the 300 exercises of the CCSE learning manual. You will have 45 minutes to complete it, and needs to respond correctly to at least 15 questions to pass.'),
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[600]),
                        )
                      : Container(),
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
