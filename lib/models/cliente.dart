class Cliente {
  final String id;
  final String nome;
  final String email;
  final String endereco;
  final String telefone;
  final DateTime data_hora_criacao;
  final int id_usuario_criacao;
  final bool deletado;
  final String? data_hora_deletado;

  Cliente({
    required this.id,
    required this.nome,
    required this.email,
    required this.endereco,
    required this.telefone,
    required this.data_hora_criacao,
    required this.id_usuario_criacao,
    required this.deletado,
    this.data_hora_deletado,
  });

  factory Cliente.fromApi(dynamic apiModel) {
    DateTime parseDateTime(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }

    return Cliente(
      id: apiModel.id?.toString() ?? '0',
      nome: apiModel.nome ?? '',
      email: apiModel.email ?? '',
      endereco: apiModel.endereco ?? '',
      telefone: apiModel.telefone ?? '',
      data_hora_criacao: parseDateTime(apiModel.data_hora_criacao),
      id_usuario_criacao: apiModel.id_usuario_criacao ?? 0,
      deletado: apiModel.deletado ?? false,
      data_hora_deletado: apiModel.data_hora_deletado,
    );
  }
}
