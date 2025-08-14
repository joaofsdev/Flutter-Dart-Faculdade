class Personagem {
  final String nome;
  final int nivel;
  final int? forca; // ? serve para tratar valores nulos ou valores que nao definimos no construtor.
  final String? apelido;

  Personagem(this.nome, {this.nivel = 1, this.forca, this.apelido}); // No parenteses e obrigado a passar valor, ja na chaves nao.
                                                                    // this e usado para parametros nomeados/opcionais para passarmos valores chamando o nome

  int poder() {
    return (forca ?? 10) * nivel;
  }

  String descricao({String? saudacao}) {
    final s = saudacao ?? "Olá";
    final chamado = apelido ?? nome;
    return '$s, eu sou $chamado (nível $nivel). Poder: ${poder()}';
  }
}

void main() {
  final p1 = Personagem('Aria');

  final p2 = Personagem('Rurik', nivel: 3, forca: 12, apelido: 'Lobo');

  print(p1.descricao());
  print(p2.descricao(saudacao: 'Oi'));
}
