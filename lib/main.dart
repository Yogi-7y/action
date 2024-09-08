import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'src/core/resource/colors.dart';
import 'src/module/presentation/screens/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WakelockPlus.enable();

  runApp(const ProviderScope(child: SmartTextFieldOverlay(child: App())));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const Dashboard(),
    );
  }
}
