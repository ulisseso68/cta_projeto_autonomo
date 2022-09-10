import 'package:cta_projeto_autonomo/paginas/pagina_detalhe_autonomo.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_lista_autonomos.dart';
import 'package:cta_projeto_autonomo/paginas/pagina_selecao_cidade.dart';
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
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        );
      },
      title: 'AutonoJobs',
      theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.black12,
            primarySwatch: Colors.green,
            cardColor: Colors.orange,
          )),
      routes: {
        'selecionaCidade': ((context) => const PaginaSelecaoCidade()),
        'selecionaAtividade': ((context) => const PaginaInicialBusca()),
        'listaAutonomos': ((context) => const PaginaListaAutonomos()),
        'detalheAutonomo': ((context) => const PaginaDetalheAutonomo()),
      },
      initialRoute: 'selecionaCidade',
      /* home: const PaginaSelecaoCidade(title: 'AutonoJobs'), */
    );
  }
}
