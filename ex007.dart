// 1) Enum aprimorado
// Enum aprimorado que representa o nível de dificuldade do jogo
// Cada valor tem um multiplicador de dano e um emoji associado
enum Dificuldade {
  facil(0.8, '🙂'),
  normal(1.0, '⚔️'),
  dificil(1.2, '💀'),
  insano(1.5, '🔥');

  // Multiplicador de dano para cada dificuldade
  final double multiplicador;
  // Emoji representando a dificuldade
  final String emoji;
  const Dificuldade(this.multiplicador, this.emoji);

  // Retorna o nome bonito da dificuldade
  String get rotulo {
    switch (this) {
      case Dificuldade.facil:
        return 'Fácil';
      case Dificuldade.normal:
        return 'Normal';
      case Dificuldade.dificil:
        return 'Difícil';
      case Dificuldade.insano:
        return 'Insano';
    }
  }

  // Retorna uma string informativa sobre a dificuldade
  // Exemplo: "Normal (x1.0) ⚔️"
  String info() {
    final mult = multiplicador.toStringAsFixed(1);
    return '${rotulo} (x$mult) $emoji';
  }
}

// 2) Hierarquia selada
// Hierarquia selada para representar ações possíveis no jogo
sealed class Acao {
  const Acao();
}

// Ação de ataque, recebe o dano base
class Atacar extends Acao {
  final int danoBase;
  const Atacar(this.danoBase);
}

// Ação de cura, recebe a quantidade de vida a recuperar
class Curar extends Acao {
  final int vida;
  const Curar(this.vida);
}

// Ação de defesa
class Defender extends Acao {
  const Defender();
}

// 3) Typedef de estratégia
// Typedef para estratégia de cálculo de dano
typedef ModDano = int Function(int base, Dificuldade diff);

// 4) Mixin de log
// Mixin que adiciona funcionalidade de log
mixin LogMixin {
  // Exibe uma mensagem de log no console
  void log(String msg) {
    print('[LOG] $msg');
  }
}

// 5) Simulador
// Classe principal do simulador do jogo
// Controla o HP, dificuldade e estratégia de dano
class Simulador with LogMixin {
  // Pontos de vida do jogador
  int hp = 100;
  // Dificuldade selecionada
  final Dificuldade diff;
  // Estratégia de cálculo de dano
  final ModDano mod;

  // Construtor recebe dificuldade e estratégia
  Simulador({required this.diff, required this.mod});

  // Aplica uma ação ao simulador
  void aplicar(Acao a) {
    switch (a) {
      case Atacar(:final danoBase):
        // Calcula o dano usando a estratégia e aplica ao HP
        final dano = mod(danoBase, diff);
        hp -= dano;
        log('Atacou causando $dano de dano!');
        break;
      case Curar(:final vida):
        // Recupera vida
        hp += vida;
        log('Curou $vida de vida!');
        break;
      case Defender():
        // Executa defesa
        log('Defendeu!');
        break;
    }
    // Garante que HP nunca seja menor que zero
    if (hp < 0) hp = 0;
  }

  // Retorna o status atual do jogador
  String status() => 'HP=$hp | Dif: ${diff.info()}';
}

void main() {
  // Estratégia básica de dano
  // Multiplica o dano base pelo multiplicador da dificuldade
  // Limita o resultado entre 1 e 999
  final ModDano modBasica = (base, diff) {
    return ((base * diff.multiplicador).round()).clamp(1, 999);
  };

  // Cria o simulador com dificuldade difícil e estratégia básica
  final sim = Simulador(diff: Dificuldade.dificil, mod: modBasica);

  // Roteiro de ações para simular
  final roteiro = <Acao>[
    Atacar(12),      // Ataca com dano base 12
    const Defender(),// Defende
    Curar(5),        // Cura 5 de vida
    Atacar(30),      // Ataca com dano base 30
  ];

  // Executa cada ação do roteiro e imprime o status
  for (final acao in roteiro) {
    sim.aplicar(acao);
    print(sim.status());
  }
}
