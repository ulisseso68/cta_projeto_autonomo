import 'package:cta_projeto_autonomo/models/question_model.dart';

var indexPreguntas = 0;
var temaPreguntas = 'Cidadania e Direitos';
List uniqueCategories = [
  'Simulación Del Examen',
  'Tarea 1',
  'Tarea 2',
  'Tarea 3',
  'Tarea 4',
  'Tarea 5',
];
List preguntas = [];
Question currentQuestion = Question();
List answeredQuestions = [];
int language = 2;
int respostasCorretas = 0;
int respostasErradas = 0;
int numberOfQuestions = 5;
bool offlineMode = false;
bool loginRegistered = false;
bool developerMode = false;
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

double screenH = 100;
double screenW = 100;

/* var quesOptions = [
  {'id': 1, 'nome': '25 questions', 'nbr': 25},
  {'id': 2, 'nome': 'All questions', 'nbr': -1},
  {'id': 3, 'nome': 'Only 5 questions', 'nbr': 5},
  {'id': 4, 'nome': 'Only unanswered questions', 'nbr': -2},
  {'id': 5, 'nome': 'Only wrong answers', 'nbr': -3}
]; */

var urlfacebook = 'https://www.facebook.com/people/AutonoJobs/100083058583832/';

var urlCadastro =
    'https://docs.google.com/forms/d/e/1FAIpQLSdxctAaBWuY1EuSe20_r6jER96zFfXjeRo4VMqesq_aVH0ixA/viewform';

var tncs = [
  {
    'clausula':
        'Esta aplicação é oferecida de forma gratuita aos clientes dos autonomos, com o propósito de facilitar a busca e interação com os Autonomos (Profissionais Liberais) cadastrados.'
  },
  {
    'clausula':
        'Apesar dos esforços continuos do time de tecnologia, o AutonoJobs pode apresentar falhas temporárias. Se necessário, os usuarios (clientes e autonomos), podem alertar sobre falhas para o email: autonojobs@gmail.com'
  },
  {
    'clausula':
        'Todos os profissionais cadastrados no AutonoJobs passam por um processo de checagem, mas o AutonoJobs não se responsabilizada pela conduta dos mesmos. Recomendamos que os clientes tomem as precações necessárias (segurança e qualida de serviço) como o fariam diante de qualquer outra recomendação.'
  },
  {
    'clausula':
        'As informações agregadas no AutonoJob foram obtidas diretamente com os Profissionais ou através de canais públicos mantidos pelos mesmos.'
  },
  {
    'clausula':
        'O aplicativo AutonoJobs não mantém, nem busca ter acesso, a nenhum dado dos clientes que o utilizam.'
  }
];

/* var cidadesConfig = [
  {'nome': 'Gobierno y Legislación', 'estado': 'SP'},
  {'nome': 'Derecho y Deberes Fundamentales', 'estado': 'RJ'},
  {'nome': 'Organización Territorial. Geografia y Política', 'estado': 'MG'},
  {'nome': 'Cultura y Historia', 'estado': 'BA'},
  {'nome': 'Sociedad Española', 'estado': 'PR'},
]; */

/* var preguntasConfig = [
  {
    'id': 1,
    'pergunta': '¿Cuál es el nombre del rey actual de España?',
    'respostas': [
      {'resposta': 'Felipe VI', 'correcta': true},
      {'resposta': 'Juan Carlos I', 'correcta': false},
      {'resposta': 'Alfonso XIII', 'correcta': false}
    ],
    'tema': 'Gobierno y Legislación',
    'hasDetails': true,
    'detalhe':
        '\nFelipe VI de Borbón y Grecia es el rey actual de España, hijo de Juan Carlos I y Sofía de Grecia. Nació en Madrid en 1968 y accedió al trono en 2014 tras la abdicación de su padre. Es el actual jefe de estado y comandante supremo de las Fuerzas Armadas españolas. ',
    'fotografia': 'img/felipevi.png'
  },
  {
    'id': 2,
    'pergunta': '¿Cuál es la capital de España?',
    'respostas': [
      {'resposta': 'Madrid', 'correcta': true},
      {'resposta': 'Barcelona', 'correcta': false},
      {'resposta': 'Valencia', 'correcta': false}
    ],
    'tema': 'Gobierno y Legislación',
    'hasDetails': false,
  },
  {
    'id': 3,
    'pergunta': '¿Cuántas comunidades autónomas hay en España?',
    'respostas': [
      {'resposta': '17', 'correcta': true},
      {'resposta': '15', 'correcta': false},
      {'resposta': '20', 'correcta': false}
    ],
    'tema': 'Gobierno y Legislación',
    'hasDetails': false,
    'detalhe':
        'España está dividida en 17 comunidades autónomas y 2 ciudades autónomas (Ceuta y Melilla).',
    'fotografia':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Spain_communities_map.svg/800px-Spain_communities_map.svg.png'
  },
  {
    'id': 4,
    'pergunta': '¿Qué idioma se habla en la comunidad autónoma de Cataluña?',
    'respostas': [
      {'resposta': 'Catalán', 'correcta': true},
      {'resposta': 'Gallego', 'correcta': false},
      {'resposta': 'Vasco', 'correcta': false}
    ],
    'tema': 'Gobierno y Legislación',
    'hasDetails': false,
    'detalhe':
        'En Cataluña se habla principalmente el catalán, aunque el español también es oficial.',
    'fotografia':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Catalonia_location_map.svg/800px-Catalonia_location_map.svg.png'
  },
]; */
var atividades = [
  {'nome': 'Cabeleireiro', 'id': 1},
  {'nome': 'Manicure', 'id': 2},
  {'nome': 'Pedicure', 'id': 3},
  {'nome': 'Esteticista', 'id': 4},
  {'nome': 'Maquiador', 'id': 5},
  {'nome': 'Barbeiro', 'id': 6},
  {'nome': 'Massagista', 'id': 7},
  {'nome': 'Pintor de Unhas', 'id': 8},
];

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
