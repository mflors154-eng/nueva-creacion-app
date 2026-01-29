import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MinistrationScreen extends StatefulWidget {
  const MinistrationScreen({super.key});

  @override
  State<MinistrationScreen> createState() => _MinistrationScreenState();
}

class _MinistrationScreenState extends State<MinistrationScreen> {
  final name = TextEditingController();
  final city = TextEditingController();
  final phone = TextEditingController();
  final motive = TextEditingController();
  bool consent = false;

  // WhatsApp ministerial (Perú)
  final String ministryNumber = '51961279646';

  Future<void> _sendWhatsApp() async {
    if (!consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Necesitas aceptar ser contactado.')),
      );
      return;
    }

    final msg = '''
Hola, vengo desde la app *Nueva Creación* y deseo ministración personal.

*Nombre:* ${name.text.trim()}
*Ciudad/País:* ${city.text.trim()}
*WhatsApp:* ${phone.text.trim()}
*Motivo:* ${motive.text.trim()}
''';

    final encoded = Uri.encodeComponent(msg);
    final uri = Uri.parse('https://wa.me/$ministryNumber?text=$encoded');

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir WhatsApp');
    }
  }

  @override
  void dispose() {
    name.dispose();
    city.dispose();
    phone.dispose();
    motive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ministración personal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Si deseas ministración personal, llena este formulario y envíalo. '
            'Un miembro del ministerio se pondrá en contacto contigo.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: city,
            decoration: const InputDecoration(labelText: 'Ciudad / País'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phone,
            decoration: const InputDecoration(labelText: 'WhatsApp'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: motive,
            decoration: const InputDecoration(labelText: 'Motivo'),
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            value: consent,
            onChanged: (v) => setState(() => consent = v ?? false),
            title: const Text('Acepto ser contactado por el ministerio'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                await _sendWhatsApp();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            icon: const Icon(Icons.send),
            label: const Text('Enviar por WhatsApp'),
          ),
        ],
      ),
    );
  }
}
