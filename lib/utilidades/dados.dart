import 'package:cta_projeto_autonomo/models/question_model.dart';

var indexPreguntas = 0;
var temaPreguntas = 'Cidadania e Direitos';
List uniqueCategories = [];
List preguntas = [];
Question currentQuestion = Question();
List answeredQuestions = [];
int language = 2;
int respostasCorretas = 0;
int respostasErradas = 0;
int numberOfQuestions = 5;
bool offlineMode = false;
String citizenship = "";
String countryFlag = ""; // Default to Spain
bool tcsAccepted = false;
String userName = '';
String deviceID = '';

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

var projetoAJ = {
  'descricao':
      'O projeto AutonoJobs é fruto de um trabalho conjunto entre a área de Tecnologia da DUFRY Brasil e os alunos do CTA - Centro de Treinamento Administrativo. Juntos, este time de profissionais e alunos materializaram uma proposta de negócios com o uso de tecnologia.',
  'msg2':
      'Durante o ano de 2023, assistiremos ao processo de melhoria deste negócio, conduzido pelos alunos.',
  'msg3': 'Estes são os participantes deste projeto',
  'tnc1':
      'Esta aplicação é oferecida de forma gratuita aos clientes dos autonomos, com o propósito de facilitar.'
};

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

var preguntasConfig = [
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
];
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
  {'nome': 'Aicon Silva', 'cargo': 'Aluno CTA'},
  {'nome': 'Amanda dos Anjos', 'cargo': 'Aluno CTA'},
  {'nome': 'Brenda Assis', 'cargo': 'Aluno CTA'},
  {'nome': 'Eyshila Souza', 'cargo': 'Aluno CTA'},
  {'nome': 'Henry Oliveira', 'cargo': 'Aluno CTA'},
  {'nome': 'Jessica da Silva', 'cargo': 'Aluno CTA'},
  {'nome': 'Kailan Santos', 'cargo': 'Aluno CTA'},
  {'nome': 'Luis Xavier', 'cargo': 'Aluno CTA'},
  {'nome': 'Maicon Nascimento', 'cargo': 'Aluno CTA'},
  {'nome': 'Marcelle Souza', 'cargo': 'Aluno CTA'},
  {'nome': 'Maria Fernanda', 'cargo': 'Aluno CTA'},
  {'nome': 'Mateus Fernandes', 'cargo': 'Aluno CTA'},
  {'nome': 'Nathan Rocha', 'cargo': 'Aluno CTA'},
  {'nome': 'Nicolle de Souza', 'cargo': 'Aluno CTA'},
  {'nome': 'Raphael Ferreira', 'cargo': 'Aluno CTA'},
  {'nome': 'Samuel Ribeiro', 'cargo': 'Aluno CTA'},
  {'nome': 'Victoria Chagas', 'cargo': 'Aluno CTA'},
  {'nome': 'Vitória Silva', 'cargo': 'Aluno CTA'},
  {'nome': 'Walleks Soares', 'cargo': 'Aluno CTA'},
  {'nome': 'Yasmin Costa', 'cargo': 'Aluno CTA'},
  {'nome': 'Mirtes Medeiros', 'cargo': 'CTA - Coordenação'},
  {'nome': 'Neuza Azeredo', 'cargo': 'CTA - Coordenação'},
  {'nome': 'Fabio Marques', 'cargo': 'Dufry - Time de Tecnologia'},
  {'nome': 'Flávio Vivacqua', 'cargo': 'Dufry - Time de Tecnologia'},
  {'nome': 'Henrique Reis', 'cargo': 'Dufry - Time de Tecnologia'},
  {'nome': 'Jociel Cavalcante', 'cargo': 'Dufry - Time de Tecnologia'},
  {'nome': 'Luciana Montez', 'cargo': 'Dufry - Time de Tecnologia'},
  {'nome': 'Ulisses Campos', 'cargo': 'Dufry - Time de Tecnologia'},
  {'nome': 'Valeria Rezende', 'cargo': 'Dufry - Time de Tecnologia'},
];
