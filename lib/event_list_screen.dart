import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'event.dart';
import 'event_details_screen.dart';
import 'event_edit_screen.dart';

class EventListScreen extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onAddEvent;
  final Function(Event) onEditEvent;

  EventListScreen(this.events, this.onAddEvent, this.onEditEvent);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  Future<void> _loadEvents() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/event/all'));

      if (response.statusCode == 200) {
        final List<dynamic> eventData = jsonDecode(response.body);

        setState(() {
          widget.events.clear();
          widget.events.addAll(
              eventData.map((data) => Event.fromJson(data)).whereType<Event>());
        });
      } else {
        print(
            'Erro ao carregar eventos. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao carregar eventos: $error');
    }
  }

  Future<void> _editEvent(String? eventId) async {
    if (eventId != null) {
      try {
        final response =
            await http.get(Uri.parse('http://localhost:3000/api/event/$eventId'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> eventData = jsonDecode(response.body);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return EditEventScreen(
                  event: Event.fromJson(eventData),
                  onEditEvent: (editedEvent) async {
                    try {
                      final editResponse = await http.post(
                        Uri.parse('http://localhost:3000/api/event/edit/$eventId'),
                        body: {
                          'name': editedEvent.name,
                          'date': editedEvent.date.toIso8601String(),
                          'type': editedEvent.type,
                          'isLargeEvent': editedEvent.isLargeEvent.toString(),
                        },
                      );

                      if (editResponse.statusCode == 200) {
                        widget.onEditEvent(editedEvent);
                      } else {
                        print(
                            'Erro ao editar evento. Código de status: ${editResponse.statusCode}');
                      }
                    } catch (error) {
                      print('Erro ao editar evento: $error');
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        } else {
          print(
              'Erro ao obter detalhes do evento. Código de status: ${response.statusCode}');
        }
      } catch (error) {
        print('Erro ao obter detalhes do evento: $error');
      }
    } else {
      print('ID do evento é nulo.');
    }
  }

  Future<void> _deleteEvent(String? eventId) async {
    try {
      final deleteResponse = await http.delete(
        Uri.parse('http://localhost:3000/api/event/delete/$eventId'),
      );

      if (deleteResponse.statusCode == 200) {
        // Exclusão bem-sucedida, recarrega a lista de eventos
        await _loadEvents();
      } else {
        print('Erro ao excluir evento. Código de status: ${deleteResponse.statusCode}');
      }
    } catch (error) {
      print('Erro ao excluir evento: $error');
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
      body: widget.events.isNotEmpty
          ? ListView.builder(
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
                            _editEvent(event.id);
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
                                      _deleteEvent(event.id);
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
          : Center(
              child: Text('Nenhum evento disponível.'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_event');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
