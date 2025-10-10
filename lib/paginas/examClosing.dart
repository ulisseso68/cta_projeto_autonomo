// ignore: file_names
import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

//import 'package:flutter/services.dart';
//ignore: camel_case_types

class ExamClosing extends StatefulWidget {
  const ExamClosing({super.key});

  @override
  State<ExamClosing> createState() => _ExamClosingState();
}

class _ExamClosingState extends State<ExamClosing> {
  bool expanded = false;
  bool passed = false;

  ConfettiController confettiController = ConfettiController(
    duration: const Duration(seconds: 5),
  );

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (respostasCorretas / (respostasCorretas + respostasErradas) >= 0.60) {
      confettiController.play();
      passed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double altura = MediaQuery.of(context).size.height;
    final double largura = MediaQuery.of(context).size.width;
    final Color resultColor = (respostasCorretas >= 15) ? COR_04 : redEspana;

    return Scaffold(
      bottomSheet: SizedBox(
        height: altura * 0.20,
        width: largura,
        //color: Colors.white,
        child: Column(
          children: [
            Funcoes().KPIbox(
                largura,
                Funcoes()
                    .appLang((respostasCorretas >= 15) ? 'PASSED' : 'FAILED'),
                Funcoes().appLang((respostasCorretas >= 15)
                    ? 'CONGRATULATIONS'
                    : 'PRACTICE MORE'),
                (respostasCorretas >= 15) ? COR_04 : redEspana,
                icon: (respostasCorretas >= 15)
                    ? Icons.thumb_up
                    : Icons.thumb_down),
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
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Funcoes().shortCat(examCat),
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Verdana',
                        fontWeight: FontWeight.bold,
                        color: (respostasCorretas >= 15) ? COR_04 : redEspana),
                  ),
                  Divider(
                    color: (respostasCorretas >= 15) ? COR_04 : redEspana,
                    thickness: 1,
                  ),
                ],
              ),
              subtitle: Text(
                Funcoes().appLang('You have finished your exam:'),
                style: TextStyle(
                  fontSize: 20,
                  color: (respostasCorretas >= 15) ? COR_04 : redEspana,
                ),
              ),
            ),
            SizedBox(
              height: altura * 0.1,
            ),
            Stack(alignment: Alignment.center, children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: screenH * 0.35,
                height: screenH * 0.35,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                  value: (respostasCorretas /
                      (respostasErradas + respostasCorretas)),
                  strokeWidth: 30,
                  color: resultColor,
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
                      style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color:
                              (respostasCorretas >= 15) ? COR_04 : redEspana),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Funcoes().semaforo(respostasCorretas /
                            (respostasErradas + respostasCorretas)),
                      ),
                    ),
                  ],
                ),
              ),
              ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.green, Colors.orange]),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        elevation: 20,
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          setState(() {});
        },
        backgroundColor: COR_02,
        child: const Icon(Icons.home_filled, color: Colors.white, size: 30),
      ),
    );
  }
}
