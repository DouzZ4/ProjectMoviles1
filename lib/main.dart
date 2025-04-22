import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/onboarding/onboarding_provider.dart';
import 'app_widget.dart';
import 'features/notifications/notification_settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => NotificationSettingsProvider()),
      ],
      child: const AppWidget(),
    ),
  );
}
