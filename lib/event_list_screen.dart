import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event.dart';
import 'event_details_screen.dart';
import 'event_edit_screen.dart';

class EventListScreen extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onAddEvent;

  EventListScreen(this.events, this.onAddEvent);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<void> _loadEvents() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/event/all'));

      if (response.statusCode == 200) {
        final List<dynamic> eventData = jsonDecode(response.body);

        setState(() {
          widget.events.clear();
          widget.events.addAll(eventData.map((data) => Event.fromJson(data)).whereType<Event>());
        });
      } else {
        print('Erro ao carregar eventos. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar eventos: $error');
    }
  }

  Future<void> _editEvent(String? eventId) async {
    if (eventId != null) {
      try {
        final response = await http.get(Uri.parse('http://localhost:3000/api/event/edit/$eventId'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> eventData = jsonDecode(response.body);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditEventScreen(
                event: Event.fromJson(eventData),
                onEditEvent: (editedEvent) {
                  _loadEvents();
                },
              ),
            ),
          );
        } else {
          print('Erro ao obter detalhes do evento. Código de status: ${response.statusCode}');
        }
      } catch (error) {
        print('Erro ao obter detalhes do evento: $error');
      }
    } else {
      print('ID do evento é nulo.');
    }
  }

  Future<void> _deleteEvent(String? eventId) async {
    if (eventId != null) {
      try {
        final response = await http.delete(Uri.parse('http://localhost:3000/api/event/delete/$eventId'));

        if (response.statusCode == 200) {
          _loadEvents();
        } else {
          print('Erro ao excluir o evento. Código de status: ${response.statusCode}');
        }
      } catch (error) {
        print('Erro ao excluir o evento: $error');
      }
    } else {
      print('ID do evento é nulo.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eventPlan'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Perfil'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.events.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.events.length,
                itemBuilder: (ctx, index) {
                  final event = widget.events[index];
                  return Card(
                    child: ListTile(
                      title: Text(event.name),
                      subtitle: Text(
                        'Data: ${event.date.day}/${event.date.month}/${event.date.year}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event.name, event.date),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editEvent(event.id ?? ''); // Passa uma string vazia se o ID for nulo
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirmar exclusão'),
                                  content: Text('Deseja excluir este evento?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteEvent(event.id ?? ''); // Passa uma string vazia se o ID for nulo
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text('Excluir'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Center(
                child: Text('Nenhum evento disponível.'),
              ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_event');
                },
                child: Text('Adicionar Evento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
