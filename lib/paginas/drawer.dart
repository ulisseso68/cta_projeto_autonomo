import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';

class AJDrawer extends StatelessWidget {
  const AJDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenH / 5,
              color: COR_02,
              child: Center(
                child: Funcoes().logoWidget(fontSize: 30, opacity: 0.05),
              ),
            ),
            Container(
              height: 5,
              color: redEspana,
            ),
            ListTile(
              title: Funcoes().progressBar(barSize: 0.30),
            ),
            ListTile(
              leading: const Icon(
                Icons.start_rounded,
                size: 40,
                color: COR_02,
              ),
              title: const Text(
                'Zerar o Questionário',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                answeredQuestions.clear();
              },
            ),
            Container(height: 1, color: COR_02.withOpacity(0.2)),
            ListTile(
              leading: const Icon(
                Icons.facebook,
                size: 40,
                color: COR_02,
              ),
              title: const Text(
                'Blog no faceboog',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(urlfacebook);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                size: 40,
                color: COR_02,
              ),
              title: const Text(
                'O Projeto AutonoJobs',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'paginaCreditos');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.privacy_tip,
                size: 40,
                color: COR_02,
              ),
              title: const Text(
                'Termos de Uso e Privacidade',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'termosUsoPrivacidade');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.work,
                size: 40,
                color: COR_02,
              ),
              title: const Text(
                'Cadastre-se como Autonomo',
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(urlCadastro);
              },
            ),
          ],
        ));
  }
}
