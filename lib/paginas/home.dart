import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:ccse_mob/paginas/drawer.dart';
import 'package:flutter/material.dart';
import 'package:ccse_mob/funcoes/fAPI.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
// For AdMob
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:ccse_mob/paginas/consent_manager.dart';

class HomePage extends StatefulWidget {
  final AdSize adSize = AdSize.largeBanner;
  HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_final_fields
  List _categoriesSelected = [];
  List<bool> _isOpen = [];
  bool practiceTileDetailed = false;
  bool flashCardsDetailed = false;
  BannerAd? _bannerAd;
  String _authStatus = 'Unknown'; //is used
  String adUnitId = '';
  bool adLoaded = false;
  final _consentManager = ConsentManager();
  var _isMobileAdsInitializeCalled = false;
  var _isPrivacyOptionsRequired = false;

  @override
  initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => initPlugin());
    _getDatafromServer();
  }

  @override
  void dispose() {
    adLoaded = false;
    _bannerAd?.dispose();
    super.dispose();
  }

  // Open and Close categories
  void collapse(int index) {
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
    await Funcoes().loadDescriptionsTranslationsFromStorage();
    //await Funcoes().getAdUnitsFromServer();

    await Funcoes().configureAppForDeveloperMode(modoDeveloper);

    adUnitId = Platform.isAndroid ? bannerAdUnitIdAndroid : bannerAdUnitIdIOS;

    //included in the getDatafromServer with updates all data, including adUnitId
    //print('Ad Unit ID: $adUnitId');
    _bannerAd?.dispose();
    _loadAd();
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
    setState(() {});
  }

  void updateStatus() {
    //update other Things if needed - Ads??
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

  /// Procedures related to Ad load, and Consent

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      // await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      // await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }
    uuid = await AppTrackingTransparency.getAdvertisingIdentifier();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        /* debugPrint(
          "${consentGatheringError.errorCode}: ${consentGatheringError.message}",
        ); */
      }

      // Check if a privacy options entry point is required.
      _getIsPrivacyOptionsRequired();

      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();
  }

  void _getIsPrivacyOptionsRequired() async {
    if (await _consentManager.isPrivacyOptionsRequired()) {
      setState(() {
        _isPrivacyOptionsRequired = true;
      });
    }
  }

  /// Initialize the Mobile Ads SDK if the SDK has gathered consent aligned with
  /// the app's configured messages.
  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await _consentManager.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;

      // [START initialize_sdk]
      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();
      /* MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
          testDeviceIds: ['942369E6-A921-4F72-8AD3-817BC4500355'])); */
      // [END initialize_sdk]

      // Load an ad.
      //_loadAd();
    }
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(Funcoes().appLang('Dear User')),
          content: Text(Funcoes().appLang('trckMsg')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Funcoes().appLang('Continue')),
            ),
          ],
        ),
      );

  void _loadAd() {
    if (adUnitId != '') {
      // Create a BannerAd
      /* print('Loading Ad: $adUnitId'); */
      final bannerAd = BannerAd(
        size: widget.adSize,
        adUnitId: adUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            if (!mounted) {
              adLoaded = false;
              ad.dispose();
              return;
            }
            setState(() {
              _bannerAd = ad as BannerAd;
              adLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, error) {
            adLoaded = false;
            /* debugPrint('BannerAd failed to load: $error'); */
            ad.dispose();
          },
        ),
      );
      // Start loading.
      bannerAd.load();
    } else {
      /* debugPrint('Ad Unit ID is empty. Ad will not be loaded.'); */
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
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 40,
        ),
        toolbarHeight: altura / 10,
        title: Row(
          children: [
            Funcoes().logoWidget(opacity: 0),
          ],
        ),
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
          //_bannerAd?.dispose();
          //_loadAd();
          return _getDatafromServer();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),

                //Simulation Exam Button
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
                        //height: altura / 10,
                        width: largura - 20,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          color: COR_02,
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
                                Funcoes().appLang('CCSE Exam Simulation'),
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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

                //Ad Banner
                if (adLoaded)
                  Container(
                    height: _bannerAd!.size.height.toDouble() + 6,
                    width: largura,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: Colors.grey.shade400,
                      border: Border.all(
                        color: COR_02,
                        width: 1,
                      ),
                    ),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                //Divider
                Divider(
                  color: COR_02,
                  height: 30,
                  thickness: 1,
                ),
                //Title - Study by Category
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    Funcoes().appLang('Practice by Category'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                      //backgroundColor: Colors.white,
                      //heroTag: 'btnInfo',
                      onPressed: () {
                        setState(() {
                          practiceTileDetailed = !practiceTileDetailed;
                        });
                      },
                      icon: Icon(
                        size: 30,
                        color: Colors.grey,
                        (!practiceTileDetailed)
                            ? Icons.info_rounded
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
                //Divider
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
                    Funcoes().appLang('Practice Cards'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          flashCardsDetailed = !flashCardsDetailed;
                        });
                      },
                      icon: Icon(
                        size: 30,
                        color: Colors.grey,
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
                          currentQuestion = learnings[index];
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
                                  Container(
                                      width: screenW * 0.4,
                                      decoration: const BoxDecoration(
                                        color: COR_02,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )),
                                  Container(
                                    width: screenW * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
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
                  color: COR_02,
                ),
                Funcoes().logoWidget(opacity: 0, letterColor: Colors.grey),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade300,
        height: 15,
        child: Divider(
          color: COR_02,
          thickness: 5,
        ),
      ),
      floatingActionButton: (developerMode)
          ? FloatingActionButton(
              shape: const StadiumBorder(),
              onPressed: () {
                MobileAds.instance.openAdInspector((error) {
                  // Error will be non-null if ad inspector closed due to an error.
                  if (error != null) {
                    CallApi().showAlert(
                        context,
                        Text(
                            'Ad Inspector closed with error: ${error.code} • ${error.message}'),
                        'OK');
                  }
                });
              },
              backgroundColor: COR_dev,
              child: Icon(Icons.ad_units, color: Colors.white),
            )
          : null,
    );
  }

  //Builds the list of tiles for the categories
  Widget _buildListTile() {
    List<Widget> listTiles = [];
    //Color catTileColor = Colors.grey.shade100;

    for (int i = 1; i < _categoriesSelected.length; i++) {
      String catsel = _categoriesSelected[i];
      int qty = Funcoes().selectQuestions(catsel).length;

      // Skip the test category
      if (qty > 0) {
        listTiles.add(Container(
          //width: screenW * 0.90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: (_isOpen[i]) ? 2 : 1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: Colors.white,
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
                          numberOfQuestions = 10;
                          await Navigator.pushNamed(context, 'questionsPage1')
                              .then((value) {
                            //This callback is executed when returning from the questions page
                            updateStatus();
                          });
                        },
                        child: Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.rocket_launch,
                                color: Colors.white, size: 18),
                            Text(Funcoes().appLang("Quick"),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ],
                        ),
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
                        child: Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.self_improvement,
                                color: Colors.white, size: 20),
                            Text(Funcoes().appLang("All"),
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ],
                        ),
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
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.rule,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(Funcoes().appLang("Review"),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)),

                              /* Text(
                                  Funcoes()
                                      .wronglyAnsweredQuestions(category)
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white)), */
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
            //padding: EdgeInsets.all(8.0),
            height: altura * 0.50,
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
