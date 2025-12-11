# Guia de Renomeação do Projeto Flutter

## Nome do Projeto Alterado: flutter_application_1 → shopping_list

### Mudanças Já Realizadas ✅

1. **pubspec.yaml**
   - ✅ Nome do package alterado para `shopping_list`
   - ✅ Descrição atualizada
   - ✅ Assets configurados para Clean Architecture

2. **main.dart**
   - ✅ Título do app alterado para "ShoppingList"

3. **Estrutura de Assets**
   - ✅ `app_assets.dart` criado em `lib/src/core/constants/`
   - ✅ Folders de assets organizados por tipo

### Próximos Passos (Para Completar a Renomeação)

#### Android (android/)

1. **Renomear Package Name**
```bash
cd android/app/src/main/java/com/example/flutter_application_1
# Renomear pasta para: com/example/shopping_list
```

2. **Atualizar AndroidManifest.xml**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.shopping_list">  <!-- Alterar aqui -->
```

3. **Atualizar build.gradle**
```gradle
// android/app/build.gradle
android {
    namespace = "com.example.shopping_list"  <!-- Alterar aqui -->
    
    defaultConfig {
        applicationId = "com.example.shopping_list"  <!-- Alterar aqui -->
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
}
```

4. **Atualizar MainActivity.kt**
```kotlin
// android/app/src/main/kotlin/com/example/shopping_list/MainActivity.kt
package com.example.shopping_list  <!-- Alterar aqui -->

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

#### iOS (ios/)

1. **Renomear Bundle Identifier**
   - Abrir `ios/Runner.xcodeproj` no Xcode
   - Selecionar "Runner" no Project Navigator
   - Em "General", alterar Bundle Identifier de:
     `com.example.flutterApplication1` → `com.example.shoppinglist`

2. **Atualizar pubspec.yaml (iOS)**
```yaml
# ios/Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.example.shoppinglist'
    end
  end
end
```

#### Windows (windows/)

```yaml
# windows/runner/Runner.rc
VS_VERSION_INFO STRUCT
...
VALUE "ProductName", "ShoppingList"
VALUE "FileDescription", "ShoppingList App"
```

#### Ícones do App

1. **Preparar ícone base**
   - Criar imagem 512x512px em PNG
   - Salvar como `assets/icons/app_icon.png`

2. **Gerar múltiplas resoluções**
```bash
flutter pub add dev:flutter_launcher_icons
flutter pub run flutter_launcher_icons
```

3. **Ícone Android** (Se não usar o script acima)
   - Salvar em: `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

4. **Ícone iOS** (Se não usar o script acima)
   - Abrir `ios/Runner.xcodeproj` no Xcode
   - Ir para: Runner → Assets.xcassets → AppIcon
   - Substituir com nova imagem 1024x1024px

### Verificação Final

```bash
# 1. Limpar build
flutter clean

# 2. Atualizar pubspec
flutter pub get

# 3. Verificar análise
flutter analyze

# 4. Testar build
flutter build apk      # Android
flutter build ios      # iOS
flutter build windows  # Windows
```

### Nomes de Domínio Recomendados

- **Android/iOS**: `com.shopping.list` ou `com.yourcompany.shoppinglist`
- **Versão Gratuita**: `com.shopping.list.free`
- **Versão Pro**: `com.shopping.list.pro`

### Checklist de Renomeação

- [ ] pubspec.yaml atualizado ✅
- [ ] main.dart atualizado ✅
- [ ] Assets organizados ✅
- [ ] Android package alterado
- [ ] iOS bundle identifier alterado
- [ ] Ícones do app criados e implementados
- [ ] Windows/macOS configurados (se aplicável)
- [ ] flutter clean executado
- [ ] flutter pub get executado
- [ ] Testes de build realizados

---

**Status Atual**: 50% da renomeação concluída. Aguardando implementação dos ícones e configurações específicas de plataforma.
