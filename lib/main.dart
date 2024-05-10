import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:playmax_app_1/config/app_theme.dart';
import 'package:playmax_app_1/presentation/providers/router_provider.dart';

void main() async {
  //ensure flutter
  WidgetsFlutterBinding.ensureInitialized();
  //Set preferred orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  //Load env assets
  await dotenv.load(fileName: 'assets/dotEnv.env');
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Provider que maneja el router
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Max Players | TGU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildAppTheme(),
      routerConfig: router,
    );
  }
}
