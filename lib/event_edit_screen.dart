import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'event.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;
  final Function(Event) onEditEvent;

  EditEventScreen({required this.event, required this.onEditEvent});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _typeController;
  late TextEditingController _isLargeEventController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.event.name);
    _dateController = TextEditingController(text: widget.event.date.toString());
    _typeController = TextEditingController(text: widget.event.type);
    _isLargeEventController =
        TextEditingController(text: widget.event.isLargeEvent.toString());
  }

  Future<void> _editEventOnServer(Event editedEvent) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/event/edit/${editedEvent.id}'),
        body: {
          'name': editedEvent.name,
          'date': editedEvent.date.toIso8601String(),
          'type': editedEvent.type,
          'isLargeEvent': editedEvent.isLargeEvent.toString(),
        },
      );

      if (response.statusCode == 200) {
        widget.onEditEvent(editedEvent);
        Navigator.pop(context);
      } else {
        print('Erro ao editar evento. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao editar evento: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Evento'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Data do Evento'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Tipo de Evento'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _isLargeEventController,
              decoration: InputDecoration(
                  labelText: 'Evento com mais de 100 convidados? (true/false)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Event editedEvent = Event(
                  widget.event.id,
                  _nameController.text,
                  DateTime.parse(_dateController.text),
                  _typeController.text,
                  _isLargeEventController.text.toLowerCase() == 'true',
                );

                _editEventOnServer(editedEvent);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _typeController.dispose();
    _isLargeEventController.dispose();
    super.dispose();
  }
}
