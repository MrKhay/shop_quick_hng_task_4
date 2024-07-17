import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/features.dart';
import 'shop_quick.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

///
class MainApp extends StatelessWidget {
  ///
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      home: const ShopFast(),
    );
  }
}
