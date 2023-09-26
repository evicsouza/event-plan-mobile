import 'package:flutter/material.dart';
import 'event_task.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventName;
  final DateTime eventDate;

  EventDetailsScreen(this.eventName, this.eventDate);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  List<EventTask> tasks = [];

  void _showAddTaskModal(BuildContext context) {
    String title = '';
    String description = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Nova Tarefa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Título da Tarefa'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descrição da Tarefa'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty) {
                      setState(() {
                        tasks.add(EventTask(title, description, false));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Adicionar Tarefa'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nome do Evento: ${widget.eventName}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Data do Evento: ${widget.eventDate.day}/${widget.eventDate.month}/${widget.eventDate.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Tarefas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (ctx, index) {
                final task = tasks[index];
                return ListTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: task.completed,
                        onChanged: (value) {
                          setState(() {
                            task.completed = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskModal(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
