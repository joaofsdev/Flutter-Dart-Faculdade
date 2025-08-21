import 'dart:math';

enum ColorStyle { emoji, none }
const colorStyle = ColorStyle.emoji;

String paint(String txt, {required bool isEight, required Suit suit}) {
  if (colorStyle == ColorStyle.none) return txt;
  if (isEight) return '🟩$txt';
  final isRed = suit == Suit.hearts || suit == Suit.diamonds;
  return isRed ? '🟥$txt' : '⬜$txt';
}

enum Suit { spades, hearts, diamonds, clubs }

String suitSymbol(Suit s) =>
    {Suit.spades: '♠', Suit.hearts: '♥', Suit.diamonds: '♦', Suit.clubs: '♣'}[s]!;

class Card {
  // rank: valor da carta ('2'...'A')
  final String rank;
  // suit: naipe da carta (enum Suit)
  final Suit suit;

  // construtor que recebe rank e suit obrigatórios
  Card(this.rank, this.suit);

  // propriedade que retorna true se a carta for um 8
  bool get isEight => rank == '8';

  // função de exibição da carta com cores
  String disp() => paint('$rank${suitSymbol(suit)}', isEight: isEight, suit: suit);
}

class Deck {
  final _r = Random();
  final List<Card> _cards = [];

  Deck() {
    // lista de ranks válidos para o baralho
    final ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];
    // para cada naipe e cada rank, adiciona uma carta ao baralho
    for (final suit in Suit.values) {
      for (final rank in ranks) {
        _cards.add(Card(rank, suit)); // cria carta e adiciona
      }
    }
    _cards.shuffle(_r); // embaralha o baralho
  }

  bool get isEmpty => _cards.isEmpty;

  Card draw() {
    // se o baralho estiver vazio, lança erro
    if (_cards.isEmpty) throw StateError('Baralho vazio ao tentar comprar carta.');
    // remove e retorna a carta do topo
    return _cards.removeLast();
  }

  void addAllAndShuffle(Iterable<Card> cards) {
    // adiciona todas as cartas recebidas ao baralho
    _cards.addAll(cards);
    // embaralha o baralho após adicionar
    _cards.shuffle(_r);
  }
}

class Player {
  final String name;
  final List<Card> hand = [];
  Player(this.name);

  // Mantido: exibe a mão como texto (não alterar).
  String handDisp() => '[ ${hand.map((c) => c.disp()).join(' ')} ] (${hand.length})';
}

class CrazyEights {
  final List<Player> players = [Player('P1'), Player('P2'), Player('P3'), Player('P4')];
  final Deck deck = Deck();
  final List<Card> discard = [];
  final _rng = Random();

  Suit? requiredSuit;

  void dealInitial() {
    // distribui 5 cartas para cada jogador
    for (var i = 0; i < 5; i++) {
      for (final p in players) {
        p.hand.add(deck.draw()); // compra carta do baralho e adiciona à mão
      }
    }
    // vira a primeira carta do baralho para iniciar o descarte
    final first = deck.draw();
    discard.add(first);
    // se a primeira carta for 8, escolhe um naipe aleatório para iniciar
    if (first.isEight) {
      requiredSuit = Suit.values[_rng.nextInt(Suit.values.length)];
    }
  }

  Card get top {
    // retorna a carta do topo do descarte (última da lista)
    return discard.last;
  }

  bool isPlayable(Card c) {
    // 8 sempre pode ser jogado
    if (c.isEight) return true;
    // se há um naipe declarado, só pode jogar cartas desse naipe
    if (requiredSuit != null) return c.suit == requiredSuit;
    // senão, pode jogar se casar por naipe ou por rank com a carta do topo
    return c.suit == top.suit || c.rank == top.rank;
  }

  Suit chooseSuitForEight(Player p) {
    // cria mapa para contar frequência dos naipes (ignorando cartas 8)
    final suitCount = <Suit, int>{};
    for (final suit in Suit.values) {
      suitCount[suit] = 0; // inicializa contadores
    }
    for (final card in p.hand) {
      if (!card.isEight) suitCount[card.suit] = suitCount[card.suit]! + 1;
    }
    // encontra o(s) naipe(s) mais frequente(s)
    final maxCount = suitCount.values.reduce(max);
    final mostFrequent = suitCount.entries.where((e) => e.value == maxCount).map((e) => e.key).toList();
    // desempate: retorna aleatoriamente entre os mais frequentes
    return mostFrequent[_rng.nextInt(mostFrequent.length)];
  }

  void refillDeckIfNeeded() {
    // verifica se o baralho acabou e há mais de 1 carta no descarte
    if (deck.isEmpty && discard.length > 1) {
      final topCard = discard.removeLast(); // guarda topo
      deck.addAllAndShuffle(discard); // move restante para o baralho e embaralha
      discard.clear(); // limpa descarte
      discard.add(topCard); // devolve topo ao descarte
    }
  }

  Card? chooseCardToPlay(Player p) {
    // lista todas as cartas jogáveis da mão do jogador
    final playables = p.hand.where(isPlayable).toList();
    // se não há carta jogável, retorna null
    if (playables.isEmpty) return null;
    // prefere jogar carta não-8, se possível
    final nonEights = playables.where((c) => !c.isEight).toList();
    if (nonEights.isNotEmpty) return nonEights.first; // joga primeira não-8 jogável
    // se só há 8 jogáveis, joga um 8
    return playables.first; // pode ser 8
  }

  void run() {
    dealInitial(); // distribui cartas e inicia descarte
    printState(); // imprime estado inicial
    int turn = 0; // índice do jogador da vez
    int safety = 0; // contador de segurança para evitar loop infinito
    const maxTurns = 500; // limite de segurança
    while (safety < maxTurns) {
      final p = players[turn];
      Card? played = chooseCardToPlay(p); // tenta escolher carta para jogar
      int draws = 0; // conta quantas cartas comprou neste turno
      // se não tem carta jogável, compra até achar ou atingir limite de compras
      while (played == null && !deck.isEmpty && draws < 5) {
        refillDeckIfNeeded(); // reembaralha se necessário
        final drawn = deck.draw();
        p.hand.add(drawn); // adiciona carta comprada à mão
        draws++;
        if (isPlayable(drawn)) played = drawn; // verifica se pode jogar a carta recém-comprada
      }
      // se conseguiu jogar uma carta
      if (played != null) {
        p.hand.remove(played); // remove da mão
        discard.add(played); // coloca na pilha de descarte
        if (played.isEight) {
          requiredSuit = chooseSuitForEight(p); // declara novo naipe
          print('${p.name} jogou ${played.disp()} e declarou naipe ${paint(suitSymbol(requiredSuit!), isEight: true, suit: requiredSuit!)}');
        } else {
          requiredSuit = null; // limpa naipe declarado
          print('${p.name} jogou ${played.disp()}');
        }
        // verifica se o jogador venceu (mão vazia)
        if (p.hand.isEmpty) {
          printState();
          print('*** ${p.name} venceu! ***');
          return; // termina simulação
        }
      } else {
        print('${p.name} não conseguiu jogar e passou a vez.');
      }
      printState(); // imprime estado ao final do turno
      turn = (turn + 1) % players.length; // passa a vez para próximo jogador
      safety++;
    }
    print('Limite de turnos atingido, encerrando partida.');
  }

  void printState() {
    print('\nEstado atual:');
    for (final p in players) {
      print('  ${p.name}: ${p.handDisp()}');
    }
    final reqStr = (requiredSuit != null) ? ' (naipe declarado: 🟩${suitSymbol(requiredSuit!)})' : '';
    print('  Descarte (topo): ${discard.isEmpty ? "<TOPO>" : top.disp()}$reqStr');
  }
}

void main() {
  print('=== Oito Maluco — Exercício (4 jogadores) ===');
  print('Complete os TODOs e depois chame a simulação.');
  // após implementar, descomente a linha abaixo.
  CrazyEights().run();
}
