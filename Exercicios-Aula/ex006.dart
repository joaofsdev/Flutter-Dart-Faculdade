// Importa a biblioteca para criar listas imutáveis
import 'dart:collection';

// Classe que representa um item do carrinho
class Item {
  // Nome do item
  final String nome;
  // Preço unitário do item
  final double preco;
  // Quantidade do item
  final int qtd;

  // Construtor com validações usando asserts para garantir dados válidos
  Item({required this.nome, required this.preco, this.qtd = 1})
      : assert(nome.trim().isNotEmpty, 'nome vazio'), // nome não pode ser vazio
        assert(preco >= 0, 'preço negativo'),         // preço não pode ser negativo
        assert(qtd > 0, 'qtd deve ser > 0');          // quantidade deve ser positiva

  // Factory que cria um Item a partir de um Map<String, dynamic>
  // Útil para converter dados vindos de JSON ou banco de dados
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      nome: map['nome'] as String,
      preco: (map['preco'] as num).toDouble(),
      qtd: map['qtd'] as int,
    );
  }

  // Representação textual do item para facilitar debug e impressão
  @override
  String toString() => 'Item($nome, R\$ ${preco.toStringAsFixed(2)}, x$qtd)';
}

// Classe que representa o carrinho de compras
class Carrinho {
  // Lista interna de itens do carrinho
  final List<Item> _itens;

  // Construtor que copia a lista recebida para evitar alterações externas
  Carrinho(List<Item> itens) : _itens = List.of(itens);

  // Getter que retorna uma lista imutável dos itens
  // Garante que ninguém fora da classe possa modificar os itens
  UnmodifiableListView<Item> get itens => UnmodifiableListView(_itens);
}

// Extension que adiciona funcionalidades à lista de itens
extension ListaDeItensX on List<Item> {
  // Calcula o valor total dos itens da lista
  double total() => fold(0, (soma, item) => soma + item.preco * item.qtd);

  // Retorna os nomes dos itens separados por vírgula
  String nomes() => [for (final i in this) i.nome].join(', ');
}

void main() {
  // Simula dados vindos de uma fonte externa, como JSON
  final dados = <Map<String, dynamic>>[
    {'nome': 'Poção de Vida', 'preco': 12.5, 'qtd': 2},
    {'nome': 'Espada Curta', 'preco': 80, 'qtd': 1},
    {'nome': 'Escudo de Madeira', 'preco': 35, 'qtd': 1},
  ];

  // Cria a lista base de itens usando collection-for
  // Transforma cada Map em um objeto Item
  final base = <Item>[for (final m in dados) Item.fromMap(m)];

  // Define se o brinde será incluído
  const incluirBrinde = true;
  // Cria o item brinde
  final Item brinde = Item(
    nome: 'Mapa da Cidade',
    preco: 0,
    qtd: 1,
  );

  // Monta a lista final de itens usando spread operator e if condicional
  // Adiciona o brinde apenas se incluirBrinde for true
  final itens = [
    ...base,
    if (incluirBrinde) brinde,
  ];

  // Instancia o carrinho com os itens
  final carrinho = Carrinho(itens);
  // Imprime os nomes dos itens do carrinho
  print('Itens: ${carrinho.itens.nomes()}');
  // Imprime o valor total do carrinho formatado
  print('Total: R\$ ${carrinho.itens.total().toStringAsFixed(2)}');

  // Demonstração de imutabilidade: a linha abaixo não compila
  // carrinho.itens.add(Item(nome: 'Hack', preco: 0)); // <- não compila
}
