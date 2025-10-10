import 'package:ccse_mob/funcoes/fAPI.dart';
import 'package:ccse_mob/funcoes/funcoes.dart';
import 'package:ccse_mob/utilidades/dados.dart';
import 'package:ccse_mob/utilidades/env.dart';
import 'package:flutter/material.dart';

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
        shape: Border(
          right: BorderSide(
            color: redEspana,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenH * 0.10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenW * 0.05,
                    ),
                    Funcoes().logoWidget(opacity: 0, letterColor: redEspana),
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  color: redEspana,
                ),
                /* Center(
                  child: Text(uuid == '' ? '' : uuid,
                      style: const TextStyle(fontSize: 8, color: redEspana)),
                ), */
              ],
            ),

            // KPIs
            SizedBox(
              height: screenH * 0.02,
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
              /* subtitle: Text(
                Funcoes().appLang('Name, Country, Language'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ), */
              onTap: () async {
                //Navigator.popUntil(context, ModalRoute.withName('splashPage'));
                await Navigator.pushNamed(context, 'splashPage').then((value) {
                  // This callback is executed when returning from the splash page
                  Navigator.pop(context);
                });
              },
            ),

            // Terms of Use
            ListTile(
              leading: const Icon(
                Icons.handshake,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Terms of Use'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(
                    'https://app.ccsefacil.es/terms-of-service/es'); /* 
                Navigator.popAndPushNamed(context, 'termosUsoPrivacidade'); */
              },
            ),

            // Privacy
            ListTile(
              leading: const Icon(
                Icons.policy_rounded,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Privacy Policy'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi()
                    .launchUrlOut('https://app.ccsefacil.es/privacy-policy/es');
              },
            ),

            //Device ID in Developer Mode
            if (developerMode)
              ListTile(
                leading: const Icon(
                  Icons.perm_identity_rounded,
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
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                onTap: () {},
              ),

            // Send email to Support
            ListTile(
              leading: const Icon(
                Icons.help,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('Support'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              /* subtitle: Text(
                Funcoes().appLang(
                    'If you have any questions, complaints or suggestions'),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ), */
              onTap: () async {
                String body = Funcoes().appLang(
                    'If you have any questions, complaints or suggestions');
                await CallApi().sendEmail('CCSE Fácil - Support', body);
                Navigator.pop(context);
              },
            ),

            // News do CCSE facil
            ListTile(
              leading: const Icon(
                Icons.campaign,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('CCSE Fácil news'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut('https://app.ccsefacil.es/');
              },
            ),

            // Manual Instituto Cervantes
            ListTile(
              leading: const Icon(
                Icons.edit_note,
                size: 40,
                color: redEspana,
              ),
              title: Text(
                Funcoes().appLang('CCSE Manual'),
                textAlign: TextAlign.start,
                style: TextStyle(color: COR_01, fontSize: 14),
              ),
              onTap: () {
                CallApi().launchUrlOut(
                    'https://app.ccsefacil.es/img/Manual%20CCSE.pdf');
              },
            ),

            // Offline Mode
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
              onTap: () async {
                await Funcoes().iniciarPreguntas().then(
                  // Initialize questions
                  (value) {
                    CallApi().showAlert(
                        context,
                        Text(
                          Funcoes().appLang((offlineMode)
                              ? 'Aplication is not connected to servers'
                              : 'Connection to servers established'),
                          style: const TextStyle(color: Colors.white),
                        ),
                        '');
                    Navigator.pop(context);
                  },
                );
              },
            ),

// Modo Developer
            if (developerMode)
              ListTile(
                leading: modoDeveloper
                    ? const Icon(
                        Icons.bug_report,
                        size: 40,
                        color: COR_dev,
                      )
                    : const Icon(
                        Icons.bug_report,
                        size: 40,
                        color: redEspana,
                      ),
                title: Text(
                  modoDeveloper
                      ? Funcoes().appLang('Development Mode Activated')
                      : Funcoes().appLang('User Mode Activated'),
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: COR_01, fontSize: 14),
                ),
                onTap: () async {
                  Funcoes().toggleDeveloperMode();
                  Navigator.pop(context);
                },
              ),

            /* Share your experience 
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
              onTap: () async {
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  CallApi().showAlert(
                      context,
                      Text(
                        Funcoes().appLang('Review not available at the moment'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      '');
                }
              },
            ), */
          ],
        ));
  }
}
