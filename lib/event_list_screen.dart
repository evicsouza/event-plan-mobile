import 'package:flutter/material.dart';
import 'event.dart';
import 'event_details_screen.dart';

class EventListScreen extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onAddEvent;

  EventListScreen(this.events, this.onAddEvent);

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
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
              onTap: () {
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                                      widget.events.remove(event);
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
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_event');
              },
              child: Text('Adicionar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}
