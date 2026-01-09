import 'mapping_22.dart';

sealed class Tok {
  const Tok();
}
class TokNum extends Tok {
  final int value;
  const TokNum(this.value);
}
class TokSep extends Tok {
  final String sep; // ".", "/", "-", "(", ")", ","
  const TokSep(this.sep);
}
class TokText extends Tok {
  final String text;
  const TokText(this.text);
}

List<Tok> parsePakusza(String raw) {
  final s = raw.trim();
  final toks = <Tok>[];
  int i = 0;

  bool isSep(String ch) => ch == '.' || ch == '/' || ch == '-' || ch == '(' || ch == ')' || ch == ',' || ch == ';';

  while (i < s.length) {
    final ch = s[i];

    if (ch.trim().isEmpty) { i++; continue; }

    if (isSep(ch)) {
      toks.add(TokSep(ch));
      i++;
      continue;
    }

    if (RegExp(r'\d').hasMatch(ch)) {
      int j = i;
      while (j < s.length && RegExp(r'\d').hasMatch(s[j])) j++;
      final run = s.substring(i, j);

      final n = int.tryParse(run);
      if (n != null && n >= 1 && n <= 22) {
        toks.add(TokNum(n));
      } else {
        int k = 0;
        while (k < run.length) {
          int? picked;
          if (k + 2 <= run.length) {
            final two = int.tryParse(run.substring(k, k + 2));
            if (two != null && two >= 1 && two <= 22) picked = two;
          }
          picked ??= int.tryParse(run.substring(k, k + 1));
          if (picked != null && picked >= 1 && picked <= 22) {
            toks.add(TokNum(picked));
          } else {
            toks.add(TokText(run.substring(k, k + 1)));
          }
          k += (picked != null && picked >= 10 && picked <= 22) ? 2 : 1;
        }
      }

      i = j;
      continue;
    }

    toks.add(TokText(ch));
    i++;
  }

  return toks;
}

class RenderAResult {
  final String hebrew;
  final String names;
  final String plSounds;
  final List<int> numbers;
  const RenderAResult({
    required this.hebrew,
    required this.names,
    required this.plSounds,
    required this.numbers,
  });
}

RenderAResult renderA(List<Tok> toks) {
  final heb = StringBuffer();
  final nm = StringBuffer();
  final ps = StringBuffer();
  final nums = <int>[];

  bool firstTokenInWord = true;

  void addWordSep() {
    if (!firstTokenInWord) {
      nm.write(' ');
      ps.write(' ');
    }
    firstTokenInWord = false;
  }

  for (final t in toks) {
    if (t is TokNum) {
      final e = hebByNumber(t.value);
      if (e == null) continue;
      heb.write(e.hebrew);
      nums.add(t.value);
      addWordSep();
      nm.write(e.name);
      ps.write(e.plSound);
      continue;
    }

    if (t is TokSep) {
      if (t.sep == '/' || t.sep == '-') {
        heb.write(' ${t.sep} ');
        nm.write(' ${t.sep} ');
        ps.write(' ${t.sep} ');
        firstTokenInWord = true;
      } else if (t.sep == '.') {
        heb.write(' ');
      } else if (t.sep == '(' || t.sep == ')') {
        heb.write(t.sep);
        nm.write(t.sep);
        ps.write(t.sep);
      } else if (t.sep == ',') {
        heb.write(' , ');
        nm.write(' , ');
        ps.write(' , ');
        firstTokenInWord = true;
      }
      continue;
    }

    if (t is TokText) {
      heb.write(t.text);
    }
  }

  return RenderAResult(
    hebrew: heb.toString().replaceAll(RegExp(r'\s+'), ' ').trim(),
    names: nm.toString().replaceAll(RegExp(r'\s+'), ' ').trim(),
    plSounds: ps.toString().replaceAll(RegExp(r'\s+'), ' ').trim(),
    numbers: nums,
  );
}
