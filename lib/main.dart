import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/record.dart';
import 'storage/boxes.dart';
import 'ui/translator_screen.dart';
import 'ui/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecordAdapter());
  await Hive.openBox<Record>(Boxes.records);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakusza',
      theme: ThemeData(useMaterial3: true),
      home: const HomeTabs(),
    );
  }
}

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [TranslatorScreen(), HistoryScreen()];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.translate), label: 'Tłumacz'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historia'),
        ],
      ),
    );
  }
}
