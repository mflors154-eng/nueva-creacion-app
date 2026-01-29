import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Más adelante pondremos aquí tu catalog.json público
  final String catalogUrl = 'https://TU_DOMINIO/catalog.json';

  // WhatsApp ministerial
  final String ministryNumber = '51961279646';

  String visionTitle = 'Nuestra visión';
  String visionText =
      'Compartimos a Jesucristo y el evangelio de la gracia para que las personas reciban vida, libertad y sanidad.\n\n'
      'Acompañamos a cada persona de manera cercana, hasta que pueda caminar firme y compartir esa misma gracia con otros.';

  @override
  void initState() {
    super.initState();
    _loadVision();
  }

  Future<void> _loadVision() async {
    try {
      final res = await http.get(Uri.parse(catalogUrl));
      if (res.statusCode != 200) return;
      final jsonMap = json.decode(res.body) as Map<String, dynamic>;
      final v = jsonMap['vision'] as Map<String, dynamic>?;
      if (v == null) return;
      setState(() {
        visionTitle = (v['title'] ?? visionTitle).toString();
        visionText = (v['text'] ?? visionText).toString();
      });
    } catch (_) {
      // Si falla, dejamos el texto por defecto
    }
  }

  Future<void> _openDonationWhatsApp() async {
    final msg = Uri.encodeComponent(
      'Hola, vengo desde la app *Nueva Creación* y deseo apoyar el ministerio con una ofrenda/donación.\n'
      '¿Podrías compartirme los medios disponibles?\n\n'
      'Mi país es: ____',
    );
    final uri = Uri.parse('https://wa.me/$ministryNumber?text=$msg');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              visionTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(visionText),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _openDonationWhatsApp,
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Ofrendar / Apoyar el ministerio'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Share.share(
                  'Descarga la app *Nueva Creación* (APK):\n'
                  '(aquí pondrás el link cuando la subamos)',
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Compartir app'),
            ),
          ],
        ),
      ),
    );
  }
}
