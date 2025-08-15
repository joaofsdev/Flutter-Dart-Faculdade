// Função para validar se uma nota está dentro do intervalo válido (0 a 10)
// Retorna true se a nota for válida, false caso contrário
bool notaValida(double n) => n >= 0 && n <= 10;

// Função para calcular a média de notas
// Parâmetros:
// - n1: primeira nota (obrigatória)
// - n2: segunda nota (obrigatória) 
// - n3: terceira nota (opcional)
// Retorna a média calculada ou null se alguma nota for inválida
double? media({
  required double? n1,
  required double? n2,
  double? n3,
}) {
  // Valida se todas as notas fornecidas estão dentro do intervalo válido
  // Se n3 for null, não é validado (é opcional)
  if (!(notaValida(n1!) && notaValida(n2!) && (n3 == null || notaValida(n3))))
    return null;

  // Soma todas as notas, tratando n3 como 0 se for null
  final soma = n1 + n2 + (n3 ?? 0);

  // Define a quantidade de notas para o cálculo da média
  final qtd = 3;

  // Retorna a média aritmética (soma dividida pela quantidade)
  return (soma / qtd);
}

// Função para determinar o conceito baseado na média
// Retorna uma letra de A a E conforme a faixa de média:
// A: 9.0 ou superior
// B: 7.5 a 8.9
// C: 6.0 a 7.4
// D: 4.0 a 5.9
// E: abaixo de 4.0
String conceito(double m) {
  if (m >= 9.0) return 'A';
  if (m >= 7.5) return 'B';
  if (m >= 6.0) return 'C';
  if (m >= 4.0) return 'D';
  return 'E';
}

// Função principal que gera um resumo completo das notas
// Parâmetros:
// - n1: primeira nota (obrigatória)
// - n2: segunda nota (obrigatória)
// - n3: terceira nota (opcional)
// Retorna uma string formatada com todas as informações das notas
String resumoNotas({
  required double? n1,
  required double? n2,
  double? n3,
}) {
  // Calcula a média das notas fornecidas
  final m = media(n1: n1, n2: n2, n3: n3);

  // Se a média for null, significa que alguma nota é inválida
  if (m == null) {
    return 'Notas inválidas';
  }

  // Formata a terceira nota ou mostra '-' se não for fornecida
  final n3Txt = n3?.toStringAsFixed(1) ?? '-';
  
  // Constrói e retorna o resumo formatado com todas as informações:
  // N1, N2, N3 (ou '-'), média calculada e conceito correspondente
  return 'N1:${n1!.toStringAsFixed(1)}'
      'N2:${n2!.toStringAsFixed(1)} '
      'N3:$n3Txt  '
      'Média:${m.toStringAsFixed(2)}'
      'Conceito:${ conceito(m)}';
}

// Função principal que executa o programa
void main() {
  // Teste 1: Calcula média com apenas 2 notas (sem N3)
  print(resumoNotas(n1: 8.0, n2: 7.0)); // sem N3
  
  // Teste 2: Calcula média com 3 notas (incluindo N3)
  print(resumoNotas(n1: 9.2, n2: 6.8, n3: 7.5)); // com N3
  
  // Teste 3: Testa validação com nota inválida (11.0 > 10.0)
  print(resumoNotas(n1: 11.0, n2: 8.0)); // inválida
}
