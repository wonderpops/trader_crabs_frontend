abstract class MainNavigationRoutesNames {
  static const auth = '/auth';
  static const dashboard = '/dashboard';
  static const tickers = '/tickers';
  static const wallet = '/wallet';
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRoutesNames.dashboard
      : MainNavigationRoutesNames.auth;
}
