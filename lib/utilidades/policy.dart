// List of Languages
// 0 - English
// 1 - Portugues
// 2 - Spanish

// Listing of messages

class DocumentContent {
  final policy = {
    "terms_of_use": {
      "effective_date": "2025-07-15",
      "app_name": "CCSE Fácil",
      "languages": {
        "0": {
          "language": "English",
          "sections": [
            {
              "title": "This is a simulation of the CCSE exam",
              "content":
                  "The actual CCSe exam requires that you enroll to take it. It is managed by the Instituto Cervantes, and is taken in person at authorized testing centers."
            },
            {
              "title": "The exam is comprised of 25 questions",
              "content":
                  "The exam consists of 25 questions selected from a larger pool. Out of the 5 major topics, 10 questions are chosen from the 'Govern and Legislation' category, 3 from 'Rights and Fundamental Duties', 2 from 'Physical and Political Geography', 3 from 'Culture and History of Spain', and 7 from 'Spanish Society'."
            },
            {
              "title": "Time is limited",
              "content":
                  "In this simulation, as well as in the actual exam, you will have 45 minutes to conclude the exam."
            },
            {
              "title": "What is required to pass.",
              "content":
                  "You need to respond correctly to 15 (60%) of the questions to be approved."
            },
            {
              "title": "Results",
              "content":
                  "The results are communicated, online and via e-mail, by the Instituto Cervantes within a month (in average)."
            },
          ]
        },
        "2": {
          "language": "Español",
          "sections": [
            {
              "title": "Esta es una simulación del examen CCSE",
              "content":
                  "El examen CCSE real requiere que te inscribas para realizarlo. Está gestionado por el Instituto Cervantes y se realiza de forma presencial en centros autorizados."
            },
            {
              "title": "El examen consta de 25 preguntas",
              "content":
                  "El examen consiste en 25 preguntas seleccionadas de un banco mayor. De los 5 grandes temas, 10 preguntas son del apartado 'Gobierno y Legislación', 3 de 'Derechos y Deberes Fundamentales', 2 de 'Geografía Física y Política', 3 de 'Cultura e Historia de España' y 7 de 'Sociedad Española'."
            },
            {
              "title": "El tiempo es limitado",
              "content":
                  "En esta simulación, así como en el examen real, tendrás 45 minutos para completar el examen."
            },
            {
              "title": "Requisitos para aprobar",
              "content":
                  "Debes responder correctamente al menos 15 preguntas (60%) para ser aprobado."
            },
            {
              "title": "Resultados",
              "content":
                  "Los resultados son comunicados en línea y por correo electrónico por el Instituto Cervantes en un plazo aproximado de un mes."
            },
          ]
        },
        "1": {
          "language": "Português",
          "sections": [
            {
              "title": "Esta é uma simulação do exame CCSE",
              "content":
                  "O exame CCSE real exige que você se inscreva para realizá-lo. Ele é administrado pelo Instituto Cervantes e realizado presencialmente em centros autorizados."
            },
            {
              "title": "O exame é composto por 25 perguntas",
              "content":
                  "O exame consiste em 25 perguntas selecionadas de um banco maior. Dos 5 grandes temas, 10 perguntas são da categoria 'Governo e Legislação', 3 de 'Direitos e Deveres Fundamentais', 2 de 'Geografia Física e Política', 3 de 'Cultura e História da Espanha' e 7 de 'Sociedade Espanhola'."
            },
            {
              "title": "O tempo é limitado",
              "content":
                  "Nesta simulação, assim como no exame real, você terá 45 minutos para concluir o exame."
            },
            {
              "title": "O que é necessário para passar",
              "content":
                  "Você precisa responder corretamente a 15 (60%) das perguntas para ser aprovado."
            },
            {
              "title": "Resultados",
              "content":
                  "Os resultados são comunicados online e por e-mail pelo Instituto Cervantes em até um mês (em média)."
            },
          ]
        },
        "3": {
          "language": "Marroquí",
          "sections": [
            {
              "title": "هذا محاكاة لامتحان CCSE",
              "content":
                  "يتطلب امتحان CCSE الفعلي التسجيل لأدائه. يتم إدارته من قبل معهد سيرفانتس، ويُجرى شخصيًا في مراكز اختبار معتمدة."
            },
            {
              "title": "يتكون الامتحان من 25 سؤالًا",
              "content":
                  "يتكون الامتحان من 25 سؤالًا مختارة من مجموعة أكبر. من بين 5 مواضيع رئيسية، يتم اختيار 10 أسئلة من فئة 'الحكومة والتشريع'، و3 من 'الحقوق والواجبات الأساسية'، و2 من 'الجغرافيا الفيزيائية والسياسية'، و3 من 'ثقافة وتاريخ إسبانيا'، و7 من 'المجتمع الإسباني'."
            },
            {
              "title": "الوقت محدود",
              "content":
                  "في هذه المحاكاة، وكذلك في الامتحان الفعلي، سيكون لديك 45 دقيقة لإنهاء الامتحان."
            },
            {
              "title": "ما هو مطلوب للنجاح",
              "content":
                  "يجب عليك الإجابة بشكل صحيح على 15 (60%) من الأسئلة لتكون ناجحًا."
            },
            {
              "title": "النتائج",
              "content":
                  "يتم إبلاغ النتائج عبر الإنترنت وعبر البريد الإلكتروني من قبل معهد سيرفانتس في غضون شهر (في المتوسط)."
            },
          ]
        }
      }
    }
  };

  getTermsOfUse() {
    return policy['terms_of_use'];
  }

  getTermsOfUseByLanguage(String language) {
    var terms = getTermsOfUse();
    if (terms != null && terms['languages'].containsKey(language)) {
      return terms['languages'][language];
    } else {
      return terms['languages']['English'];
    }
  }

  getSessionsbyLanguage(String language) {
    var terms = getTermsOfUseByLanguage(language);
    if (terms != null) {
      return terms['sections'];
    } else {
      return "error";
    }
  }
}
