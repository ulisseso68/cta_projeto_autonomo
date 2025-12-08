// ignore: file_names
import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
//import 'dart:math';

class QuestionareClosing extends StatefulWidget {
  const QuestionareClosing({super.key});

  @override
  State<QuestionareClosing> createState() => _QuestionareClosingState();
}

class _QuestionareClosingState extends State<QuestionareClosing> {
  bool expanded = false;
  bool passed = false;
  Color mainColor = COR_02;
  Color adBackgroundColor = Colors.grey.shade200;
  Color adCallActionColor = COR_02;
  Color semaforoColor = Funcoes()
      .semaforo(respostasCorretas / (respostasErradas + respostasCorretas));
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId =
      Platform.isAndroid ? nativeAdUnitIdAndroid : nativeAdUnitIdIOS;

  ConfettiController confettiController = ConfettiController(
    duration: const Duration(seconds: 5),
  );

  void loadAd() {
    if (_adUnitId != '' && !isPremiumUser) {
      _nativeAd = NativeAd(
          adUnitId: _adUnitId,
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              //debugPrint('$NativeAd loaded.');
              setState(() {
                _nativeAdIsLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {
              // Dispose the ad here to free resources.
              //debugPrint('$NativeAd failed to load: $error');
              ad.dispose();
            },
          ),
          request: const AdRequest(),
          // Styling
          nativeTemplateStyle: NativeTemplateStyle(
              // Required: Choose a template.
              templateType: TemplateType.medium,
              // Optional: Customize the ad's style.
              mainBackgroundColor: adBackgroundColor,
              cornerRadius: 10,
              callToActionTextStyle: NativeTemplateTextStyle(
                  textColor: Colors.white,
                  backgroundColor: adCallActionColor,
                  style: NativeTemplateFontStyle.bold,
                  size: 18.0),
              primaryTextStyle: NativeTemplateTextStyle(
                  textColor: semaforoColor,
                  //backgroundColor: Colors.cyan,
                  style: NativeTemplateFontStyle.bold,
                  size: 16.0),
              secondaryTextStyle: NativeTemplateTextStyle(
                  textColor: semaforoColor,
                  //backgroundColor: Colors.black,
                  style: NativeTemplateFontStyle.bold,
                  size: 14.0),
              tertiaryTextStyle: NativeTemplateTextStyle(
                  textColor: semaforoColor,
                  //backgroundColor: Colors.amber,
                  style: NativeTemplateFontStyle.normal,
                  size: 14.0)))
        ..load();
    }
  }

  @override
  void dispose() {
    confettiController.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!isPremiumUser) loadAd();
    if (respostasCorretas / (respostasCorretas + respostasErradas) >= 0.60) {
      confettiController.play();
      passed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: altura / 15,
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: mainColor,
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
        title: Text(Funcoes().shortCat(Funcoes.categorySelected),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontSize: altura / 15 / 3,
                fontFamily: 'verdana',
                fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement your refresh logic here
        },
        child: SizedBox(
          height: altura * 13 / 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Questionaire Results
              Container(
                margin: EdgeInsets.all(altura / 15 / 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                //color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(altura / 15 / 5),
                      child: Text(
                          Funcoes().appLang(
                              'You have finished your training. These are your results'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: semaforoColor,
                              fontSize: altura / 15 / 3 * 0.65,
                              fontFamily: 'verdana',
                              fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(alignment: Alignment.center, children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: screenH * 0.20,
                            height: screenH * 0.20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                semaforoColor,
                              ),
                              value: (respostasCorretas /
                                  (respostasErradas + respostasCorretas)),
                              strokeWidth: 30,
                              color: semaforoColor,
                              semanticsValue:
                                  '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}%',
                              backgroundColor: Colors.grey.shade400,
                            ),
                          ),
                          SizedBox(
                            width: screenH * 0.20,
                            height: screenH * 0.20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: semaforoColor,
                                  ),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: semaforoColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ConfettiWidget(
                              confettiController: confettiController,
                              blastDirectionality:
                                  BlastDirectionality.explosive,
                              shouldLoop: false,
                              colors: const [Colors.green, Colors.orange]),
                        ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Funcoes().KPIbox(
                                largura * 0.52,
                                '${(Funcoes().statistics()['correct']! / Funcoes().statistics()['answered']! * 100).toInt()}',
                                Funcoes().appLang('Accumulated Success Rate'),
                                Funcoes().semaforo(
                                    Funcoes().statistics()['correct']! /
                                        Funcoes().statistics()['answered']!),
                                icon: Icons.percent),
                            Funcoes().KPIbox(
                                largura * 0.52,
                                '${Funcoes().statistics()['answered']!}/${Funcoes().statistics()['total']!} ',
                                Funcoes().appLang('Answered Questions'),
                                Colors.grey,
                                icon: Icons.verified),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Advertisement if available
              (_nativeAdIsLoaded && !isPremiumUser)
                  ? Container(
                      color: Colors.white,
                      height: altura * 0.44,
                      width: (largura > altura) ? altura * 0.7 : largura,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              color: adBackgroundColor,
                              width: largura,
                              height: altura * 0.42,
                              child: AdWidget(ad: _nativeAd!)),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: altura * 0.44,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: largura - 20,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Funcoes().progressBar(barSize: 0.9)),
                            if (!isPremiumUser)
                              SizedBox(
                                  width: largura * 0.9,
                                  child: Funcoes().wFirstPartyAd(context)),
                          ])),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Funcoes().uxBottomBar(
        SharePlus.instance,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 20,
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        backgroundColor: (_nativeAdIsLoaded) ? COR_04 : COR_04,
        child: const Icon(Icons.home_filled, color: Colors.white, size: 40),
      ),
    );
  }
}
