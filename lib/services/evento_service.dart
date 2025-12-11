import '../models/api_models.dart';
import '../models/evento.dart';
import 'api_service.dart';

class EventoService {
  static final EventoService _instance = EventoService._internal();
  factory EventoService() => _instance;
  EventoService._internal();

  final ApiService _apiService = ApiService();

  List<Evento> _eventos = [];
  bool _isInitialized = false;

  List<Evento> get eventos => _eventos;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      await _apiService.initialize();
      await refreshEventos();
      _isInitialized = true;
    } catch (e) {
      print('Erro ao inicializar EventoService: $e');
      _eventos = [];
      _isInitialized = true;
    }
  }

  Future<void> refreshEventos() async {
    try {
      // Usar o novo endpoint de Events
      final apiEvents = await _apiService.getEvents();
      _eventos = apiEvents.map((e) {
        return Evento(
          id: e.id,
          data_hora_criacao: e.datetime_create,
          id_usuario_criacao: e.id_user_create,
          deletado: e.status == 0,
          data_hora_deletado: null,
          id_usuario: e.id_user_create,
          id_cliente: e.id_client,
          valor: e.total,
          data_hora_inicio: e.hour_event ?? e.date_event,
          data_hora_fim: e.hour_end,
          confirmado: e.status == 1,
          prioridade: 0,
          data_hora_confirmado: e.datetime_status,
          forma_de_pagamento: e.signal_payment,
        );
      }).toList();
      print('Eventos atualizados: ${_eventos.length} encontrados');
    } catch (e) {
      print('Erro ao atualizar eventos: $e');
      rethrow;
    }
  }

  // Método para obter eventos como EventApi (novo formato)
  Future<List<EventApi>> getEventsApi() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      return await _apiService.getEvents();
    } catch (e) {
      print('Erro ao buscar eventos: $e');
      return [];
    }
  }

  // Método para obter eventos por data (novo formato)
  Future<List<EventApi>> getEventsByDate(DateTime date) async {
    try {
      final allEvents = await getEventsApi();
      final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD

      return allEvents.where((event) {
        if (event.date_event == null) return false;
        final eventDate = event.date_event!.split('T')[0];
        return eventDate == dateStr;
      }).toList();
    } catch (e) {
      print('Erro ao buscar eventos por data: $e');
      return [];
    }
  }

  Future<Evento?> getEventoById(int id) async {
    try {
      final local = _eventos.where((l) => l.id == id).firstOrNull;
      if (local != null) {
        return local;
      }

      // Usar o novo endpoint
      final api = await _apiService.getEventById(id);
      final evento = Evento(
        id: api.id,
        data_hora_criacao: api.datetime_create,
        id_usuario_criacao: api.id_user_create,
        deletado: api.status == 0,
        data_hora_deletado: null,
        id_usuario: api.id_user_create,
        id_cliente: api.id_client,
        valor: api.total,
        data_hora_inicio: api.hour_event ?? api.date_event,
        data_hora_fim: api.hour_end,
        confirmado: api.status == 1,
        prioridade: 0,
        data_hora_confirmado: api.datetime_status,
        forma_de_pagamento: api.signal_payment,
      );
      _eventos.add(evento);
      return evento;
    } catch (e) {
      print('Erro ao buscar evento por ID: $e');
      return null;
    }
  }

  // Método para obter EventApi por ID
  Future<EventApi?> getEventApiById(int id) async {
    try {
      return await _apiService.getEventById(id);
    } catch (e) {
      print('Erro ao buscar evento por ID: $e');
      return null;
    }
  }

  Future<Evento?> createEvento(Evento evento) async {
    try {
      final novoEventoApi = EventoApi(
        id: evento.id,
        data_hora_criacao: evento.data_hora_criacao,
        id_usuario_criacao: evento.id_usuario_criacao,
        deletado: evento.deletado,
        data_hora_deletado: evento.data_hora_deletado,
        id_usuario: evento.id_usuario,
        id_cliente: evento.id_cliente,
        valor: evento.valor,
        data_hora_evento: evento.data_hora_inicio,
        data_hora_inicio: evento.data_hora_inicio,
        data_hora_fim: evento.data_hora_fim,
        confirmado: evento.confirmado,
        prioridade: evento.prioridade,
        data_hora_confirmado: evento.data_hora_confirmado,
        forma_de_pagamento: evento.forma_de_pagamento,
      );
      final nova = await _apiService.createEvento(novoEventoApi);
      final novoEvento = Evento(
        id: nova.id,
        data_hora_criacao: nova.data_hora_criacao,
        id_usuario_criacao: nova.id_usuario_criacao,
        deletado: nova.deletado,
        data_hora_deletado: nova.data_hora_deletado,
        id_usuario: nova.id_usuario,
        id_cliente: nova.id_cliente,
        valor: nova.valor,
        data_hora_inicio: nova.data_hora_inicio ?? nova.data_hora_evento,
        data_hora_fim: nova.data_hora_fim,
        confirmado: nova.confirmado,
        prioridade: nova.prioridade,
        data_hora_confirmado: nova.data_hora_confirmado,
        forma_de_pagamento: nova.forma_de_pagamento,
      );
      _eventos.add(novoEvento);
      print('Evento criado e adicionado ao cache local');
      return novoEvento;
    } catch (e) {
      print('Erro ao criar evento: $e');
      return null;
    }
  }

  Future<Evento?> updateEvento(int id, EventoApi evento) async {
    try {
      final atualizada = await _apiService.updateEvento(id, evento);
      final eventoAtualizado = Evento(
        id: atualizada.id,
        data_hora_criacao: atualizada.data_hora_criacao,
        id_usuario_criacao: atualizada.id_usuario_criacao,
        deletado: atualizada.deletado,
        data_hora_deletado: atualizada.data_hora_deletado,
        id_usuario: atualizada.id_usuario,
        id_cliente: atualizada.id_cliente,
        valor: atualizada.valor,
        data_hora_inicio:
            atualizada.data_hora_inicio ?? atualizada.data_hora_evento,
        data_hora_fim: atualizada.data_hora_fim,
        confirmado: atualizada.confirmado,
        prioridade: atualizada.prioridade,
        data_hora_confirmado: atualizada.data_hora_confirmado,
        forma_de_pagamento: atualizada.forma_de_pagamento,
      );

      final index = _eventos.indexWhere((l) => l.id == id);
      if (index != -1) {
        _eventos[index] = eventoAtualizado;
        print('Evento atualizado no cache local');
      }
      return eventoAtualizado;
    } catch (e) {
      print('Erro ao atualizar evento: $e');
      return null;
    }
  }

  Future<bool> deleteEvento(int id) async {
    try {
      final sucesso = await _apiService.deleteEvento(id);
      if (sucesso) {
        _eventos.removeWhere((l) => l.id == id);
        print('Evento removido do cache local');
      }
      return sucesso;
    } catch (e) {
      print('Erro ao deletar evento: $e');
      return false;
    }
  }

  List<Evento> getEventosByDate(DateTime date) {
    return _eventos.where((evento) {
      if (evento.data_hora_inicio == null) return false;
      try {
        final eventoDate = DateTime.parse(evento.data_hora_inicio!);
        return eventoDate.year == date.year &&
            eventoDate.month == date.month &&
            eventoDate.day == date.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  Future<List<Evento>> getEventosByDateFromApi(DateTime date) async {
    try {
      print(
          'Buscando eventos por data via API: ${date.toIso8601String().split('T')[0]}');
      final eventosApi = await _apiService.getEventosPorData(date);
      final eventos = eventosApi.map((e) {
        return Evento(
          id: e.id,
          data_hora_criacao: e.data_hora_criacao,
          id_usuario_criacao: e.id_usuario_criacao,
          deletado: e.deletado,
          data_hora_deletado: e.data_hora_deletado,
          id_usuario: e.id_usuario,
          id_cliente: e.id_cliente,
          valor: e.valor,
          data_hora_inicio: e.data_hora_inicio ?? e.data_hora_evento,
          data_hora_fim: e.data_hora_fim,
          confirmado: e.confirmado,
          prioridade: e.prioridade,
          data_hora_confirmado: e.data_hora_confirmado,
          forma_de_pagamento: e.forma_de_pagamento,
        );
      }).toList();

      for (final evento in eventos) {
        final existingIndex = _eventos.indexWhere((l) => l.id == evento.id);
        if (existingIndex != -1) {
          _eventos[existingIndex] = evento;
        } else {
          _eventos.add(evento);
        }
      }

      return eventos;
    } catch (e) {
      print('Erro ao buscar eventos por data via API: $e');
      return getEventosByDate(date);
    }
  }

  List<Evento> getEventosConfirmadas() {
    return _eventos.where((evento) => evento.confirmado).toList();
  }

  List<Evento> getEventosPendentes() {
    return _eventos.where((evento) => !evento.confirmado).toList();
  }

  double getTotalMes(DateTime month) {
    return _eventos.where((evento) {
      if (evento.data_hora_inicio == null) return false;
      try {
        final eventoDate = DateTime.parse(evento.data_hora_inicio!);
        return eventoDate.year == month.year && eventoDate.month == month.month;
      } catch (e) {
        return false;
      }
    }).fold(0.0, (sum, evento) => sum + evento.valor);
  }

  double getTotalAReceber() {
    return _eventos
        .where((evento) => !evento.confirmado)
        .fold(0.0, (sum, evento) => sum + evento.valor);
  }

  int getQuantidadeRealizadas() {
    return _eventos.where((evento) => evento.confirmado).length;
  }
}
