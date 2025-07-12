// ignore: file_names
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/services.dart';
//ignore: camel_case_types

class QuestionareClosing extends StatefulWidget {
  const QuestionareClosing({super.key});

  @override
  State<QuestionareClosing> createState() => _QuestionareClosingState();
}

class _QuestionareClosingState extends State<QuestionareClosing> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomSheet: SizedBox(
        height: altura * 0.30,
        width: largura,
        //color: Colors.white,
        child: Column(
          children: [
            Funcoes().KPIbox(
                largura,
                '${(Funcoes().statistics()['correct']! / Funcoes().statistics()['answered']! * 100).toInt()}',
                Funcoes().appLang('Accumulated Success Rate'),
                COR_02,
                icon: Icons.percent),
            Funcoes().KPIbox(
                largura,
                '${Funcoes().statistics()['answered']!}/${Funcoes().statistics()['total']!} ',
                Funcoes().appLang('Answered Questions'),
                Colors.grey,
                icon: Icons.verified),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: altura * 0.08,
            ),
            Funcoes().titleWithIcon(
                Funcoes.categorySelected,
                Funcoes().appLang(
                    'You have finished your training. These are your results'),
                context,
                isOpen: true,
                hasIcon: false),
            Stack(alignment: Alignment.center, children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: screenH * 0.35,
                height: screenH * 0.35,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(COR_02),
                  value: (respostasCorretas /
                      (respostasErradas + respostasCorretas)),
                  strokeWidth: 30,
                  color: COR_02,
                  semanticsValue:
                      '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}%',
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(
                width: screenH * 0.35,
                height: screenH * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}',
                      style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: COR_02),
                    ),
                    const Text(
                      '%',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: COR_02),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        onPressed: () {
          Navigator.pushNamed(context, 'homePage');
          //Navigator.pop(context);
          setState(() {});
        },
        backgroundColor: COR_02,
        child: const Icon(Icons.home_filled, color: Colors.white, size: 30),
      ),
    );
  }
}
