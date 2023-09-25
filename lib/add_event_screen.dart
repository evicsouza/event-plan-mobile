// add_event_screen.dart

import 'package:flutter/material.dart';
import 'event.dart';

class AddEventScreen extends StatefulWidget {
  final Function(Event) onAddEvent;

  AddEventScreen(this.onAddEvent);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Evento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Evento'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Data do Evento: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Selecionar Data'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final eventName = _nameController.text;
                  final eventDate = _selectedDate;

                  if (eventName.isNotEmpty) {
                    final newEvent = Event(eventName, eventDate);
                    widget.onAddEvent(newEvent);
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
