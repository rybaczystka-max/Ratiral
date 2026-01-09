import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/parser.dart';
import '../data/narrative.dart';
import '../models/record.dart';
import '../storage/boxes.dart';

enum Mode { a, b, ab }

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final _ctl = TextEditingController();
  Mode _mode = Mode.ab;

  RenderAResult _a = const RenderAResult(hebrew: '', names: '', plSounds: '', numbers: []);
  NarrativeResult _b = const NarrativeResult('', {});

  void _compute() {
    final toks = parsePakusza(_ctl.text);
    final a = renderA(toks);
    final b = generatePolishNarrative(toks);
    setState(() {
      _a = a;
      _b = b;
    });
  }

  @override
  void initState() {
    super.initState();
    _ctl.addListener(_compute);
    _compute();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final input = _ctl.text.trim();
    if (input.isEmpty) return;

    final toks = parsePakusza(input);
    final a = renderA(toks);
    final b = generatePolishNarrative(toks);

    final sum = b.counts.entries.fold<int>(0, (s, e) => s + e.key * e.value);
    final reduced = _extractReduced(b.polish) ?? 0;

    final rec = Record(
      input: input,
      hebrew: a.hebrew,
      names: a.names,
      plSounds: a.plSounds,
      polish: b.polish,
      sum: sum,
      reduced: reduced,
      createdAt: DateTime.now(),
    );
    await Boxes.getRecords().add(rec);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zapisano w historii')));
    }
  }

  int? _extractReduced(String polish) {
    final m = RegExp(r'redukcja:\s*(\d+)').firstMatch(polish);
    if (m == null) return null;
    return int.tryParse(m.group(1)!);
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Skopiowano')));
  }

  Widget _card(String title, String body, {VoidCallback? onCopy}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
                if (onCopy != null) IconButton(onPressed: onCopy, icon: const Icon(Icons.copy)),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(body.isEmpty ? '—' : body),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toks = parsePakusza(_ctl.text);
    final counts = _b.counts.entries.toList()..sort((a,b)=>a.key.compareTo(b.key));
    final countsLine = counts.isEmpty ? '' : counts.map((e)=>'${e.key}:${e.value}').join('  ');

    String tokensDebug() {
      return toks.map((t) {
        if (t is TokNum) return '[${t.value}]';
        if (t is TokSep) return t.sep;
        if (t is TokText) return t.text;
        return '';
      }).join(' ');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pakusza • Tłumacz'),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: _ctl,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Wklej zapis (np. 13.9.5/20.9.5...)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          SegmentedButton<Mode>(
            segments: const [
              ButtonSegment(value: Mode.a, label: Text('A')),
              ButtonSegment(value: Mode.b, label: Text('B')),
              ButtonSegment(value: Mode.ab, label: Text('A+B')),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),

          const SizedBox(height: 10),

          if (_mode == Mode.a || _mode == Mode.ab) ...[
            _card('A • Hebrajski', _a.hebrew, onCopy: () => _copy(_a.hebrew)),
            _card('A • Nazwy liter', _a.names, onCopy: () => _copy(_a.names)),
            _card('A • Dźwięk (PL)', _a.plSounds, onCopy: () => _copy(_a.plSounds)),
            _card('A • Liczby', _a.numbers.isEmpty ? '' : _a.numbers.join(' '),
              onCopy: () => _copy(_a.numbers.join(' ')),
            ),
          ],

          if (_mode == Mode.b || _mode == Mode.ab) ...[
            _card('B • Po polsku', _b.polish, onCopy: () => _copy(_b.polish)),
            if (countsLine.isNotEmpty)
              _card('B • Statystyka liczb', countsLine, onCopy: () => _copy(countsLine)),
          ],

          const SizedBox(height: 8),
          _card('Podgląd tokenów (debug)', tokensDebug()),
        ],
      ),
    );
  }
}
