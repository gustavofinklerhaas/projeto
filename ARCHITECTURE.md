# Shopping List Clean Architecture

App Flutter focado **exclusivamente para Android** seguindo os princípios da **Clean Architecture**.

## 📁 Estrutura do Projeto

```
lib/
 └─ src/
     ├─ app/
     │   ├─ app_widget.dart       # MaterialApp, tema e rotas
     │   └─ routes.dart           # Configuração das rotas nomeadas
     ├─ core/                     # Camada de infraestrutura (vazia por enquanto)
     └─ features/
         ├─ home/
         │   └─ home_page.dart    # Página inicial (placeholder)
         ├─ onboarding/
         │   └─ onboarding_page.dart  # PageView com 2 telas
         └─ splash/
             └─ splash_page.dart  # Splash screen (2 seg)
```

## 🚀 Funcionalidades Implementadas

### 1. **Launch (flutter_native_splash)**
- ✅ Configurado para funcionar **apenas em Android**
- ✅ Logo centralizada e cor de fundo branca
- ✅ Integrado no `main.dart` com `FlutterNativeSplash`

### 2. **Splash Screen**
- ✅ Logo centralizada com `ClipRRect`
- ✅ Indicador `CircularProgressIndicator`
- ✅ Texto "Carregando..."
- ✅ Navegação automática em 2 segundos para `/onboarding`
- ✅ Acessibilidade semântica

### 3. **Onboarding**
- ✅ `PageView` com 2 telas
- ✅ Cada tela contém:
  - Imagem/emoji
  - Título
  - Descrição
- ✅ Indicadores de página com animação
- ✅ Botão "Próximo" (páginas 1-2) e "Começar" (página 2)
- ✅ Navegação para `/home` ao finalizar
- ✅ Design responsivo com `SafeArea` e `Padding`
- ✅ Acessibilidade total (`Semantics`)

### 4. **Rotas Nomeadas**
```dart
"/"           → SplashPage
"/onboarding" → OnboardingPage
"/home"       → HomePage
```

### 5. **App Widget**
- ✅ `MaterialApp` com tema customizado
- ✅ Cor primária: `#6200EE` (roxo Material)
- ✅ Material Design 3 ativado
- ✅ Tipografia consistente

### 6. **Home Page**
- ✅ Placeholder com AppBar e FAB
- ✅ Pronto para implementação da lista de compras

## 🛠️ Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_native_splash: ^2.4.0
```

## 📱 Como Compilar

### Compilar para APK (Debug):
```bash
flutter build apk --debug
```

### Compilar para APK (Release):
```bash
flutter build apk --release
```

### Rodar no dispositivo/emulador:
```bash
flutter run
```

## 🧪 Testes

```bash
flutter test
```

## 📋 Clean Architecture - Próximos Passos

- [ ] Implementar camada **Domain** (usecases)
- [ ] Implementar camada **Data** (repositories, datasources)
- [ ] Adicionar gerenciador de estado (Provider/BLoC)
- [ ] Implementar funcionalidades da lista de compras
- [ ] Adicionar autenticação/persistência local
- [ ] Testes unitários e integração

## ✅ Checklist de Qualidade

- ✅ Sem erros de análise (`flutter analyze`)
- ✅ Sem dependências desnecessárias
- ✅ Super parameters utilizados
- ✅ Semantics para acessibilidade
- ✅ Material Design 3 
- ✅ Apenas Android (ios, web, linux, macos, windows removidos)
- ✅ main.dart limpo e integrado

---

**Pronto para iniciar o desenvolvimento!** 🚀
