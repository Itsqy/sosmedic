import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosmedic/data/api_service.dart';
import 'package:sosmedic/provider/auth_provider.dart';
import 'package:sosmedic/provider/story_provider.dart';
import 'package:sosmedic/screen/my_router_delegate.dart';
import 'package:sosmedic/utils/page_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SosmedicApp());
}

class SosmedicApp extends StatefulWidget {
  const SosmedicApp({super.key});

  @override
  State<SosmedicApp> createState() => _SosmedicAppState();
}

class _SosmedicAppState extends State<SosmedicApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();

    myRouterDelegate = MyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<StoryProvider>(
            create: (context) => StoryProvider(ApiService()),
          ),
          // ChangeNotifierProvider<PageManager>(
          //   create: (context) => PageManager(),
          // ),
        ],
        builder: (context, child) {
          return MaterialApp(
              title: 'Sosmedic',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: Router(
                routerDelegate: myRouterDelegate,
                backButtonDispatcher: RootBackButtonDispatcher(),
              ));
        });
  }
}
