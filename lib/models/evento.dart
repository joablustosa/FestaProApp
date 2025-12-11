class Evento {
  final int id;
  final String? data_hora_criacao;
  final int id_usuario_criacao;
  final bool deletado;
  final String? data_hora_deletado;
  final int id_usuario;
  final int id_cliente;
  final double valor;
  final String? data_hora_inicio;
  final String? data_hora_fim;
  final bool confirmado;
  final int prioridade;
  final String? data_hora_confirmado;
  final String? forma_de_pagamento;

  Evento({
    this.id = 0,
    this.data_hora_criacao,
    this.id_usuario_criacao = 0,
    this.deletado = false,
    this.data_hora_deletado,
    this.id_usuario = 0,
    this.id_cliente = 0,
    this.valor = 0.0,
    this.data_hora_inicio,
    this.data_hora_fim,
    this.confirmado = false,
    this.prioridade = 0,
    this.data_hora_confirmado,
    this.forma_de_pagamento,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_hora_criacao': data_hora_criacao,
      'id_usuario_criacao': id_usuario_criacao,
      'deletado': deletado,
      'data_hora_deletado': data_hora_deletado,
      'id_usuario': id_usuario,
      'id_cliente': id_cliente,
      'valor': valor,
      'data_hora_inicio': data_hora_inicio,
      'data_hora_fim': data_hora_fim,
      'confirmado': confirmado,
      'prioridade': prioridade,
      'data_hora_confirmado': data_hora_confirmado,
      'forma_de_pagamento': forma_de_pagamento,
    };
  }

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] ?? 0,
      data_hora_criacao: json['data_hora_criacao'],
      id_usuario_criacao: json['id_usuario_criacao'] ?? 0,
      deletado: json['deletado'] ?? false,
      data_hora_deletado: json['data_hora_deletado'],
      id_usuario: json['id_usuario'] ?? 0,
      id_cliente: json['id_cliente'] ?? 0,
      valor: (json['valor'] ?? 0).toDouble(),
      data_hora_inicio: json['data_hora_inicio'],
      data_hora_fim: json['data_hora_fim'],
      confirmado: json['confirmado'] ?? false,
      prioridade: json['prioridade'] ?? 0,
      data_hora_confirmado: json['data_hora_confirmado'],
      forma_de_pagamento: json['forma_de_pagamento'],
    );
  }
}
