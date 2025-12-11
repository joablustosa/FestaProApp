import '../models/api_models.dart';
import 'api_service.dart';

class UsuarioService {
  static final UsuarioService _instance = UsuarioService._internal();
  factory UsuarioService() => _instance;
  UsuarioService._internal();

  final ApiService _apiService = ApiService();

  UsuarioApi? _usuarioAtual;
  bool _isInitialized = false;

  UsuarioApi? get usuarioAtual => _usuarioAtual;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      await _apiService.initialize();
      _isInitialized = true;
    } catch (e) {
      print('Erro ao inicializar UsuarioService: $e');
      _isInitialized = true;
    }
  }

  Future<UsuarioApi> getUsuarioById(int id) async {
    try {
      final usuario = await _apiService.getUsuario(id);

      if (_usuarioAtual?.id == id || _usuarioAtual == null) {
        _usuarioAtual = usuario;
      }

      return usuario;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UsuarioApi>> getUsuarios() async {
    try {
      final response = await _apiService.get('/api/Users/v1');

      if (response is List) {
        return response
            .map((u) => UsuarioApi.fromJson(Map<String, dynamic>.from(u)))
            .toList();
      } else {
        throw Exception(
            'Formato de resposta inesperado para lista de usuários');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UsuarioApi> createUsuario(UsuarioApi usuario) async {
    try {
      final response =
          await _apiService.post('/api/Users/v1', usuario.toJson());

      return UsuarioApi.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UsuarioApi> updateUsuario(int id, UsuarioApi usuario,
      {bool manterSenha = false}) async {
    try {
      UsuarioApi usuarioParaEnviar = usuario;
      if (manterSenha && _usuarioAtual != null && _usuarioAtual!.id == id) {
        // Manter a senha atual se não foi fornecida
        usuarioParaEnviar = usuario.copyWith(senha: _usuarioAtual!.senha);
      }

      final response = await _apiService.updateUsuario(id, usuarioParaEnviar);

      if (_usuarioAtual?.id == id) {
        _usuarioAtual = response;
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteUsuario(int id) async {
    try {
      final success = await _apiService.delete('/api/Users/v1/$id');
      if (success) {
        if (_usuarioAtual?.id == id) {
          _usuarioAtual = null;
        }
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  void clearCache() {
    _usuarioAtual = null;
  }

  void setUsuarioAtual(UsuarioApi usuario) {
    _usuarioAtual = usuario;
  }
}
