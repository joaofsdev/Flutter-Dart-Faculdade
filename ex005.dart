// Classe que representa uma missão em um jogo ou sistema de tarefas
// Permite gerenciar missões com ID, título, recompensa, descrição e status de conclusão
class Missao {
  // ID único da missão (opcional - pode ser null)
  // O símbolo ? após int indica que a variável pode receber null
  int? id;
  
  // Título da missão (obrigatório)
  final String titulo;
  
  // Recompensa em pontos ou moeda (opcional - pode ser null)
  int? recompensa;
  
  // Descrição detalhada da missão (opcional - pode ser null)
  String? descricao;
  
  // Status de conclusão da missão (padrão false)
  bool concluida;

  // Construtor da classe Missao com parâmetros nomeados
  // Parâmetros:
  // - id: opcional (nomeado)
  // - titulo: obrigatório (nomeado com required)
  // - recompensa: opcional (nomeado)
  // - descricao: opcional (nomeado)
  // - concluida: opcional com valor padrão false (nomeado)
  Missao({this.id, required this.titulo, this.recompensa, this.descricao, this.concluida = false});

  // Factory constructor que cria uma Missao a partir de um Map
  // Útil para converter dados JSON ou Map em objetos Missao
  // Parâmetros:
  // - map: Map contendo os dados da missão
  // Retorna uma nova instância de Missao com os dados do Map
  factory Missao.fromMap(Map<String, dynamic> map) {
    return Missao(
      // Converte o ID para int ou mantém null se não existir
      id: map['id'] as int?,
      
      // Título obrigatório, usa valor padrão se não fornecido
      titulo: map['titulo'] as String? ?? 'Missão sem título',
      
      // Recompensa opcional, mantém null se não existir
      recompensa: map['recompensa'] as int?,
      
      // Descrição opcional, mantém null se não existir
      descricao: map['descricao'] as String?,
      
      // Status de conclusão, usa false como padrão se não fornecido
      concluida: map['concluida'] as bool? ?? false,
    );
  }

  // Calcula os pontos de experiência (XP) da missão
  // Fórmula: 50 + (recompensa/10) + (tamanho da descrição/20)
  // Usa operadores null-aware para tratar valores nulos com segurança
  // Retorna o total de XP calculado
  int xp() {
    // 50 pontos base + recompensa dividida por 10 (ou 0 se nula)
    // + tamanho da descrição dividido por 20 (ou 0 se nula)
    return 50 + (recompensa ?? 0) ~/ 10 + (descricao?.length ?? 0) ~/ 20;
  }

  // Marca a missão como concluída
  // Altera o estado interno da missão para true
  void marcarConcluida() {
    concluida = true;
  }

  // Gera um resumo completo da missão em formato de texto
  // Usa operadores null-aware para tratar campos opcionais
  // Retorna uma string formatada com todas as informações da missão
  String resumo() {
    // Converte ID para string ou usa '-' se for null
    final idStr = id?.toString() ?? '-';
    
    // Usa descrição fornecida ou texto padrão se for null
    final d = descricao ?? '(sem desc.)';
    
    // Retorna o resumo formatado com todas as informações
    return '[$idStr] $titulo | XP=${xp()} | Concluída: $concluida | Desc: $d';
  }
}

// Função principal que executa o programa
void main() {
  // Dados brutos simulando um arquivo JSON ou banco de dados
  // Cada Map representa uma missão com seus campos
  final dadosBrutos = <Map<String, dynamic>>[
    {'id': 1, 'titulo': 'Caçar slimes', 'recompensa': 120},
    {'titulo': 'Entregar carta', 'descricao': 'Levar ao vilarejo vizinho'},
    {'id': 3, 'titulo': 'Explorar caverna', 'recompensa': null, 'concluida': true},
  ];

  // Converte os dados brutos em objetos Missao usando a factory
  // Cada Map é transformado em uma instância da classe Missao
  final missoes = dadosBrutos.map((dados) => Missao.fromMap(dados)).toList();

  // Cria uma missão extra para demonstrar funcionalidades adicionais
  // Esta missão não tem ID inicial e será configurada posteriormente
  var extra = Missao(titulo: 'Treino', recompensa: 80);

  // Calcula o próximo ID disponível baseado no maior ID existente
  // Usa operadores null-aware para tratar IDs nulos
  final maiorId = missoes
      .map((m) => m.id ?? 0)  // Substitui null por 0 para comparação
      .fold<int>(0, (acc, v) => v > acc ? v : acc);  // Encontra o maior valor
  final proximoId = maiorId + 1;  // Gera o próximo ID sequencial

  // Define o ID da missão extra apenas se ainda for null
  // Operador ??= só atribui valor se a variável for null
  extra.id ??= proximoId;

  // Usa operador cascata para executar múltiplas operações na missão extra
  // Marca como concluída e define descrição padrão se ainda for null
  extra
    ..marcarConcluida()  // Marca a missão como concluída
    ..descricao ??= 'Sessão rápida de treino';  // Define descrição se for null

  // Imprime o resumo de todas as missões (incluindo a extra)
  // Combina a lista de missões com a missão extra usando spread operator
  for (final m in [...missoes, extra]) {
    print(m.resumo());
  }
}
