/// Constantes de Assets seguindo Clean Architecture
/// Centraliza todos os caminhos de assets da aplicação
class AppAssets {
  // Paths Base
  static const String _imagePath = 'assets/images';
  static const String _iconPath = 'assets/icons';
  static const String _illustrationPath = 'assets/illustrations';

  // App Icons
  static const String appIcon = '$_iconPath/app_icon.png';
  static const String appLogo = '$_iconPath/app_logo.png';

  // Images
  static const String logoImage = '$_imagePath/logo.png';
  static const String brandingImage = '$_imagePath/branding.png';

  // Illustrations - Onboarding
  static const String illustrationShoppingBag = '$_illustrationPath/shopping_bag.png';
  static const String illustrationOrganize = '$_illustrationPath/organize.png';
  static const String illustrationShare = '$_illustrationPath/share.png';
  static const String illustrationCheckout = '$_illustrationPath/checkout.png';
}
