import 'dart:math';

import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:developer';

/* import 'anchored_adaptive_example.dart';
import 'fluid_example.dart';
import 'inline_adaptive_example.dart';
import 'native_template_example.dart';
 */
import 'inline_example.dart';

//import 'webview_example.dart';
const testDevice = 'YOUR_DEVICE_ID';

class AdPage extends StatefulWidget {
  /// The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize = AdSize.banner;
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-6464644953989525/1731618446'
      // ... or this one on iOS.
      : 'ca-app-pub-6464644953989525/1731618446';

  AdPage({super.key});
  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  // ignore: prefer_final_fields
  bool extended = false;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void initState() {
    super.initState();
    MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: [testDevice]));
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-6464644953989525/1171014118'
            : 'ca-app-pub-6464644953989525/1171014118',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    //screenH = MediaQuery.of(context).size.height;
    //screenW = MediaQuery.of(context).size.width;

    //final colorCCSE = COR_02;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 40,
        ),
        backgroundColor: COR_02b,
        //automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                _showInterstitialAd();
                setState(() {});
              },
              icon: Icon(Icons.select_all_rounded,
                  color: Colors.white, size: 30)),
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                Navigator.popUntil(context, (route) => route.isFirst);
              });
            },
          )
        ],
        title: Funcoes().logoWidget(opacity: 0),
      ),
      body: SafeArea(child: ReusableInlineExample()),
      bottomSheet: Container(
        width: screenW,
        height: screenH / 15,
        color: COR_02b,
      ),
    );
  }
}
