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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'splash_image',
                    child: Image(
                      width: screenW * 0.15,
                      image: AssetImage('img/CCSEf.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Funcoes().logoWidget(fontSize: 35, opacity: 0),
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
            // News do CCSE facil
            ListTile(
              leading: const Icon(
                Icons.notifications_active,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('CCSE Facil news'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(urlfacebook);
              },
            ),
            // Credits and Acknowledgments
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
            // Settings
            ListTile(
              leading: const Icon(
                Icons.settings,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Configurations'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              subtitle: Text(
                Funcoes().appLang('Name, Country, Language'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                //Navigator.popUntil(context, ModalRoute.withName('splashPage'));
                Navigator.pushNamed(context, 'splashPage');
              },
            ),
            // Device ID
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
            // Send email to Support
            ListTile(
              leading: const Icon(
                Icons.email,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Send email to Support'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              subtitle: Text(
                Funcoes().appLang(
                    'If you have any questions, complaints or suggestions'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                CallApi().launchUrlOut(urlfacebook);
              },
            ),
          ],
        ));
  }
}
