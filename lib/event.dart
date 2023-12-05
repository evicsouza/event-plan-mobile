class Event {
  final String? id;
  final String name;
  final DateTime date;
  final String type; // Tipo de evento (Aniversário, Casamento, Outro)
  final bool isLargeEvent; // Indica se é um evento com mais de 100 convidados

  Event(this.id, this.name, this.date, this.type, this.isLargeEvent);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['_id'],
      json['name'] ?? 'Nome do Evento Inválido',
      json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      json['eventType'] ?? 'Tipo de Evento Inválido',
      json['isLargeEvent'] ?? false,
    );
  }
}
