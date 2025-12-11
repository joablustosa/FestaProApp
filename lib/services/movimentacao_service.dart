import '../models/api_models.dart';
import 'api_service.dart';

class MovimentacaoService {
  static final MovimentacaoService _instance = MovimentacaoService._internal();
  factory MovimentacaoService() => _instance;
  MovimentacaoService._internal();

  final ApiService _apiService = ApiService();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _apiService.initialize();
      _isInitialized = true;
    }
  }

  // Buscar transações por evento
  Future<List<TransactionApi>> getTransactionsByEvent(int idEvent) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return await _apiService.getTransactions(idEvent: idEvent);
    } catch (e) {
      print('Erro ao buscar transações do evento: $e');
      return [];
    }
  }

  // Buscar todas as transações
  Future<List<TransactionApi>> getAllTransactions() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return await _apiService.getTransactions();
    } catch (e) {
      print('Erro ao buscar todas as transações: $e');
      return [];
    }
  }

  // Buscar transações default (para dashboard)
  Future<List<TransactionApi>> getTransactionsDefault() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return await _apiService.getTransactionsDefault();
    } catch (e) {
      print('Erro ao buscar transações default: $e');
      return [];
    }
  }

  // Criar nova transação
  Future<TransactionApi?> createTransaction(TransactionApi transaction) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return await _apiService.createTransaction(transaction);
    } catch (e) {
      print('Erro ao criar transação: $e');
      return null;
    }
  }

  // Atualizar transação
  Future<TransactionApi?> updateTransaction(
      int id, TransactionApi transaction) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return await _apiService.updateTransaction(id, transaction);
    } catch (e) {
      print('Erro ao atualizar transação: $e');
      return null;
    }
  }

  // Calcular total pago de uma lista de transações
  double calcularTotalPago(List<TransactionApi> transactions) {
    return transactions
        .where((t) => t.status != 0) // Filtrar apenas transações ativas
        .fold(0.0, (sum, t) => sum + t.value);
  }

  // Métodos de compatibilidade (deprecated - usar TransactionApi)
  @Deprecated('Use getTransactionsByEvent')
  Future<List<TransactionApi>> getMovimentacoesByEvento(int idEvento) async {
    return getTransactionsByEvent(idEvento);
  }

  @Deprecated('Use getAllTransactions')
  Future<List<TransactionApi>> getAllMovimentacoes() async {
    return getAllTransactions();
  }

  @Deprecated('Use createTransaction')
  Future<TransactionApi?> createMovimentacao(
      TransactionApi movimentacao) async {
    return createTransaction(movimentacao);
  }
}
