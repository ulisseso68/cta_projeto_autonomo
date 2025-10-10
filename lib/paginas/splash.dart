import 'package:ccse_mob/funcoes/fAPI.dart';
import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
//import 'package:device_info_plus/device_info_plus.dart';
//import 'dart:io';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // ignore: prefer_final_fields

  bool extended = true;

  @override
  initState() {
    super.initState();
    /*  _getDataFromStorage(); */
  }

  @override
  Widget build(BuildContext context) {
    screenH = MediaQuery.of(context).size.height;
    screenW = MediaQuery.of(context).size.width;

    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;
    bool openDetails = true;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: developerMode ? Colors.purple : redEspana,
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        toolbarHeight: altura * 0.30,
        flexibleSpace: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            SizedBox(
              width: largura,
              height: 10,
            ),
            Positioned(
              height: altura * 0.25,
              bottom: 0,
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    Funcoes().toggleDeveloperMode();
                  });
                },
                child: Center(
                    child: Hero(
                  tag: 'splash_image',
                  child: Image(
                    image: AssetImage('img/CCSELogo.png'),
                    fit: BoxFit.contain,
                  ),
                )),
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
            color: redEspana,
          ),
          // Config
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              Funcoes()
                  .appLang((tcsAccepted) ? 'Configurations' : 'Terms of use'),
              style: const TextStyle(
                  fontSize: 20,
                  color: redEspana,
                  fontWeight: FontWeight.normal),
            ),
            subtitle: Text(
              Funcoes().appLang((tcsAccepted) ? 'msg_config' : 'msg_terms'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            leading: IconButton(
              icon: const Icon(Icons.settings, color: redEspana, size: 30),
              onPressed: () {
                openDetails = !openDetails;
                setState(() {});
              },
            ),
          ),
          Divider(
            color: redEspana,
            height: 1,
            thickness: 1,
          ),

          // Terms and Conditions
          (!tcsAccepted)
              ? ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    Funcoes().appLang('Terms of Use'),
                    style: const TextStyle(
                        fontSize: 20,
                        color: COR_02,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    !tcsAccepted
                        ? Funcoes().appLang('Accept the terms to continue')
                        : Funcoes().appLang('Accepted'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      setState(() {
                        tcsAccepted = !tcsAccepted;
                        if (tcsAccepted) {
                          CallApi().createJournalEntry(
                              type: 'terms',
                              value: 1,
                              description: 'user accepted');
                        } else {
                          CallApi().createJournalEntry(
                              type: 'terms',
                              value: 0,
                              description: 'user rejected');
                        }
                        Funcoes().setTcsAcceptedToStorage(tcsAccepted);
                      });
                    },
                    icon: tcsAccepted
                        ? const Icon(Icons.check_circle,
                            color: COR_02, size: 30)
                        : const Icon(Icons.check_circle_outline,
                            color: COR_02, size: 30),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.read_more, color: COR_01, size: 30),
                    onPressed: () {
                      CallApi().launchUrlOut(
                          'https://app.ccsefacil.es/terms-of-service/es');
                    },
                  ),
                )
              : Container(),

          // Citizenship Selection
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              citizenship == ""
                  ? Funcoes().appLang('Select your country:')
                  : citizenship,
              style: const TextStyle(
                  fontSize: 20, color: COR_02, fontWeight: FontWeight.normal),
            ),
            subtitle: citizenship != ""
                ? Text(
                    Funcoes().appLang('Your Country of Citizenship'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : null,
            trailing: citizenship == ""
                ? const Icon(Icons.flag, color: COR_02, size: 30)
                : Text(
                    countryFlag,
                    style: const TextStyle(fontSize: 30),
                  ),
            leading: IconButton(
              icon: citizenship == ""
                  ? Icon(Icons.arrow_forward_ios, color: COR_02, size: 30)
                  : Icon(Icons.change_circle_rounded, color: COR_02, size: 30),
              onPressed: () {
                showCountryPicker(
                    context: context,
                    exclude: [
                      'ES', // Spain
                    ],
                    favorite: const [
                      'US',
                      'CO',
                      'MA',
                      'AR',
                      'MX',
                      'PE',
                      'BR',
                      'PT',
                    ], // Brazil, Portugal, USA, Morocco
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      bottomSheetHeight:
                          altura / 2, // Optional. Country list modal height
                      //Optional. Sets the border radius for the bottomsheet.
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      //Optional. Styles the search field.
                      inputDecoration: InputDecoration(
                        labelText: Funcoes().appLang('Search'),
                        hintText: Funcoes().appLang('Start typing to search'),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: COR_02,
                          ),
                        ),
                      ),
                    ),
                    onSelect: (Country country) {
                      Funcoes().setCountry(country.name, country.flagEmoji);
                      CallApi().createJournalEntry(
                          type: 'citizenship',
                          value: 1,
                          description: country.name);
                      setState(() {});
                    });
              },
            ),
          ),

          // User Name
          (getName)
              ? ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    userName == ""
                        ? Funcoes().appLang('Enter your name')
                        : userName,
                    style: const TextStyle(
                        fontSize: 20,
                        color: COR_02,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    Funcoes().appLang('Your Name'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.person, color: COR_01, size: 30),
                  leading: IconButton(
                    icon: const Icon(Icons.edit, color: COR_02, size: 30),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(Funcoes().appLang('Enter your name'),
                                style: const TextStyle(
                                    fontSize: 20, color: COR_02)),
                            content: TextField(
                              onChanged: (value) {
                                userName = value;
                                setState(() {
                                  Funcoes().setUserName(userName);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: userName.isEmpty
                                    ? Funcoes().appLang('Your Name')
                                    : userName,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  //color: COR_02,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: COR_02),
                                  child: Text(Funcoes().appLang('Save'),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              : Container(),

          // Language Selection
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              Funcoes().languageName,
              style: const TextStyle(
                  fontSize: 20, color: COR_02, fontWeight: FontWeight.normal),
            ),
            subtitle: Text(
              Funcoes().appLang('Language for translation'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            trailing:
                const Icon(Icons.translate_rounded, color: COR_01, size: 30),
            leading: IconButton(
              icon: const Icon(Icons.change_circle_rounded,
                  color: COR_02, size: 30),
              onPressed: () {
                uxToChangeLanguage(context, altura, largura);
                /* showDialog(
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
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    (language == 0) ? COR_04 : COR_02,
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
                                child: Text(Funcoes().appLang('English'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    (language == 1) ? COR_04 : COR_02,
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
                                child: Text(Funcoes().appLang('Portuguese'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    (language == 2) ? COR_04 : COR_02,
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
                                child: Text(Funcoes().appLang('Spanish'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    (language == 3) ? COR_04 : COR_02,
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
                                child: Text(Funcoes().appLang('Marroquí'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
               */
              },
            ),
          ),

          // Zero Statistics
          (Funcoes().existsAnyAnsweredQuestion())
              ? ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    Funcoes().appLang('Reset statistics'),
                    style: const TextStyle(
                        fontSize: 20,
                        color: COR_02,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    Funcoes().appLang('Re-start the statistics'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.trending_up_rounded,
                      color: COR_01, size: 30),
                  leading: IconButton(
                    icon: Icon(Icons.restart_alt_rounded,
                        color: COR_02, size: 30),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(Funcoes().appLang('Confirm Reset'),
                              style:
                                  const TextStyle(fontSize: 20, color: COR_02)),
                          content: Text(
                            Funcoes().appLang(
                                'Are you sure you want to reset the statistics?'),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                //print('Resetting statistics...');
                                tcsAccepted = false;
                                Funcoes().setTcsAcceptedToStorage(tcsAccepted);
                                await Funcoes().deleteAnsweredQuestions();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: COR_02),
                                child: Text(Funcoes().appLang('Reset'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(Funcoes().appLang('Cancel'),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.grey)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Container(),
          (modoDeveloper)
              ? Divider(
                  color: COR_dev,
                  height: 1,
                  thickness: 1,
                )
              : Container(),
          (modoDeveloper)
              ? ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    'Ad UUID',
                    style: const TextStyle(
                        fontSize: 20,
                        color: COR_dev,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    uuid,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  /* trailing:
                      const Icon(Icons.developer_mode, color: COR_01, size: 30), */
                  leading: IconButton(
                    icon:
                        Icon(Icons.confirmation_num, color: COR_dev, size: 30),
                    onPressed: () => {},
                  ),
                )
              : Container(),
          (modoDeveloper)
              ? ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    'AdUnit Banner',
                    style: const TextStyle(
                        fontSize: 20,
                        color: COR_dev,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    deviceType == 'iOS'
                        ? bannerAdUnitIdIOS
                        : bannerAdUnitIdAndroid,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  /* trailing:
                      const Icon(Icons.developer_mode, color: COR_01, size: 30), */
                  leading: IconButton(
                    icon: Icon(Icons.ad_units, color: COR_dev, size: 30),
                    onPressed: () => {},
                  ),
                )
              : Container(),
          (modoDeveloper)
              ? ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    'AdUnit Native',
                    style: const TextStyle(
                        fontSize: 20,
                        color: COR_dev,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text(
                    deviceType == 'iOS'
                        ? nativeAdUnitIdIOS
                        : nativeAdUnitIdAndroid,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  /* trailing:
                      const Icon(Icons.developer_mode, color: COR_01, size: 30), */
                  leading: IconButton(
                    icon: Icon(Icons.ad_units, color: COR_dev, size: 30),
                    onPressed: () => {},
                  ),
                )
              : Container(),
          SizedBox(height: altura * 0.1),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        onPressed: () {
          if (tcsAccepted && citizenship.isNotEmpty) {
            Navigator.popUntil(context, (ModalRoute.withName('homePage')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: COR_02,
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
                content: Text(Funcoes().appLang('Please complete all fields')),
                duration: const Duration(seconds: 3),
              ),
            );
            return;
          }
          Navigator.pushNamed(context, 'homePage');
        },
        backgroundColor: COR_02,
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
      ),
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
            height: altura * 0.35,
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
