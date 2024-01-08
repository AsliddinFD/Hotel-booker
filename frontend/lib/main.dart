import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/screens/tabs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (fn) {
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: !ref.watch(themeProvider) ? ThemeData.light() : ThemeData.dark(),
      home: const Scaffold(
        body: TabsScreen(),
      ),
    );
  }
}
