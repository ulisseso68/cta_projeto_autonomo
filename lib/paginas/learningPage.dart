import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
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
  bool translateDescription = false;

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
                  (translatedDescription != "")
                      ? Positioned(
                          bottom: 8,
                          right: 8,
                          child: FloatingActionButton(
                              heroTag: 'translate_button',
                              shape: const StadiumBorder(),
                              backgroundColor: COR_04,
                              onPressed: () {
                                translateDescription = !translateDescription;
                                setState(() {});
                              },
                              child: Icon(Icons.translate_rounded,
                                  color: Colors.white, size: 30)))
                      : Container(),
                ])),
            Divider(
                thickness: 5.0,
                height: 5.0,
                color: (translateDescription) ? COR_04 : COR_01),
            ListTile(
              //  leading: Icon(Icons.info, size: 30),
              title: Text(
                (translateDescription)
                    ? translatedDescription
                    : currentQuestion.description.toString(),
                style: TextStyle(
                    color: (translateDescription) ? COR_04 : COR_01,
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
              textColor: Colors.black54,
            ),
            Divider(
                thickness: 1.0,
                height: 20.0,
                color: (translateDescription) ? COR_04 : COR_01,
                indent: 20,
                endIndent: 20),
            RatingBar(
                initialRating: 3,
                unratedColor: (translateDescription) ? COR_04 : COR_01,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: Icon(Icons.star,
                        color: (translateDescription) ? COR_04 : COR_01),
                    half: Icon(
                      Icons.star_half,
                      color: (translateDescription) ? COR_04 : COR_01,
                    ),
                    empty: Icon(
                      Icons.star_outline,
                      color: (translateDescription) ? COR_04 : COR_01,
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
            Divider(
                thickness: 1.0,
                height: altura / 10,
                color: Colors.white,
                indent: 20,
                endIndent: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'back_button',
        shape: const StadiumBorder(),
        backgroundColor: COR_02,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
      ),
    );
  }
}
