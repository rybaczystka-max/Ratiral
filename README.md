# Pakusza Translator (Flutter MVP)

## Co robi
- Parsuje zapis liczbowy z separatorami: . / - ( ) , ;
- Tryb A: renderuje hebrajskie litery (1..22), nazwy oraz „dźwięk PL”.
- Tryb B: generator tekstu po polsku (regułowy, deterministyczny, offline).
- Historia: zapis wyników offline (Hive).

## Uruchomienie (Android)
1) Zainstaluj Flutter SDK + Android Studio.
2) W folderze projektu:
   - `flutter pub get`
3) Wygeneruj adaptery Hive:
   - `flutter pub run build_runner build --delete-conflicting-outputs`
4) Odpal:
   - `flutter run`

## Uwaga (ważne)
- Generator B to silnik reguł, nie AI. Teksty możesz dopasować w `lib/data/narrative.dart`.
- Jeśli trafiają się ciągi typu 7222... parser tnie je zachłannie na liczby 1..22.
