import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/storage/prefs_service.dart';
import 'di/injector.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sp = await SharedPreferences.getInstance();
  final prefs = PrefsService(sp);
  runApp(AppRoot(prefs: prefs));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.prefs});
  final PrefsService prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(prefs),
      child: Builder(builder: (ctx) {
        final router = AppRouter.build(ctx, prefs);
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: router,
        );
      }),
    );
  }
}
