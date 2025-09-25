import 'package:flutter/material.dart';

void main() {
  runApp(AplicativoFlashcards());
}

class AplicativoFlashcards extends StatelessWidget {
  const AplicativoFlashcards({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TelaSelecaoIdioma(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Flashcard {
  final String palavra;
  final String traducao;

  Flashcard({
    required this.palavra,
    required this.traducao,
  });
}

enum IdiomaAprendizado { portuguesToIngles, inglestoPortugues }

// Base de dados dos flashcards
final List<Flashcard> flashcardsPortuguesIngles = [
  Flashcard(palavra: 'Casa', traducao: 'House'),
  Flashcard(palavra: 'Água', traducao: 'Water'),
  Flashcard(palavra: 'Comida', traducao: 'Food'),
  Flashcard(palavra: 'Livro', traducao: 'Book'),
  Flashcard(palavra: 'Escola', traducao: 'School'),
  Flashcard(palavra: 'Amigo', traducao: 'Friend'),
  Flashcard(palavra: 'Família', traducao: 'Family'),
  Flashcard(palavra: 'Trabalho', traducao: 'Work'),
  Flashcard(palavra: 'Música', traducao: 'Music'),
  Flashcard(palavra: 'Feliz', traducao: 'Happy'),
];

final List<Flashcard> flashcardsInglesPortugues = [
  Flashcard(palavra: 'House', traducao: 'Casa'),
  Flashcard(palavra: 'Water', traducao: 'Água'),
  Flashcard(palavra: 'Food', traducao: 'Comida'),
  Flashcard(palavra: 'Book', traducao: 'Livro'),
  Flashcard(palavra: 'School', traducao: 'Escola'),
  Flashcard(palavra: 'Friend', traducao: 'Amigo'),
  Flashcard(palavra: 'Family', traducao: 'Família'),
  Flashcard(palavra: 'Work', traducao: 'Trabalho'),
  Flashcard(palavra: 'Music', traducao: 'Música'),
  Flashcard(palavra: 'Happy', traducao: 'Feliz'),
];

class TelaSelecaoIdioma extends StatelessWidget {
  const TelaSelecaoIdioma({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards - Selecionar Idioma'),
        backgroundColor: Colors.blue[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.language,
                size: 80,
                color: Colors.blue[600],
              ),
              const SizedBox(height: 30),
              Text(
                'Escolha o modo de aprendizado:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 50),
              _construirCartaoIdioma(
                context,
                'Português → Inglês',
                'Aprenda palavras em inglês',
                Icons.translate,
                Colors.blue,
                IdiomaAprendizado.portuguesToIngles,
              ),
              const SizedBox(height: 20),
              _construirCartaoIdioma(
                context,
                'Inglês → Português',
                'Aprenda palavras em português',
                Icons.translate,
                Colors.green,
                IdiomaAprendizado.inglestoPortugues,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCartaoIdioma(
    BuildContext context,
    String tituloIdioma,
    String descricaoIdioma,
    IconData icone,
    Color cor,
    IdiomaAprendizado idioma,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaFlashcards(idiomaEscolhido: idioma),
            ),
          );
        },
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: cor, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tituloIdioma,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      descricaoIdioma,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaFlashcards extends StatefulWidget {
  final IdiomaAprendizado idiomaEscolhido;

  const TelaFlashcards({super.key, required this.idiomaEscolhido});

  @override
  _TelaFlashcardsState createState() => _TelaFlashcardsState();
}

class _TelaFlashcardsState extends State<TelaFlashcards> {
  int indiceAtual = 0;
  bool mostrarTraducao = false;

  List<Flashcard> get flashcardsAtivos {
    return widget.idiomaEscolhido == IdiomaAprendizado.portuguesToIngles
        ? flashcardsPortuguesIngles
        : flashcardsInglesPortugues;
  }

  String get nomeIdioma {
    return widget.idiomaEscolhido == IdiomaAprendizado.portuguesToIngles
        ? 'Português → Inglês'
        : 'Inglês → Português';
  }

  String get idiomaOrigem {
    return widget.idiomaEscolhido == IdiomaAprendizado.portuguesToIngles
        ? 'Português'
        : 'Inglês';
  }

  String get idiomaDestino {
    return widget.idiomaEscolhido == IdiomaAprendizado.portuguesToIngles
        ? 'Inglês'
        : 'Português';
  }

  void proximoCard() {
    setState(() {
      if (indiceAtual < flashcardsAtivos.length - 1) {
        indiceAtual++;
        mostrarTraducao = false;
      } else {
        // Se chegou ao último card, navega para a tela de conclusão
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaConclusao(
              idiomaEscolhido: widget.idiomaEscolhido,
              totalPalavras: flashcardsAtivos.length,
            ),
          ),
        );
      }
    });
  }

  void cardAnterior() {
    setState(() {
      if (indiceAtual > 0) {
        indiceAtual--;
        mostrarTraducao = false;
      }
    });
  }

  void alternarTraducao() {
    setState(() {
      mostrarTraducao = !mostrarTraducao;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardAtual = flashcardsAtivos[indiceAtual];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards - $nomeIdioma'),
        backgroundColor: Colors.blue[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Palavra ${indiceAtual + 1} de ${flashcardsAtivos.length}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      nomeIdioma,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: (indiceAtual + 1) / flashcardsAtivos.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
              ),
            ),

            // Card interativo que alterna entre palavra e tradução
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: alternarTraducao,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 300,
                    height: 200,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: mostrarTraducao ? Colors.green[50] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: mostrarTraducao ? Colors.green[200]! : Colors.blue[200]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          mostrarTraducao ? Icons.translate : Icons.quiz,
                          size: 40,
                          color: mostrarTraducao ? Colors.green[600] : Colors.blue[600],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          mostrarTraducao ? idiomaDestino : idiomaOrigem,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mostrarTraducao ? cardAtual.traducao : cardAtual.palavra,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: mostrarTraducao ? Colors.green[800] : Colors.blue[800],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (!mostrarTraducao)
                          Text(
                            'Toque para revelar a tradução',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: indiceAtual > 0 ? cardAnterior : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: alternarTraducao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mostrarTraducao ? Colors.green[600] : Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(mostrarTraducao ? 'Ocultar' : 'Revelar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: proximoCard,
                    icon: Icon(indiceAtual == flashcardsAtivos.length - 1 ? Icons.check : Icons.arrow_forward),
                    label: Text(indiceAtual == flashcardsAtivos.length - 1 ? 'Finalizar' : 'Próximo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: indiceAtual == flashcardsAtivos.length - 1 ? Colors.green[600] : Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaConclusao extends StatelessWidget {
  final IdiomaAprendizado idiomaEscolhido;
  final int totalPalavras;

  const TelaConclusao({super.key, 
    required this.idiomaEscolhido,
    required this.totalPalavras,
  });

  String get nomeIdioma {
    return idiomaEscolhido == IdiomaAprendizado.portuguesToIngles
        ? 'Português → Inglês'
        : 'Inglês → Português';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parabéns!'),
        backgroundColor: Colors.green[600],
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        spreadRadius: 10,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.green[600],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  'Parabéns!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'Você completou todas as $totalPalavras palavras do modo:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                
                const SizedBox(height: 15),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Text(
                    nomeIdioma,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.green[600],
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Excelente trabalho! Continue praticando para melhorar ainda mais seu vocabulário.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
                
                Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaFlashcards(
                                idiomaEscolhido: idiomaEscolhido,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text('Estudar Novamente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 15),
                    
                    SizedBox(
                      width: 250,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Remove todas as telas da pilha e volta ao início
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const TelaSelecaoIdioma(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('Finalizar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}