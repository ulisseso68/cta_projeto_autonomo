import 'package:cta_projeto_autonomo/paginas/pagina_creditos_projeto.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_detalhe_autonomo.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_lista_autonomos.dart';
import 'package:cta_projeto_autonomo/paginas/home.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_termos_privacidade.dart';
import 'package:flutter/material.dart';
import 'paginas/pagina_inicial_busca.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.1);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          child: child!,
        );
      },
      title: 'AppName',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        backgroundColor: Colors.black12,
        primarySwatch: Colors.orange,
        cardColor: Colors.red,
      )),
      routes: {
        'homePage': ((context) => const HomePage()),
        'selecionaAtividade': ((context) => const PaginaInicialBusca()),
        'listaAutonomos': ((context) => const PaginaListaAutonomos()),
        'detalheAutonomo': ((context) => const PaginaDetalheAutonomo()),
        'paginaCreditos': (context) => const PaginaCreditoProjeto(),
        'termosUsoPrivacidade': (context) => const PaginaTermosUsoPrivacidade(),
      },
      initialRoute: 'homePage',
    );
  }
}
