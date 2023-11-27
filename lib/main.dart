import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'event_list_screen.dart';
import 'add_event_screen.dart';
import 'event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/event/all'));

      if (response.statusCode == 200) {
        final List<dynamic> eventData = jsonDecode(response.body);
        setState(() {
          events = eventData.map((data) => Event.fromJson(data)).toList();
        });
      } else {
        print('Erro ao obter eventos. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na solicitação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/event_list',
      routes: {
        '/event_list': (context) => EventListScreen(events, _addEvent),
        '/add_event': (context) => AddEventScreen(_addEvent),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('Meu Aplicativo de Eventos'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Seu Nome"),
                accountEmail: Text("seu@email.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("url_da_sua_foto"),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  // Adicionar navegação para a tela de configurações se necessário
                },
              ),
            ],
          ),
        ),
        body: EventListScreen(events, _addEvent),
      ),
    );
  }

  void _addEvent(Event event) {
    setState(() {
      events.add(event);
    });
  }
}
