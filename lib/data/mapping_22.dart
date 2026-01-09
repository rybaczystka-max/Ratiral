class Heb22 {
  final int n;
  final String hebrew;
  final String name;
  final String plSound;

  const Heb22(this.n, this.hebrew, this.name, this.plSound);
}

/// 1–22 mapping (Hebrew letters). plSound is a Polish-friendly syllable.
/// NOTE: This is for numeric input mode (1..22).
const List<Heb22> kHeb22 = [
  Heb22(1,  'א', 'Alef',   'a'),
  Heb22(2,  'ב', 'Bet',    'be'),
  Heb22(3,  'ג', 'Gimel',  'gi'),
  Heb22(4,  'ד', 'Dalet',  'da'),
  Heb22(5,  'ה', 'He',     'he'),
  Heb22(6,  'ו', 'Waw',    'wa'),
  Heb22(7,  'ז', 'Zajin',  'za'),
  Heb22(8,  'ח', 'Chet',   'ha'),
  Heb22(9,  'ט', 'Tet',    'te'),
  Heb22(10, 'י', 'Jod',    'jo'),
  Heb22(11, 'כ', 'Kaf',    'ka'),
  Heb22(12, 'ל', 'Lamed',  'la'),
  Heb22(13, 'מ', 'Mem',    'me'),
  Heb22(14, 'נ', 'Nun',    'nu'),
  Heb22(15, 'ס', 'Samech', 'sa'),
  Heb22(16, 'ע', 'Ajin',   'aj'),
  Heb22(17, 'פ', 'Pe',     'pe'),
  Heb22(18, 'צ', 'Cade',   'ca'),
  Heb22(19, 'ק', 'Qof',    'qof'),
  Heb22(20, 'ר', 'Resz',   're'),
  Heb22(21, 'ש', 'Szin',   'sz'),
  Heb22(22, 'ת', 'Taw',    'ta'),
];

Heb22? hebByNumber(int n) {
  if (n < 1 || n > 22) return null;
  return kHeb22[n - 1];
}
