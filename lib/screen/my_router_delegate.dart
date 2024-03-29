import 'package:flutter/material.dart';
import 'package:sosmedic/screen/detail_screen.dart';
import 'package:sosmedic/screen/home_screen.dart';
import 'package:sosmedic/screen/login_screen.dart';
import 'package:sosmedic/screen/register_screen.dart';
import 'package:sosmedic/screen/splash_screen.dart';
import 'package:sosmedic/utils/auth_preference.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  String? selectedStory;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool? isRegister = false;
  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        isRegister = false;
        selectedStory = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        )
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginScreen"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          const MaterialPage(
              key: ValueKey("RegisterScreens"), child: RegisterScreen())
      ];

  List<Page> get _loggedInStack => [
        const MaterialPage(
          key: ValueKey("HomeScreen"),
          child: HomeScreen(),
        ),
        if (selectedStory != null)
          MaterialPage(
              key: ValueKey(selectedStory),
              child: DetailScreen(
                story: selectedStory!,
              ))
      ];

  _init() async {
    var authPref = AuthPreference();
    authPref.getUserToken().then((token) {
      isLoggedIn = token.isNotEmpty;
      notifyListeners();
    });
  }
}
