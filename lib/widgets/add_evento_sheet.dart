import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api_models.dart';
import '../models/evento.dart';
import '../services/cliente_service.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class AddEventoSheet extends StatefulWidget {
  final DateTime? initialDate;
  final Function(Evento)? onEventoSaved;
  final Function()? onRefresh;

  const AddEventoSheet({
    super.key,
    this.initialDate,
    this.onEventoSaved,
    this.onRefresh,
  });

  @override
  State<AddEventoSheet> createState() => _AddEventoSheetState();

  static void show(
    BuildContext context, {
    DateTime? initialDate,
    Function(Evento)? onEventoSaved,
    Function()? onRefresh,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventoSheet(
        initialDate: initialDate,
        onEventoSaved: onEventoSaved,
        onRefresh: onRefresh,
      ),
    );
  }
}

class _AddEventoSheetState extends State<AddEventoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  DateTime _selectedDateInicio = DateTime.now();
  TimeOfDay _selectedTimeInicio = TimeOfDay.now();
  DateTime _selectedDateFim = DateTime.now();
  TimeOfDay _selectedTimeFim =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 2)));

  UserApi? _clienteSelecionado;
  List<UserApi> _clientes = [];
  bool _isLoadingClientes = true;
  bool _isSaving = false;
  final ClienteService _clienteService = ClienteService();

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDateInicio = widget.initialDate!;
      _selectedDateFim = widget.initialDate!;
    }
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    try {
      await _clienteService.initialize();
      final clientes =
          await _clienteService.getClientesApi(apenasNaoDeletados: true);
      setState(() {
        _clientes = clientes;
        _isLoadingClientes = false;
      });
      print('✅ Clientes carregados para select: ${_clientes.length}');
    } catch (e) {
      print('❌ Erro ao carregar clientes: $e');
      setState(() {
        _isLoadingClientes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Novo Evento',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Seletor de cliente
                        if (_isLoadingClientes)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else
                          DropdownButtonFormField<UserApi>(
                            value: _clienteSelecionado,
                            decoration: const InputDecoration(
                              labelText: 'Cliente',
                              border: OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.blue),
                            ),
                            hint: const Text('Selecione um cliente'),
                            items: _clientes.map((cliente) {
                              return DropdownMenuItem<UserApi>(
                                value: cliente,
                                child: Text(cliente.nomeCompleto),
                              );
                            }).toList(),
                            onChanged: (UserApi? cliente) {
                              setState(() {
                                _clienteSelecionado = cliente;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Por favor, selecione um cliente';
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 16),
                        // Endereço (readonly)
                        if (_clienteSelecionado != null)
                          TextFormField(
                            initialValue: _clienteSelecionado!.address ?? '',
                            decoration: const InputDecoration(
                              labelText: 'Endereço',
                              border: OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.location_on, color: Colors.blue),
                            ),
                            readOnly: true,
                            enabled: false,
                          ),
                        if (_clienteSelecionado != null)
                          const SizedBox(height: 16),
                        // Campo Valor
                        TextFormField(
                          controller: _valorController,
                          decoration: const InputDecoration(
                            labelText: 'Valor',
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.attach_money, color: Colors.blue),
                            prefixText: 'R\$ ',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o valor';
                            }
                            if (double.tryParse(value.replaceAll(',', '.')) ==
                                null) {
                              return 'Por favor, insira um valor válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Data e Hora de Início
                        const Text(
                          'Data e Hora de Início',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDateInicio,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _selectedDateInicio = date;
                                      // Se a data de fim for anterior à nova data de início, atualizar também
                                      if (_selectedDateFim.isBefore(date) ||
                                          (_selectedDateFim
                                                  .isAtSameMomentAs(date) &&
                                              _selectedTimeFim.hour * 60 +
                                                      _selectedTimeFim.minute <=
                                                  _selectedTimeInicio.hour *
                                                          60 +
                                                      _selectedTimeInicio
                                                          .minute)) {
                                        _selectedDateFim = date;
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          color: Colors.blue),
                                      const SizedBox(width: 12),
                                      Text(
                                        DateFormat('dd/MM/yyyy', 'pt_BR')
                                            .format(_selectedDateInicio),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTimeInicio,
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _selectedTimeInicio = time;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.blue),
                                      const SizedBox(width: 12),
                                      Text(
                                        _selectedTimeInicio.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Data e Hora de Fim
                        const Text(
                          'Data e Hora de Fim',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDateFim,
                                    firstDate: _selectedDateInicio,
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _selectedDateFim = date;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          color: Colors.blue),
                                      const SizedBox(width: 12),
                                      Text(
                                        DateFormat('dd/MM/yyyy', 'pt_BR')
                                            .format(_selectedDateFim),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: _selectedTimeFim,
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _selectedTimeFim = time;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          color: Colors.blue),
                                      const SizedBox(width: 12),
                                      Text(
                                        _selectedTimeFim.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                // Footer com botões
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving
                              ? null
                              : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveEvento,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Adicionar Evento',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveEvento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar se data/hora fim é posterior à data/hora início
    final dataHoraInicio = DateTime(
      _selectedDateInicio.year,
      _selectedDateInicio.month,
      _selectedDateInicio.day,
      _selectedTimeInicio.hour,
      _selectedTimeInicio.minute,
    );

    final dataHoraFim = DateTime(
      _selectedDateFim.year,
      _selectedDateFim.month,
      _selectedDateFim.day,
      _selectedTimeFim.hour,
      _selectedTimeFim.minute,
    );

    if (dataHoraFim.isBefore(dataHoraInicio) ||
        dataHoraFim.isAtSameMomentAs(dataHoraInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'A data/hora de fim deve ser posterior à data/hora de início'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final authService = AuthService();
      await authService.initialize();
      final userId = authService.userId ?? 0;

      // Criar EventApi com os dados do formulário

      final evento = EventApi(
        id: 0,
        id_client: _clienteSelecionado!.id,
        date_event: dataHoraInicio.toIso8601String(),
        hour_event: dataHoraInicio.toIso8601String(),
        hour_end: dataHoraFim.toIso8601String(),
        total: double.parse(_valorController.text.replaceAll(',', '.')),
        id_user_create: authService.usuarioSessao ?? userId,
        datetime_create: DateTime.now().toIso8601String(),
        status: 0, // Não confirmado
        id_enterprise: authService.idEnterprise ?? 0,
        tenant_id: authService.tenantId ?? 0,
      );

      final apiService = ApiService();
      await apiService.initialize();
      final novoEvento = await apiService.createEvent(evento);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.onEventoSaved != null) {
          // Converter EventApi para Evento para compatibilidade
          final eventoCompat = Evento(
            id: novoEvento.id,
            data_hora_criacao:
                novoEvento.datetime_create ?? DateTime.now().toIso8601String(),
            id_usuario_criacao: novoEvento.id_user_create,
            id_usuario: novoEvento.id_user_create,
            id_cliente: novoEvento.id_client,
            valor: novoEvento.total,
            data_hora_inicio: novoEvento.hour_event ??
                novoEvento.date_event ??
                DateTime.now().toIso8601String(),
            data_hora_fim:
                novoEvento.hour_end ?? DateTime.now().toIso8601String(),
            confirmado: novoEvento.status == 1,
            prioridade: 0,
            deletado: false,
          );
          widget.onEventoSaved!(eventoCompat);
        }

        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar evento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }
}
