class Financa {
  int? id;
  String? descricao;
  String? notas;
  String recorrencia;
  int? qtdRecorrencia;
  double valor;
  DateTime dataFinanca;
  bool entrada;

  Financa({
    this.id,
    this.descricao,
    this.notas,
    required this.recorrencia,
    this.qtdRecorrencia,
    required this.valor,
    required this.dataFinanca,
    required this.entrada,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'notas': notas,
      'recorrencia': recorrencia,
      'qtd_recorrencia': qtdRecorrencia,
      'valor': valor,
      'data_financa': dataFinanca.millisecondsSinceEpoch,
      'entrada': entrada ? 1 : 0,
    };
  }

  factory Financa.fromMap(Map<String, dynamic> map) {
    int? date;
    date = map['data_financa'];
    int ent = map['entrada'];
    return Financa(
      id: map['id'],
      descricao: map['descricao'],
      notas: map['notas'],
      recorrencia: map['recorrencia'],
      qtdRecorrencia: map['qtd_recorrencia'],
      valor: map['valor'],
      dataFinanca: DateTime.fromMillisecondsSinceEpoch(date!),
      entrada: ent == 1 ? true : false,
    );
  }
}
