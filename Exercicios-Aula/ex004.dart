// Classe que representa um produto com nome, preço e desconto opcional
// Permite calcular preço final e gerar etiquetas formatadas
class Produto {
  // Nome do produto (obrigatório)
  final String nome;
  
  // Preço base do produto (obrigatório)
  final double preco;
  
  // Percentual de desconto (opcional - pode ser null)
  // O símbolo ? após double indica que a variável pode receber null
  final double? desconto;

  // Construtor da classe Produto
  // Parâmetros:
  // - nome: obrigatório (nomeado)
  // - preco: obrigatório (nomeado)
  // - desconto: opcional (nomeado)
  Produto({required this.nome, required this.preco, this.desconto});

  // Calcula o preço final do produto aplicando o desconto
  // Se não houver desconto, retorna o preço original
  // Fórmula: preço * (1 - desconto/100)
  // Retorna o preço final calculado
  double precoFinal() {
    // Define o desconto como 0 se não for fornecido
    final d = desconto ?? 0;
    
    // Calcula e retorna o preço com desconto aplicado
    return preco * (1 - d / 100);
  }

  // Gera uma etiqueta formatada para o produto
  // Parâmetros:
  // - moeda: opcional, usa 'R$' como padrão se não for fornecida
  // Retorna uma string formatada com nome, moeda e preço final
  String etiqueta({String? moeda}) {
    // Define a moeda padrão se nenhuma for fornecida
    final m = moeda ?? 'R\$';
    
    // Calcula o preço final do produto
    final valor = precoFinal();
    
    // Retorna a etiqueta formatada com nome, moeda e preço (2 casas decimais)
    return '$nome - $m ${valor.toStringAsFixed(2)}';
  }
}

// Função principal que executa o programa
void main() {
  // Cria o primeiro produto: Café sem desconto
  // Usa moeda padrão R$ e preço original
  final p1 = Produto(nome: 'Cafe', preco: 15);
  
  // Cria o segundo produto: Leite com 10% de desconto
  // Usa moeda padrão R$ e aplica desconto no preço
  final p2 = Produto(nome: 'Leite', preco: 5, desconto: 10);
  
  // Cria o terceiro produto: Fermento com 25% de desconto
  // Usa moeda padrão R$ e aplica desconto no preço
  final p3 = Produto(nome: 'Fermento', preco: 1, desconto: 25);

  // Teste 1: Mostra etiqueta do Café (sem desconto, moeda R$)
  print(p1.etiqueta());
  
  // Teste 2: Mostra etiqueta do Leite (10% desconto, moeda R$)
  print(p2.etiqueta());
  
  // Teste 3: Mostra etiqueta do Fermento (25% desconto, moeda USD)
  print(p3.etiqueta(moeda: 'USD'));
}
