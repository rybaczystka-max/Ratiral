import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/record.dart';
import '../storage/boxes.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Boxes.getRecords();
    return Scaffold(
      appBar: AppBar(title: const Text('Historia')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, __, ___) {
          final items = box.values.toList().reversed.toList();
          if (items.isEmpty) return const Center(child: Text('Brak historii'));

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = items[i];
              return Dismissible(
                key: ValueKey(r.key),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async => r.delete(),
                child: ListTile(
                  title: Text(r.input, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Suma: ${r.sum} • Redukcja: ${r.reduced}'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Szczegóły'),
                        content: SingleChildScrollView(
                          child: SelectableText([
                            'WEJŚCIE:\n${r.input}\n',
                            'HEBRAJSKI:\n${r.hebrew}\n',
                            'NAZWY:\n${r.names}\n',
                            'DŹWIĘK (PL):\n${r.plSounds}\n',
                            'PO POLSKU:\n${r.polish}\n',
                          ].join('\n')),
                        ),
                        actions: [
                          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Zamknij')),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
