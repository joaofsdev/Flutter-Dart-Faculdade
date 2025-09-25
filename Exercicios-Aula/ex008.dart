// Lista de jogadas, cada uma é um record com id do jogador, pontos e tipo
List<(String id, int pontos, String? tipo)> jogadas = [
  // Exemplos de jogadas variadas, incluindo id "sujo" e id inválido
  ('ana 123', 50, 'normal'),
  ('bob', 120, 'hard'),
  ('ana 123', 100, 'hard'),
  ('bob', 200, 'boss'),
  ('ana 123', 80, null),
  ('bob', 10, 'normal'),
  ('ana 123', 105, 'hard'),
  ('bob', 0, 'hard'),
  ('jo', 50, 'normal'), // id inválido, será ignorado
  ('ana 123', 300, 'boss'),
  ('bob', 999, 'boss'),
  ('ana 123', 10, 'normal'),
];

// Extension type para padronizar e validar ids de jogador
// Classe para padronizar e validar ids de jogador
class PlayerId {
  final String value;
  const PlayerId(this.value);

  // Remove espaços e converte para maiúsculas
  PlayerId normalize() => PlayerId(value.replaceAll(' ', '').toUpperCase());

  // Válido se entre 3 e 12 caracteres, apenas A-Z e 0-9
  bool get isValido =>
      value.length >= 3 &&
      value.length <= 12 &&
      RegExp(r'^[A-Z0-9]+$').hasMatch(value);

  @override
  String toString() => value;

  // Permite usar PlayerId como chave em Map
  @override
  bool operator ==(Object other) =>
      other is PlayerId && value == other.value;
  @override
  int get hashCode => value.hashCode;
}

// Classe chamável para cálculo de bônus
// Classe chamável para cálculo de bônus
// Permite usar BonusCalc como função
class BonusCalc {
  // Calcula os pontos finais de acordo com o tipo da jogada e streak
  int call({required int base, String? tipo, required int streak}) {
    int pontos;
    switch (tipo) {
      case 'boss':
        // Boss: dobra base e soma 10 por streak
        pontos = base * 2 + 10 * streak;
        break;
      case 'hard':
        // Hard: se base >= 100, soma 20 extra
        if (base >= 100) {
          pontos = base + 5 * streak + 20;
        } else {
          pontos = base + 5 * streak;
        }
        break;
      case 'normal':
        // Normal: soma 2 por streak
        pontos = base + 2 * streak;
        break;
      default:
        // Outros casos: só base
        pontos = base;
    }
    // Garante que o retorno fique entre 0 e 999
    return pontos.clamp(0, 999);
  }
}

// Função que retorna um resumo do placar
// total: soma dos pontos de todos os jogadores
// media: média dos pontos por jogador
// topo: jogador com maior pontuação
({int total, double media, (PlayerId id, int pontos) topo}) resumir(Map<PlayerId, int> placar) {
  final total = placar.values.fold(0, (a, b) => a + b);
  final media = placar.isEmpty ? 0.0 : total / placar.length;
  final topo = placar.entries
      .reduce((a, b) => a.value >= b.value ? a : b);
  return (
    total: total,
    media: media,
    topo: (topo.key, topo.value),
  );
}

void main() {
  final calc = BonusCalc(); // Instancia a classe chamável
  final placar = <PlayerId, int>{}; // Mapa de pontuação por jogador
  final streaks = <PlayerId, int>{}; // Mapa de streaks por jogador
  PlayerId? ultimoId; // Último jogador processado

  for (final jogada in jogadas) {
    // Desestruturação do record da jogada
    var (rawId, base, tipo) = jogada;
    // Normaliza e valida o id
    final id = PlayerId(rawId).normalize();
    if (!id.isValido) continue; // Ignora jogadas com id inválido

    // Streak: incrementa se mesmo jogador, senão reinicia
    final streak = (ultimoId == id) ? (streaks[id] ?? 0) + 1 : 1;
    streaks[id] = streak;
    ultimoId = id;

    // Calcula pontos finais usando a classe chamável
    final pontosFinais = calc(base: base, tipo: tipo, streak: streak);
    placar[id] = (placar[id] ?? 0) + pontosFinais;

    // Imprime o processamento da jogada
    print('Jogador: $id | Streak: $streak | Pontos: $pontosFinais');
  }

  // Placar ordenado decrescente
  final ordenado = placar.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  print('\nPlacar final:');
  for (final e in ordenado) {
    print('${e.key}: ${e.value}');
  }

  // Resumo final usando desestruturação de record nomeado
  final (:total, :media, topo: (topId, topPts)) = resumir(placar);
  print('\nResumo:');
  print('Total: $total | Média: ${media.toStringAsFixed(2)} | Topo: $topId ($topPts)');
}