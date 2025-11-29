import 'package:ccse_mob/models/question_model.dart';

var indexPreguntas = 0;
var temaPreguntas = 'Cidadania e Direitos';
var appVersion = '5.5.0';
bool modoDeveloper = false;
bool developerMode = false;
List uniqueCategories = [
  'Simulación Del Examen',
  'Tarea 1',
  'Tarea 2',
  'Tarea 3',
  'Tarea 4',
  'Tarea 5',
];
List preguntas = [];
List learnings = [];
Question currentQuestion = Question();
List answeredQuestions = [];
int language = 2;
int respostasCorretas = 0;
int respostasErradas = 0;
int numberOfQuestions = 5;
bool offlineMode = false;
bool loginRegistered = false;

String citizenship = "";
String countryFlag = ""; // Default to Spain
bool tcsAccepted = false;
bool getName = false;
String userName = '';
String deviceID = '';
String deviceType = 'unknown';
String examCat = 'Simulación Del Examen';
int respostaDada = 0;
String translatedDescription = "";
bool translationAvailable = false;
bool otherLanguage = (language != 2) ? true : false;
Map<String, String> descriptionsTranslations = {};
// AdMob & AdUnit Ids
//String admobAppId = 'ca-app-pub-6464644953989525~4816042821';
String bannerAdUnitIdIOS = '';
String bannerAdUnitIdAndroid = '';
String nativeAdUnitIdIOS = '';
String nativeAdUnitIdAndroid = '';
var uuid = '';
var firstPartyAd;
var translation;
String? FirebaseUserId = '';

double screenH = 100;
double screenW = 100;

var projetoParticipates = [
  {'nome': 'Laravel', 'cargo': 'backend Technology'},
  {'nome': 'Dart', 'cargo': 'Programming Language'},
  {'nome': 'Apple App Store', 'cargo': 'App Distribution'},
  {'nome': 'GitHub', 'cargo': 'Code Repository'},
  {'nome': 'OpenAI', 'cargo': 'AI Technology'},
];

Map<String, int> ccseExam = {
  "Tarea 1": 10,
  "Tarea 2": 3,
  "Tarea 3": 2,
  "Tarea 4": 3,
  "Tarea 5": 7
};

Map<String, String> shortCatMap = {
  'Tarea 1': 'Govern and Legislation',
  'Tarea 2': 'Rights and Fundamental Duties',
  'Tarea 3': 'Physical and Political Geography',
  'Tarea 4': 'Culture and History of Spain',
  'Tarea 5': 'Spanish Society',
  'Simulación Del Examen': 'Simulated Exam',
};

Map<String, String> traducionCatToTarea = {
  'GOBIERNO, LEGISLACIÓN Y PARTICIPACIÓN CIUDADANA': 'Tarea 1',
  'DERECHOS Y DEBERES FUNDAMENTALES': 'Tarea 2',
  'ORGANIZACIÓN TERRITORIAL DE ESPAÑA. GEOGRAFÍA FÍSICA Y POLÍTICA': 'Tarea 3',
  'CULTURA E HISTORIA DE ESPAÑA': 'Tarea 4',
  'SOCIEDAD ESPAÑOLA': 'Tarea 5',
  'SIMULACIÓN DEL EXAMEN': 'Examen Simulado',
};

Map<String, String> traducionTareaToCat = {
  'Tarea 1': 'GOBIERNO, LEGISLACIÓN Y PARTICIPACIÓN CIUDADANA',
  'Tarea 2': 'DERECHOS Y DEBERES FUNDAMENTALES',
  'Tarea 3': 'ORGANIZACIÓN TERRITORIAL DE ESPAÑA. GEOGRAFÍA FÍSICA Y POLÍTICA',
  'Tarea 4': 'CULTURA E HISTORIA DE ESPAÑA',
  'Tarea 5': 'SOCIEDAD ESPAÑOLA',
  'Examen Simulado': 'SIMULACIÓN DEL EXAMEN',
};
