import 'package:flutter/material.dart';
import 'event.dart'; // Certifique-se de importar a classe de Event correta

class EditEventScreen extends StatefulWidget {
  final Event event; // Passamos o evento para edição
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

    // Inicializamos os controladores de texto com os dados existentes do evento
    _nameController = TextEditingController(text: widget.event.name);
    _dateController = TextEditingController(text: widget.event.date.toString());
    _typeController = TextEditingController(text: widget.event.type);
    _isLargeEventController = TextEditingController(text: widget.event.isLargeEvent.toString());
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
              decoration: InputDecoration(labelText: 'Evento com mais de 100 convidados? (true/false)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a lógica para salvar as alterações
                Event editedEvent = Event(
                  widget.event.id,
                  _nameController.text,
                  DateTime.parse(_dateController.text),
                  _typeController.text,
                  _isLargeEventController.text.toLowerCase() == 'true',
                );

                // Chamamos a função de callback para atualizar a lista
                widget.onEditEvent(editedEvent);

                // Voltamos para a tela anterior
                Navigator.pop(context);
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
    // Certificamos de liberar os controladores quando a tela é destruída
    _nameController.dispose();
    _dateController.dispose();
    _typeController.dispose();
    _isLargeEventController.dispose();
    super.dispose();
  }
}
