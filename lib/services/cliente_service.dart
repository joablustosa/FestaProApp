import '../models/api_models.dart';
import '../models/cliente.dart';
import 'api_service.dart';

class ClienteService {
  static final ClienteService _instance = ClienteService._internal();
  factory ClienteService() => _instance;
  ClienteService._internal();

  final ApiService _apiService = ApiService();
  List<UserApi> _clientesApi = []; // Agora usando UserApi
  bool _isInitialized = false;

  // Inicializar o serviço
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _apiService.initialize();
      await _refreshClientes();
      _isInitialized = true;
    }
  }

  // Buscar clientes da API
  Future<void> _refreshClientes() async {
    try {
      print('🔄 === INICIANDO REFRESH DE CLIENTES ===');
      print('Verificando se ApiService está inicializado...');

      if (!_apiService.isInitialized) {
        print('⚠️ ApiService não está inicializado, inicializando...');
        await _apiService.initialize();
      }

      print('✅ ApiService está inicializado');

      // Testar conectividade primeiro
      print('🧪 Testando conectividade com a API...');
      final isConnected = await _apiService.testConnection();
      if (!isConnected) {
        print('❌ API não está respondendo');
        throw Exception('API não está respondendo');
      }

      print('✅ API está respondendo');
      print('📡 Fazendo chamada para /api/Users/v1?userType=2...');

      // Buscar usuários com userType = 2 (clientes)
      final users = await _apiService.getUsers(userType: 2);
      _clientesApi = users;

      print('✅ Clientes carregados da API: ${_clientesApi.length}');
      print(
          '📊 Clientes ativos: ${_clientesApi.where((c) => c.status != 0 || c.userStatus != 0).length}');
      print(
          '📊 Clientes inativos: ${_clientesApi.where((c) => c.status == 0 && c.userStatus == 0).length}');

      // Log detalhado dos primeiros clientes
      if (_clientesApi.isNotEmpty) {
        print('📋 Primeiros clientes:');
        for (var i = 0;
            i < (_clientesApi.length > 3 ? 3 : _clientesApi.length);
            i++) {
          final c = _clientesApi[i];
          print(
              '  ${i + 1}. ID: ${c.id}, Nome: ${c.nomeCompleto}, Status: ${c.status}');
        }
      }

      print('=== REFRESH DE CLIENTES CONCLUÍDA ===');
    } catch (e) {
      print('❌ ERRO ao buscar clientes da API: $e');
      print('Stack trace: ${StackTrace.current}');
      // Em caso de erro, usar lista vazia
      _clientesApi = [];
    }
  }

  // Obter todos os clientes da API (agora são Users com userType=2)
  Future<List<UserApi>> getClientesApi(
      {bool apenasNaoDeletados = false}) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (apenasNaoDeletados) {
      // Filtrar apenas clientes com status ativo (status != 0 ou userStatus != 0)
      return _clientesApi.where((c) => c.status != 0 || c.userStatus != 0).toList();
    }

    return List.from(_clientesApi);
  }

  // Obter cliente por ID da API
  Future<UserApi?> getClienteById(int id) async {
    try {
      return await _apiService.getUserById(id);
    } catch (e) {
      print('Erro ao buscar cliente por ID: $e');
      return null;
    }
  }

  // Criar novo cliente na API (agora como User com userType=2)
  Future<UserApi?> createCliente(UserApi cliente) async {
    try {
      // Garantir que userType seja 2
      final clienteCompleto = UserApi(
        id: cliente.id,
        usuarioLogin: cliente.usuarioLogin ?? cliente.email,
        chaveDeAcesso: cliente.chaveDeAcesso,
        lastName: cliente.lastName,
        address: cliente.address,
        firstName: cliente.firstName ?? cliente.usuarioLogin,
        city: cliente.city,
        cpf: cliente.cpf,
        born: cliente.born,
        image: cliente.image,
        dooName: cliente.dooName,
        email: cliente.email,
        contact: cliente.contact,
        whatsapp: cliente.whatsapp,
        instagram: cliente.instagram,
        facebook: cliente.facebook,
        linkedin: cliente.linkedin,
        userType: 2, // Cliente
        accountType: cliente.accountType,
        userStatus: cliente.userStatus,
        dateTimeStatus: cliente.dateTimeStatus,
        status: cliente.status,
        id_enterprise: cliente.id_enterprise,
        cep: cliente.cep,
        neighborhood: cliente.neighborhood,
        tenant_id: cliente.tenant_id,
      );

      final novoCliente = await _apiService.createUser(clienteCompleto);

      // Adicionar à lista local
      _clientesApi.add(novoCliente);

      return novoCliente;
    } catch (e) {
      print('Erro ao criar cliente: $e');
      return null;
    }
  }

  // Atualizar cliente na API
  Future<UserApi?> updateCliente(int id, UserApi cliente) async {
    try {
      final clienteAtualizado = await _apiService.updateUser(id, cliente);

      // Atualizar na lista local
      final index = _clientesApi.indexWhere((c) => c.id == id);
      if (index != -1) {
        _clientesApi[index] = clienteAtualizado;
      }

      return clienteAtualizado;
    } catch (e) {
      print('Erro ao atualizar cliente: $e');
      return null;
    }
  }

  // Buscar clientes por nome
  Future<List<UserApi>> buscarClientesPorNome(String nome) async {
    if (!_isInitialized) {
      await initialize();
    }

    return _clientesApi
        .where((cliente) {
          final nomeCompleto = cliente.nomeCompleto.toLowerCase();
          final firstName = cliente.firstName?.toLowerCase() ?? '';
          final lastName = cliente.lastName?.toLowerCase() ?? '';
          final searchTerm = nome.toLowerCase();
          return nomeCompleto.contains(searchTerm) || 
                 firstName.contains(searchTerm) || 
                 lastName.contains(searchTerm);
        })
        .toList();
  }

  // Obter total de clientes
  int getTotalClientes() {
    return _clientesApi.length;
  }

  // Refresh manual dos clientes
  Future<void> refreshClientes() async {
    await _refreshClientes();
  }

  // Converter UserApi para Cliente (compatibilidade)
  Cliente _convertToCliente(UserApi userApi) {
    return Cliente(
      id: userApi.id.toString(),
      nome: userApi.nomeCompleto,
      email: userApi.email ?? '',
      endereco: userApi.address ?? '',
      telefone: userApi.contact ?? userApi.whatsapp ?? '',
      data_hora_criacao: _parseDateTime(userApi.dateTimeStatus),
      id_usuario_criacao: 0,
      deletado: userApi.status == 0,
      data_hora_deletado: null,
    );
  }

  // Método auxiliar para fazer parse seguro de data
  DateTime _parseDateTime(String? dataString) {
    try {
      if (dataString == null || dataString.isEmpty) {
        return DateTime.now();
      }
      return DateTime.parse(dataString);
    } catch (e) {
      print('Erro ao fazer parse da data: $dataString - $e');
      return DateTime.now();
    }
  }

  // Obter todos os clientes (método de compatibilidade)
  List<Cliente> getClientes() {
    return _clientesApi.map(_convertToCliente).toList();
  }

  // Adicionar cliente (método de compatibilidade)
  void adicionarCliente(Cliente cliente) {
    // Separar nome em firstName e lastName
    final nomeParts = cliente.nome.split(' ');
    final firstName = nomeParts.isNotEmpty ? nomeParts[0] : '';
    final lastName = nomeParts.length > 1 ? nomeParts.sublist(1).join(' ') : '';

    final userApi = UserApi(
      id: 0,
      usuarioLogin: cliente.email,
      chaveDeAcesso: '',
      firstName: firstName,
      lastName: lastName,
      email: cliente.email,
      address: cliente.endereco,
      contact: cliente.telefone,
      userType: 2, // Cliente
      status: cliente.deletado ? 0 : 1,
    );

    createCliente(userApi);
  }
}
