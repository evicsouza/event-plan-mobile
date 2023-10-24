class Event {
  final String name;
  final DateTime date;
  final String type; // Tipo de evento (Aniversário, Casamento, Outro)
  final bool isLargeEvent; // Indica se é um evento com mais de 100 convidados

  Event(this.name, this.date, this.type, this.isLargeEvent);
}
