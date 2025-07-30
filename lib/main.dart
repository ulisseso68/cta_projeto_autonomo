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
import 'paginas/questionsPage1.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          fontFamily: 'Verdana',
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.black12,
            primarySwatch: Colors.yellow,
            cardColor: Colors.white,
          )),
      routes: {
        'homePage': ((context) => const HomePage()),
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
