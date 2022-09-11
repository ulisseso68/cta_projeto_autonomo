import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';

class AJDrawer extends StatelessWidget {
  AJDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: COR_LightGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Funcoes().splash(Funcoes.screenWidth * 0.85, Funcoes.screenHeight,
                fSize: 13),
            ListTile(
              leading: const Icon(
                Icons.facebook,
                size: 40,
                color: COR_04,
              ),
              title: const Text(
                'Blog no faceboog',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_04, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(urlfacebook);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                size: 40,
                color: COR_04,
              ),
              title: const Text(
                'O Projeto AutonoJobs',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_04, fontSize: 14),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'paginaCreditos');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip,
                size: 40,
                color: COR_04,
              ),
              title: const Text(
                'Termos de Uso e Privacidade',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_04, fontSize: 14),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'termosUsoPrivacidade');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.work,
                size: 40,
                color: COR_04,
              ),
              title: const Text(
                'Cadastre-se como Autonomo',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_04, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(urlCadastro);
              },
            )
          ],
        ));
  }
}
