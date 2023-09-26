import 'package:flutter/material.dart';
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEvent(Event event) {
    setState(() {
      events.add(event);
    });
  }
}
