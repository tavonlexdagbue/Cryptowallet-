import 'package:flutter/material.dart';
import '../presentation/biometric_authentication/biometric_authentication.dart';
import '../presentation/portfolio_dashboard/portfolio_dashboard.dart';
import '../presentation/wallet_setup/wallet_setup.dart';
import '../presentation/receive_cryptocurrency/receive_cryptocurrency.dart';
import '../presentation/send_cryptocurrency/send_cryptocurrency.dart';
import '../presentation/security_settings/security_settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String biometricAuthentication = '/biometric-authentication';
  static const String portfolioDashboard = '/portfolio-dashboard';
  static const String walletSetup = '/wallet-setup';
  static const String receiveCryptocurrency = '/receive-cryptocurrency';
  static const String sendCryptocurrency = '/send-cryptocurrency';
  static const String securitySettings = '/security-settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const PortfolioDashboard(),
    biometricAuthentication: (context) => const BiometricAuthentication(),
    portfolioDashboard: (context) => const PortfolioDashboard(),
    walletSetup: (context) => const WalletSetup(),
    receiveCryptocurrency: (context) => const ReceiveCryptocurrency(),
    sendCryptocurrency: (context) => const SendCryptocurrency(),
    securitySettings: (context) => const SecuritySettings(),
    // TODO: Add your other routes here
  };
}
