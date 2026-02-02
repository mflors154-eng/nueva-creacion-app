import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Sermon {
  final String id;
  final String title;
  final String topic;
  final DateTime date;
  final int? durationMin;
  final String description;
  final String url;

  Sermon({
    required this.id,
    required this.title,
    required this.topic,
    required this.date,
    required this.description,
    required this.url,
    this.durationMin,
  });

  factory Sermon.fromJson(Map<String, dynamic> json) {
    return Sermon(
      id: json['id'],
      title: json['title'],
      topic: json['topic'],
      date: DateTime.parse(json['date']),
      durationMin: (json['durationMin'] as num?)?.toInt(),
      description: json['description'] ?? '',
      url: json['url'],
    );
  }
}

class SermonsScreen extends StatefulWidget {
  const SermonsScreen({super.key});

  @override
  State<SermonsScreen> createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<SermonsScreen> {
  // Luego pondremos aquí tu catalog.json público
  final String catalogUrl = 'https://TU_DOMINIO/catalog.json';

  List<Sermon> sermons = [];
  bool loading = true;
  String query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse(catalogUrl));
      if (res.statusCode != 200) throw Exception('Catálogo no disponible');
      final jsonMap = json.decode(res.body) as Map<String, dynamic>;
      final list = (jsonMap['sermons'] as List<dynamic>? ?? []);
      final data = list
          .map((e) => Sermon.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      if (!mounted) return;
      setState(() => sermons = data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = sermons.where((s) {
      final q = query.toLowerCase().trim();
      if (q.isEmpty) return true;
      return s.title.toLowerCase().contains(q) ||
          s.topic.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academia de Gracia'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por título o tema',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final s = filtered[i];
                      final date =
                          s.date.toIso8601String().split('T').first;
                      return ListTile(
                        title: Text(s.title),
                        subtitle: Text(
                            '${s.topic} • $date${s.durationMin != null ? " • ${s.durationMin} min" : ""}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // detalle lo hacemos después
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
