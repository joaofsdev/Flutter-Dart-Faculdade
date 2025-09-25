// Função para calcular o preço final de um produto
// Parâmetros:
// - preco: preço base do produto (obrigatório)
// - desconto: percentual de desconto (opcional, padrão 0%)
// - frete: valor do frete (opcional, padrão R$ 0)
// - cupom: código do cupom (opcional, pode dar frete grátis)
// Retorna o preço final calculado com desconto e frete
double precoFinal(
  double preco, {
  double? desconto,
  double frete = 0,
  String? cupom,
}) {
  // Define o desconto como 0 se não for fornecido
  final d = desconto ?? 0;

  // Verifica se o cupom 'FRETEGRATIS' foi usado (case insensitive)
  // Se sim, o frete fica grátis (0), senão usa o valor do frete fornecido
  final temFreteGratis = cupom?.toUpperCase() == 'FRETEGRATIS';
  final freteAplicado = temFreteGratis ? 0 : frete;

  // Calcula o preço final: preço com desconto + frete aplicado
  // Fórmula: preço * (1 - desconto/100) + frete
  return (preco * (1 - d / 100) + freteAplicado);
}

// Função para gerar um resumo completo do pedido
// Parâmetros:
// - preco: preço base do produto (obrigatório)
// - desconto: percentual de desconto (opcional)
// - frete: valor do frete (opcional)
// - cupom: código do cupom (opcional)
// Retorna uma string formatada com todas as informações do pedido
String resumoPedido(
  double preco, {
  double? desconto,
  double frete = 0,
  String? cupom,
}) {
  // Calcula o preço final usando a função precoFinal
  final total = precoFinal(
    preco,
    desconto: desconto,
    frete: frete,
    cupom: cupom,
  );

  // Define valores padrão para desconto e cupom se não fornecidos
  final d = desconto ?? 0;
  final c = cupom ?? '-';

  // Calcula o frete aplicado baseado no cupom
  // Se o cupom for 'FRETEGRATIS', frete = 0, senão usa o valor fornecido
  final freteAplicado = (cupom?.toUpperCase() == 'FRETEGRATIS') ? 0 : frete;

  // Constrói e retorna o resumo formatado com todas as informações:
  // Preço base, desconto aplicado, frete, cupom usado e total final
  return 'Preço: R\$ ${preco.toStringAsFixed(2)}'
      ' | Desc: ${d.toStringAsFixed(0)}%'
      ' | Frete: R\$ ${freteAplicado.toStringAsFixed(2)}'
      ' | Cupom: $c'
      ' | Total: R\$ ${total.toStringAsFixed(2)}';
}

// Função principal que executa o programa
void main() {
  // Teste 1: Pedido com desconto de 10% e frete de R$ 20
  // Mostra como o desconto é aplicado e o frete é cobrado
  print(resumoPedido(100, desconto: 10, frete: 20));

  // Teste 2: Pedido com cupom 'freteGRATIS' (frete grátis)
  // Demonstra como o cupom pode zerar o valor do frete
  print(resumoPedido(100, frete: 15, cupom: 'freteGRATIS'));

  // Teste 3: Pedido simples sem desconto, frete ou cupom
  // Mostra o comportamento padrão com valores mínimos
  print(resumoPedido(59.9));
}
