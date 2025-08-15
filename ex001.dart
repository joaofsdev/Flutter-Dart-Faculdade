// Classe que representa um personagem em um jogo ou sistema
// Contém informações básicas como nome, nível, força e apelido
class Personagem {
  // Nome do personagem (obrigatório)
  final String nome;
  
  // Nível do personagem (padrão é 1)
  final int nivel;
  
  // Força do personagem (opcional - pode ser null)
  // O símbolo ? após int indica que a variável pode receber null
  // Se não for definida, assume valor padrão 10
  final int? forca;
  
  // Apelido do personagem (opcional - pode ser null)
  // O símbolo ? após String indica que a variável pode receber null
  // Se não for definido, usa o nome real
  final String? apelido;

  // Construtor da classe Personagem
  // Parâmetros:
  // - nome: obrigatório (posicional)
  // - nivel: opcional com valor padrão 1 (nomeado)
  // - forca: opcional (nomeado)
  // - apelido: opcional (nomeado)
  Personagem(this.nome, {this.nivel = 1, this.forca, this.apelido});

  // Calcula o poder total do personagem
  // Fórmula: força (ou 10 se for null) multiplicada pelo nível
  // Retorna o valor do poder calculado
  int poder() {
    return (forca ?? 10) * nivel;
  }

  // Gera uma descrição completa do personagem
  // Parâmetros:
  // - saudacao: opcional, usa "Olá" como padrão se não for fornecida
  // Retorna uma string formatada com todas as informações do personagem
  String descricao({String? saudacao}) {
    // Define a saudação padrão se nenhuma for fornecida
    final s = saudacao ?? "Olá";
    
    // Usa o apelido se disponível, senão usa o nome real
    final chamado = apelido ?? nome;
    
    // Retorna a descrição completa formatada
    return '$s, eu sou $chamado (nível $nivel). Poder: ${poder()}';
  }
}

// Função principal que executa o programa
void main() {
  // Cria o primeiro personagem com apenas o nome obrigatório
  // Usa valores padrão para nível (1), força (null) e apelido (null)
  final p1 = Personagem('Aria');

  // Cria o segundo personagem com todos os parâmetros personalizados
  // Nível 3, força 12 e apelido 'Lobo'
  final p2 = Personagem('Rurik', nivel: 3, forca: 12, apelido: 'Lobo');

  // Teste 1: Mostra descrição do primeiro personagem com saudação padrão
  print(p1.descricao());
  
  // Teste 2: Mostra descrição do segundo personagem com saudação personalizada
  print(p2.descricao(saudacao: 'Oi'));
}
