// ignore: file_names
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import 'dart:math';
//import 'package:flutter/services.dart';
//ignore: camel_case_types

class QuestionareClosing extends StatefulWidget {
  const QuestionareClosing({super.key});

  @override
  State<QuestionareClosing> createState() => _QuestionareClosingState();
}

class _QuestionareClosingState extends State<QuestionareClosing> {
  bool expanded = false;
  bool passed = false;
  Color mainColor = COR_02;
  Color adBackgroundColor = COR_02;
  Color adCallActionColor = COR_04;
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
            templateType: TemplateType.small,
            // Optional: Customize the ad's style.
            mainBackgroundColor: adBackgroundColor,
            cornerRadius: 20,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: adCallActionColor,
                style: NativeTemplateFontStyle.bold,
                size: 18.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                //backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                //backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 14.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                //backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 14.0)))
      ..load();
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
    loadAd();
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
        toolbarHeight: altura / 10,
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[COR_02, redEspana],
                ),
              ),
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
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'verdana',
                fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement your refresh logic here
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, left: 20, right: 20),
                child: Text(
                    Funcoes().appLang(
                        'You have finished your training. These are your results'),
                    style: TextStyle(
                        color: semaforoColor,
                        fontSize: 15,
                        fontFamily: 'verdana',
                        fontWeight: FontWeight.bold)),
              ),
              Stack(alignment: Alignment.center, children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  width: screenH * 0.3,
                  height: screenH * 0.3,
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
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                SizedBox(
                  width: screenH * 0.3,
                  height: screenH * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: semaforoColor,
                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: semaforoColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ConfettiWidget(
                    confettiController: confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [Colors.green, Colors.orange]),
              ]),
              SizedBox(
                height: altura * 0.02,
              ),
              Funcoes().KPIbox(
                  largura,
                  '${(Funcoes().statistics()['correct']! / Funcoes().statistics()['answered']! * 100).toInt()}',
                  Funcoes().appLang('Accumulated Success Rate'),
                  Funcoes().semaforo(Funcoes().statistics()['correct']! /
                      Funcoes().statistics()['answered']!),
                  icon: Icons.percent),
              if (Funcoes.categorySelected != examCat)
                Funcoes().KPIbox(
                    largura,
                    '${Funcoes().statistics()['answered']!}/${Funcoes().statistics()['total']!} ',
                    Funcoes().appLang('Answered Questions'),
                    Colors.grey,
                    icon: Icons.verified),
              Divider(
                height: altura * 0.02,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: (_nativeAdIsLoaded)
          ? Container(
              width: largura,
              height: altura / 5,
              //padding: const EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                border: Border(top: BorderSide(color: COR_02, width: 5)),
              ),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: AdWidget(ad: _nativeAd!)),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                border: Border(top: BorderSide(color: Colors.grey, width: 2)),
              ),
              width: largura,
              height: altura * 0.08,
            ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 20,
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        backgroundColor: (_nativeAdIsLoaded) ? COR_04 : Colors.grey,
        child: const Icon(Icons.home_filled, color: Colors.white, size: 40),
      ),
    );
  }
}
