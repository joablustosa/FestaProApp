import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/evento.dart';
import '../models/api_models.dart';
import '../services/evento_service.dart';
import '../services/cliente_service.dart';
import 'day_details_screen.dart';
import 'event_payments_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final EventoService _eventoService = EventoService();
  final ClienteService _clienteService = ClienteService();
  List<UserApi> _clientes = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {});

      await _eventoService.initialize();
      await _clienteService.initialize();

      // Recarregar eventos da API para garantir que estão atualizados no carregamento inicial
      await _eventoService.refreshEventos();

      final clientes = await _clienteService.getClientesApi();
      setState(() {
        _clientes = clientes;
      });
    } catch (e) {
      print('Erro ao carregar eventos: $e');
      setState(() {});
    }
  }

  List<Evento> _getEventosForDay(DateTime day) {
    return _eventoService.getEventosByDate(day);
  }

  String _getClienteNome(int clienteId) {
    try {
      final cliente = _clientes.firstWhere((c) => c.id == clienteId);
      return cliente.nomeCompleto;
    } catch (e) {
      return 'Cliente #$clienteId';
    }
  }

  String _getClienteEndereco(int clienteId) {
    try {
      final cliente = _clientes.firstWhere((c) => c.id == clienteId);
      return cliente.address ?? '';
    } catch (e) {
      return 'Endereço não encontrado';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _focusedDay = DateTime(
                                      _focusedDay.year, _focusedDay.month - 1);
                                });
                              },
                            ),
                            Text(
                              DateFormat('MMMM yyyy', 'pt_BR')
                                  .format(_focusedDay)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Botão de menu - volta para o mês atual
                            IconButton(
                              icon: const Icon(Icons.calendar_month_outlined,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _focusedDay = DateTime.now();
                                  _selectedDay = DateTime.now();
                                });
                              },
                              tooltip: 'Voltar para o mês atual',
                            ),
                            // Botão de notificação - comentado temporariamente
                            // Stack(
                            //   children: [
                            //     IconButton(
                            //       icon: const Icon(Icons.notifications,
                            //           color: Colors.white),
                            //       onPressed: () {},
                            //     ),
                            //     Positioned(
                            //       right: 8,
                            //       top: 8,
                            //       child: Container(
                            //         padding: const EdgeInsets.all(2),
                            //         decoration: BoxDecoration(
                            //           color: Colors.red,
                            //           borderRadius: BorderRadius.circular(6),
                            //         ),
                            //         constraints: const BoxConstraints(
                            //           minWidth: 12,
                            //           minHeight: 12,
                            //         ),
                            //         child: const Text(
                            //           '12',
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 8,
                            //           ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Botão de atualizar - carrega os eventos
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              onPressed: () async {
                                // Mostrar indicador de carregamento
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                
                                // Recarregar eventos
                                await _loadEvents();
                                
                                // Fechar indicador de carregamento
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                                
                                // Mostrar mensagem de sucesso
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Eventos atualizados com sucesso!'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              tooltip: 'Atualizar eventos',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          TableCalendar<Evento>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              try {
                // Usar o novo método que retorna EventApi
                final eventosDoDia = await _eventoService.getEventsByDate(selectedDay);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayDetailsScreen(
                      selectedDay: selectedDay,
                      eventos: eventosDoDia,
                    ),
                  ),
                );
              } catch (e) {
                print('Erro ao buscar eventos para o dia: $e');
                final eventosDoDia = _getEventosForDay(selectedDay);
                // Converter Evento para EventApi
                final eventosApi = eventosDoDia.map((e) {
                  return EventApi(
                    id: e.id,
                    id_client: e.id_cliente,
                    date_event: e.data_hora_inicio,
                    hour_event: e.data_hora_inicio,
                    hour_end: e.data_hora_fim,
                    total: e.valor,
                    id_user_create: e.id_usuario_criacao,
                    datetime_create: e.data_hora_criacao,
                    status: e.confirmado ? 1 : 0,
                    datetime_status: e.data_hora_confirmado,
                    signal_payment: e.forma_de_pagamento,
                  );
                }).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayDetailsScreen(
                      selectedDay: selectedDay,
                      eventos: eventosApi,
                    ),
                  ),
                );
              }
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventosForDay,
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerVisible: false,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedDay!.isAtSameMomentAs(DateTime.now())
                                  ? 'HOJE'
                                  : DateFormat('dd/MM/yyyy', 'pt_BR')
                                      .format(_selectedDay!),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${_getEventosForDay(_selectedDay!).length} Evento${_getEventosForDay(_selectedDay!).length == 1 ? '' : 's'}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              final eventosDoDia = await _eventoService.getEventsByDate(_selectedDay!);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DayDetailsScreen(
                                    selectedDay: _selectedDay!,
                                    eventos: eventosDoDia,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print('Erro ao buscar eventos para o dia: $e');
                              final eventosDoDia = _getEventosForDay(_selectedDay!);
                              final eventosApi = eventosDoDia.map((e) {
                                return EventApi(
                                  id: e.id,
                                  id_client: e.id_cliente,
                                  date_event: e.data_hora_inicio,
                                  hour_event: e.data_hora_inicio,
                                  hour_end: e.data_hora_fim,
                                  total: e.valor,
                                  id_user_create: e.id_usuario_criacao,
                                  datetime_create: e.data_hora_criacao,
                                  status: e.confirmado ? 1 : 0,
                                  datetime_status: e.data_hora_confirmado,
                                  signal_payment: e.forma_de_pagamento,
                                );
                              }).toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DayDetailsScreen(
                                    selectedDay: _selectedDay!,
                                    eventos: eventosApi,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Ver todas >',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _getEventosForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final evento = _getEventosForDay(_selectedDay!)[index];

                        DateTime? dataEvento;
                        try {
                          if (evento.data_hora_inicio != null) {
                            dataEvento =
                                DateTime.parse(evento.data_hora_inicio!);
                          }
                        } catch (e) {
                          dataEvento = null;
                        }

                        // Converter Evento para EventApi
                        final eventoApi = EventApi(
                          id: evento.id,
                          id_client: evento.id_cliente,
                          date_event: evento.data_hora_inicio,
                          hour_event: evento.data_hora_inicio,
                          hour_end: evento.data_hora_fim,
                          total: evento.valor,
                          id_user_create: evento.id_usuario_criacao,
                          datetime_create: evento.data_hora_criacao,
                          status: evento.confirmado ? 1 : 0,
                          datetime_status: evento.data_hora_confirmado,
                          signal_payment: evento.forma_de_pagamento,
                        );

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventPaymentsScreen(
                                    evento: eventoApi,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                _getClienteNome(evento.id_cliente),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        dataEvento != null
                                            ? DateFormat(
                                                    'dd/MM/yyyy HH:mm', 'pt_BR')
                                                .format(dataEvento)
                                            : 'Sem data',
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          _getClienteEndereco(
                                              evento.id_cliente),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Toque para ver detalhes e pagamentos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'R\$ ${evento.valor.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
