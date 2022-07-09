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
      title: 'CTA - Automatos',
      theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.black12,
            primarySwatch: Colors.green,
            cardColor: Colors.orange,
          )),
      home: const PaginaInicialBusca(title: 'AutonoJobs'),
    );
  }
}
