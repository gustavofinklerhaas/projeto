import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/features/home/presentation/pages/home_page.dart';
import 'package:flutter_application_1/src/features/onboarding/onboarding_page.dart';
import 'package:flutter_application_1/src/features/splash/splash_page.dart';
import 'package:flutter_application_1/src/features/shopping_item_category/presentation/pages/categories_page.dart';
import 'package:shopping_list/src/features/store/presentation/pages/stores_page.dart';

class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String stores = '/stores';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      onboarding: (context) => const OnboardingPage(),
      home: (context) => const HomePage(),
      categories: (context) => const CategoriesPage(),
      stores: (context) => const StoresPage(),
    };
  }
}
