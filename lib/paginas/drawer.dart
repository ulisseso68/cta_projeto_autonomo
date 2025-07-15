import 'package:cta_projeto_autonomo/funcoes/fAPI.dart';
import 'package:cta_projeto_autonomo/funcoes/funcoes.dart';
import 'package:cta_projeto_autonomo/utilidades/dados.dart';
import 'package:cta_projeto_autonomo/utilidades/env.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class AJDrawer extends StatelessWidget {
  const AJDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: screenW * 0.8,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: redEspana,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'splash_image_2',
                    child: Image(
                      image: AssetImage('img/CCSEf.png'),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Funcoes().logoWidget(fontSize: 20, opacity: 0),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: offlineMode
                  ? const Icon(
                      Icons.wifi_off,
                      size: 40,
                      color: redEspana,
                    )
                  : const Icon(
                      Icons.wifi,
                      size: 40,
                      color: redEspana,
                    ),
              title: Text(
                offlineMode
                    ? Funcoes().appLang('Offline Mode Activated')
                    : Funcoes().appLang('Online Mode Activated'),
                textAlign: TextAlign.start,
                style: const TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                answeredQuestions.clear();
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.graphic_eq,
                size: 40,
                color: redEspana,
              ),
              title: Funcoes().progressBar(barSize: 0.5),
            ),
            // ignore: deprecated_member_use
            Container(height: 1, color: COR_02.withOpacity(0.2)),
            ListTile(
              leading: const Icon(
                Icons.facebook,
                size: 40,
                color: redEspana,
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
                Icons.star,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Credits and Acknowledgments'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'paginaCreditos');
              },
            ),
            // Terms of Use
            ListTile(
              leading: const Icon(
                Icons.edit_document,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Terms of Use'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, 'termosUsoPrivacidade');
              },
            ),
            // Share your experience
            ListTile(
              leading: const Icon(
                Icons.rate_review_rounded,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Share your experience'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              subtitle: Text(
                Funcoes().appLang('Help us improve the app'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                LaunchReview.launch(writeReview: false, iOSAppId: "1635840240");
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Initial Settings'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              subtitle: Text(
                Funcoes().appLang('Name, Country, Language'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('splashPage'));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.device_unknown,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Device ID'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              subtitle: Text(
                deviceID,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {},
            ),
          ],
        ));
  }
}
