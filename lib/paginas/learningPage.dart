import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/models/question_model.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
//ignore: camel_case_types

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});
  // ignore: prefer_typing_uninitialized_variables

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  bool expanded = true;

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
            GestureDetector(
                onTap: () {
                  expanded = !expanded;
                  setState(() {});
                },
                child: Stack(children: [
                  Container(
                    alignment: Alignment.center,
                    height: (expanded ? altura / 2 : altura / 5),
                    child: CircularProgressIndicator(
                      color: COR_02,
                    ),
                  ),
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: (expanded ? altura / 2 : altura / 5),
                      width: largura,
                      child: Image(
                        image: currentQuestion.imagem(),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      )),
                ])),
            const Divider(thickness: 5.0, height: 5.0, color: COR_02),
            ListTile(
              //  leading: Icon(Icons.info, size: 30),
              title: Text(
                currentQuestion.description.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 18),
              ),
              textColor: Colors.black54,
            ),
            const Divider(
                thickness: 1.0,
                height: 20.0,
                color: COR_02,
                indent: 20,
                endIndent: 20),
            RatingBar(
                initialRating: 3,
                unratedColor: COR_02,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: COR_02),
                    half: const Icon(
                      Icons.star_half,
                      color: COR_02,
                    ),
                    empty: const Icon(
                      Icons.star_outline,
                      color: COR_02,
                    )),
                onRatingUpdate: (value) {
                  setState(() {
                    // create journal entry

                    CallApi().postDataWithHeaders('journals/process', {
                      'deviceid': deviceID,
                      'type': 'rating',
                      'value': value,
                      'description': currentQuestion.ccse_id
                    }, {
                      'Authorization': 'Bearer token'
                    });
                    // send rating to API
                    CallApi().postDataWithHeaders(
                        'questions/rating',
                        {'rating': value, 'ccse_id': currentQuestion.ccse_id},
                        {'Authorization': 'Bearer token'});
                    // show success message
                    CallApi().showAlert(
                        context,
                        Text(
                          Funcoes().appLang('Rating saved successfully'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        'OK');
                  });
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: COR_02,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
