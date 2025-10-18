import 'dart:async';

import 'package:ccse_mob/paginas/examClosing.dart';
import 'package:ccse_mob/paginas/pagina_creditos_projeto.dart';
import 'package:ccse_mob/paginas/learningPage.dart';
import 'package:ccse_mob/paginas/questionaireClosing.dart';
import 'package:ccse_mob/paginas/home.dart';
import 'package:ccse_mob/paginas/pagina_termos_privacidade.dart';
import 'package:ccse_mob/paginas/questionsExam.dart';
import 'package:ccse_mob/paginas/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'paginas/questionsPage1.dart';
import 'paginas/intersticial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //unawaited(MobileAds.instance.initialize());
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
