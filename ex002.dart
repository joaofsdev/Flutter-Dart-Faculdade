double precoFinal(
  double preco, {
  double? desconto,
  double frete = 0,
  String? cupom,
}) {
  // TODO 1: se desconto for null, use 0
  final d = desconto ?? 0;

  // TODO 2: se cupom (case-insensitive) for "FRETEGRATIS", frete = 0
  final temFreteGratis = cupom?.toUpperCase() == 'FRETEGRATIS', frete = 0;
  final freteAplicado = temFreteGratis ? 0 : frete;

  // TODO 3: retorne preco com desconto + freteAplicado
  return (preco * (1 - d / 100) + freteAplicado);
}

String resumoPedido(
  double preco, {
  double? desconto,
  double frete = 0,
  String? cupom,
}) {
  final total = precoFinal(
    preco,
    desconto: desconto,
    frete: frete,
    cupom: cupom,
  );

  // TODO 4: use ?? para exibir desconto 0 quando for null e "-" para cupom null
  final d = desconto ?? 0 /* desconto ?? 0 */;
  final c = cupom ?? '-';

  // TODO 5: reusar a mesma regra do cupom para mostrar o frete realmente aplicado
  final freteAplicado = (cupom?.toUpperCase() == 'FRETEGRATIS') ? 0 : frete;
  frete;

  // TODO 6: formate números com 2 casas (toStringAsFixed)
  return 'Preço: R\$ ${preco.toStringAsFixed(2)}'
      ' | Desc: ${d.toStringAsFixed(0)}%'
      ' | Frete: R\$ ${freteAplicado.toStringAsFixed(2)}'
      ' | Cupom: $c'
      ' | Total: R\$ ${total.toStringAsFixed(2)}';
}

void main() {
  // Exemplo 1
  print(resumoPedido(100, desconto: 10, frete: 20));

  // Exemplo 2 (cupom frete grátis, qualquer mistura de maiúsc./minúsc. deve funcionar)
  print(resumoPedido(100, frete: 15, cupom: 'freteGRATIS'));

  // Exemplo 3 (apenas preço; demais ausentes)
  print(resumoPedido(59.9));
}
