import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playmax_app_1/config/app_theme.dart';
import 'package:playmax_app_1/config/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  //ensure flutter
  WidgetsFlutterBinding.ensureInitialized();
  //Load env assets
  await dotenv.load();
  //Supabase conection
  await Supabase.initialize(
    url: dotenv.get('URL'),
    anonKey: dotenv.get('ANONKEY'),
  );
  setPathUrlStrategy();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PlayMax Active Players',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildAppTheme(),
      routerConfig: RouterInitialConfig.router,
    );
  }
}
