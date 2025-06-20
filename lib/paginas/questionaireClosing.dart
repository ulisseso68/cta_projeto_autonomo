// ignore: file_names
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/autonomo_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/services.dart';
//ignore: camel_case_types

class QuestionareClosing extends StatefulWidget {
  const QuestionareClosing({Key? key}) : super(key: key);

  @override
  State<QuestionareClosing> createState() => _QuestionareClosingState();
}

class _QuestionareClosingState extends State<QuestionareClosing> {
  final Autonomo autonomo = Funcoes.autonomoEscolhido;
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: altura * 0.1,
            ),
            ListTile(
              //  leading: Icon(Icons.info, size: 30),
              title: Text(
                Funcoes.categorySelected,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: COR_02),
              ),
              textColor: Colors.black54,
            ),
            const Divider(
              thickness: 5,
              height: 5,
              color: COR_02,
            ),
            Row(
              children: [
                Funcoes().KPIbox(largura, '$respostasCorretas',
                    Funcoes().appLang('Correct'), COR_02),
                Funcoes().KPIbox(
                    largura,
                    '${respostasCorretas + respostasErradas}',
                    Funcoes().appLang('Questions'),
                    Colors.grey),
              ],
            ),
            Row(
              children: [
                Funcoes().KPIbox(largura, '$respostasErradas',
                    Funcoes().appLang('Wrong'), Colors.grey),
                Funcoes().KPIbox(
                    largura,
                    '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}',
                    Funcoes().appLang('Success Rate'),
                    COR_02),
              ],
            ),
            const Divider(
              thickness: 5,
              height: 5,
              color: COR_02,
            ),
            Stack(children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: largura * 0.8,
                height: largura * 0.8,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(COR_02),
                  value: (respostasCorretas /
                      (respostasErradas + respostasCorretas)),
                  strokeWidth: 30,
                  color: COR_02,
                  semanticsValue:
                      '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}%',
                  backgroundColor: Colors.grey.withOpacity(0.3),
                ),
              ),
              SizedBox(
                width: largura * 0.8,
                height: largura * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(respostasCorretas / (respostasErradas + respostasCorretas) * 100).toInt()}',
                      style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Verdana',
                          color: COR_02),
                    ),
                    const Text(
                      '%',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Verdana',
                          color: COR_02),
                    ),
                  ],
                ),
              ),
            ]),
            const Divider(
              thickness: 1,
              height: 10,
              color: COR_02,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'homePage');
          //Navigator.pop(context);
          setState(() {});
        },
        backgroundColor: COR_02,
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
      ),
    );
  }
}
