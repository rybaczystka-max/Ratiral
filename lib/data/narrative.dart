import 'parser.dart';

class NarrativeResult {
  final String polish;
  final Map<int, int> counts;
  const NarrativeResult(this.polish, this.counts);
}

Map<int, int> countNumbers(List<Tok> toks) {
  final m = <int, int>{};
  for (final t in toks) {
    if (t is TokNum) {
      m[t.value] = (m[t.value] ?? 0) + 1;
    }
  }
  return m;
}

int _digitSum(int n) {
  int s = 0;
  n = n.abs();
  while (n > 0) { s += n % 10; n ~/= 10; }
  return s;
}

int reduceToDigit(int n) {
  n = n.abs();
  while (n >= 10) n = _digitSum(n);
  return n;
}

NarrativeResult generatePolishNarrative(List<Tok> toks) {
  final c = countNumbers(toks);
  final total = c.entries.fold<int>(0, (a, e) => a + e.key * e.value);
  final reduced = reduceToDigit(total);

  bool has(int n) => (c[n] ?? 0) > 0;
  bool many(int n, int k) => (c[n] ?? 0) >= k;

  final slashes = toks.whereType<TokSep>().where((t) => t.sep == '/').length;
  final dashes  = toks.whereType<TokSep>().where((t) => t.sep == '-').length;

  final lines = <String>[];

  if (has(13) && has(22) && has(1)) {
    lines.add('To, co było długo noszone w środku, domaga się domknięcia i nowego początku.');
  } else if (has(13) && has(22)) {
    lines.add('Widzisz temat, który wraca – dopóki nie zostanie domknięty.');
  } else if (has(22)) {
    lines.add('To jest zapis domykania cykli i stawiania granicy temu, co się powtarza.');
  } else {
    lines.add('To jest zapis procesu: od układu, przez napięcie, do domknięcia.');
  }

  if (has(20) || has(21) || many(5, 3)) {
    lines.add('Kluczowym ruchem jest wypowiedzenie i nazwanie – bez tego struktura się nie uspokaja.');
  }

  if (has(9) || has(16) || has(18)) {
    lines.add('W środku jest próg: moment zatrzymania, napięcia i konfrontacji z granicą.');
  }

  if (has(4) || has(14) || has(12)) {
    lines.add('To dotyka porządku: układania spraw, ram, konsekwencji i relacji między elementami.');
  }

  if (has(2) && (has(7) || has(3))) {
    lines.add('W tle jest oś relacji: jak połączyć ruch wewnętrzny z komunikacją na zewnątrz.');
  } else if (has(2)) {
    lines.add('Widać warstwę relacyjną: połączenie zamiast ucieczki.');
  }

  if (slashes >= 4) {
    lines.add('Podział na fazy jest wyraźny: to nie jeden impuls, tylko sekwencja etapów.');
  }
  if (dashes >= 1) {
    lines.add('Myślnik wskazuje pauzę: zatrzymanie i reset w środku procesu.');
  }

  String close;
  switch (reduced) {
    case 1: close = 'Domyka się to w punkt: jednoznaczna decyzja i start od zera.'; break;
    case 2: close = 'Domyka się to w relację: połączenie i zgoda na współistnienie napięć.'; break;
    case 3: close = 'Domyka się to w sens: prostota po złożoności i jasny komunikat.'; break;
    case 4: close = 'Domyka się to w strukturę: porządek, zasady i stabilne ramy.'; break;
    case 5: close = 'Domyka się to w słowo: nazwanie, komunikacja i uwolnienie napięcia.'; break;
    case 6: close = 'Domyka się to w integrację: most między przeciwieństwami.'; break;
    case 7: close = 'Domyka się to w kierunek: wyjście ponad system i ruch do przodu.'; break;
    case 8: close = 'Domyka się to w moc: utrzymanie intensywności i świadomy ciężar.'; break;
    case 9: close = 'Domyka się to w granicę: koniec cyklu i cisza po nim.'; break;
    default: close = 'Domyka się to w jedno – klarownie.'; break;
  }
  lines.add(close);
  lines.add('Suma: $total, redukcja: $reduced.');

  return NarrativeResult(lines.join('\n\n'), c);
}
