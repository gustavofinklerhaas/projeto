# Estrutura de Assets - Clean Architecture

## Hierarquia de Pastas
```
assets/
├── images/          # Imagens gerais (logo, branding)
├── icons/           # Ícones da aplicação
└── illustrations/   # Ilustrações (onboarding, empty states)
```

## Arquivos de Ícones Necessários

### Android
Coloque em `android/app/src/main/res/`:
```
mipmap-ldpi/ic_launcher.png       (36x36)
mipmap-mdpi/ic_launcher.png       (48x48)
mipmap-hdpi/ic_launcher.png       (72x72)
mipmap-xhdpi/ic_launcher.png      (96x96)
mipmap-xxhdpi/ic_launcher.png     (144x144)
mipmap-xxxhdpi/ic_launcher.png    (192x192)
```

### iOS
Coloque em `ios/Runner/Assets.xcassets/AppIcon.appiconset/`:
```
Icon-App-20x20@1x.png      (20x20)
Icon-App-20x20@2x.png      (40x40)
Icon-App-20x20@3x.png      (60x60)
Icon-App-29x29@1x.png      (29x29)
Icon-App-29x29@2x.png      (58x58)
Icon-App-29x29@3x.png      (87x87)
Icon-App-40x40@1x.png      (40x40)
Icon-App-40x40@2x.png      (80x80)
Icon-App-40x40@3x.png      (120x120)
Icon-App-60x60@2x.png      (120x120)
Icon-App-60x60@3x.png      (180x180)
Icon-App-76x76@1x.png      (76x76)
Icon-App-76x76@2x.png      (152x152)
Icon-App-83.5x83.5@2x.png  (167x167)
Icon-App-1024x1024@1x.png  (1024x1024)
```

## Como Gerar Ícones

### Usando Flutter Launcher Icons
1. Adicione ao pubspec.yaml:
```yaml
dev_dependencies:
  flutter_launcher_icons: "^0.13.1"

flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icons/app_icon.png"
  min_sdk_android: 21
```

2. Execute:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Usando Ferramentas Online
- AppIcon.co (https://www.appicon.co/)
- IconKitchen (https://icon.kitchen/)
- MakeAppIcon (https://makeappicon.com/)

## Referência em Código
Todos os assets são referenciados via `AppAssets` em `lib/src/core/constants/app_assets.dart`:

```dart
import 'package:shopping_list/src/core/constants/app_assets.dart';

Image.asset(AppAssets.appIcon);
Image.asset(AppAssets.logoImage);
```

## Organização Seguindo Clean Architecture

```
lib/
├── src/
│   ├── core/
│   │   └── constants/
│   │       └── app_assets.dart  ← Centraliza paths de assets
```

Todos os paths de assets estão centralizados em `app_assets.dart`, facilitando manutenção e evitando erros de digitação.
