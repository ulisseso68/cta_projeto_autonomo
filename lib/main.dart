import 'dart:async';

import 'package:cta_projeto_autonomo/paginas/examClosing.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_creditos_projeto.dart';
import 'package:cta_projeto_autonomo/paginas/learningPage.dart';
import 'package:cta_projeto_autonomo/paginas/questionaireClosing.dart';
import 'package:cta_projeto_autonomo/paginas/home.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_termos_privacidade.dart';
import 'package:cta_projeto_autonomo/paginas/questionsExam.dart';
import 'package:cta_projeto_autonomo/paginas/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'paginas/questionsPage1.dart';
import 'paginas/intersticial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
/*   MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: ['942369E6-A921-4F72-8AD3-817BC4500355'])); */
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        // ignore: deprecated_member_use
        final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.1);
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
      },
      title: 'CCSE Fácil',
      theme: ThemeData(
          drawerTheme: DrawerThemeData(
              backgroundColor: Colors.white,
              elevation: 5,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.white,
              shape: Border(
                right: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              )),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(),
          fontFamily: 'Verdana',
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor: Colors.white,
              primarySwatch: Colors.grey,
              cardColor: Colors.white,
              accentColor: Colors.grey)),
      routes: {
        'homePage': ((context) => HomePage()),
        'adPage': ((context) => AdPage()),
        'questionsPage1': ((context) => const QuestionsPage1()),
        'questionsExam': ((context) => const QuestionsExam()),
        'questionsClosing': ((context) => const QuestionareClosing()),
        'learningPage': ((context) => const LearningPage()),
        'paginaCreditos': (context) => const PaginaCreditoProjeto(),
        'termosUsoPrivacidade': (context) => const PaginaTermosUsoPrivacidade(),
        'splashPage': (context) => const SplashPage(),
        'examClosing': (context) => const ExamClosing(),
      },
      initialRoute: 'homePage',
    );
  }
}
