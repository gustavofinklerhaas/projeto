# Quick Start - Fluxo do App

## Estrutura Criada

```
lib/src/
├── core/
│   ├── constants/
│   │   └── app_constants.dart         (Constantes globais)
│   ├── data/
│   │   └── preferences_service.dart   (Persistência de dados)
│   └── theme/
│       └── app_theme.dart             (Tema com acessibilidade)
├── features/
│   ├── splash/
│   │   └── splash_screen.dart         (Tela inicial - 3s)
│   ├── onboarding/
│   │   └── onboarding_screen.dart     (4 páginas deslizáveis)
│   ├── terms/
│   │   └── terms_screen.dart          (Progresso de leitura)
│   ├── consent/
│   │   └── consent_screen.dart        (Opt-in de dados)
│   └── home/
│       └── home_screen.dart           (Tela principal)
└── main.dart                          (Ponto de entrada com rotas)
```

## Começar do Zero

### 1. Limpar Dados Anteriores

```bash
# Se você tinha dados armazenados
flutter clean
```

### 2. Instalar Dependências

```bash
flutter pub get
```

### 3. Executar o App

```bash
# Android
flutter run

# iOS
flutter run -t lib/main.dart

# Web
flutter run -d chrome
```

### 4. Primeira Execução

O fluxo será:
1. **Splash** (logo + carregamento 3s)
2. **Onboarding** (4 páginas com dots)
3. **Termos** (ler 2x, progresso visual)
4. **Consentimento** (opt-in de análise e marketing)
5. **Home** (tela principal)

## Fluxo Completo Mapeado

```
┌─────────────────────────────────────┐
│         SPLASH SCREEN               │
│    - Logo e carregamento            │
│    - 3 segundos                     │
│    - Verifica status do usuário     │
└────────────┬────────────────────────┘
             │
        Decisão:
        ├─ Nunca entrou?        ──→ Onboarding
        ├─ Entrou mas não fez?  ──→ Termos
        └─ Tudo feito?          ──→ Home

┌─────────────────────────────────────┐
│      ONBOARDING SCREEN              │
│    - Página 1: Bem-vindo            │
│    - Página 2: Organizado           │
│    - Página 3: Sincronizador        │
│    - Página 4: Comece Agora         │
│                                     │
│    Controles:                       │
│    - Próximo (PageView)             │
│    - Pular (vai para Consentimento) │
│    - Dots (somem na última)         │
└────────────┬────────────────────────┘
             │
             └──────────────┐
                           │
        ┌─────────────────────────────┐
        │   TÉRMINOS SCREEN           │
        │ - Conteúdo com scroll       │
        │ - Barra de progresso        │
        │ - Contagem: 1/2, 2/2        │
        │ - Botão aparece aos 95%     │
        │ - Precisa ler 2x            │
        │ - Aceitar/Recusar           │
        └────────────┬────────────────┘
                     │
         ┌───────────────────────────┐
         │  CONSENT SCREEN           │
         │ - Análise de Uso          │
         │ - Marketing               │
         │ - Opcional (pode pular)    │
         └────────────┬────────────────┘
                      │
         ┌────────────────────────────┐
         │    HOME SCREEN             │
         │ - Status de aceitação      │
         │ - Ações rápidas            │
         │ - Reset para teste         │
         └────────────────────────────┘
```

## Testando Diferentes Cenários

### Cenário 1: Primeiro Acesso Completo
```bash
# Executar o app normalmente
flutter run
# Completar todo o fluxo até Home
```

### Cenário 2: Skip do Onboarding
```bash
# Na tela de Onboarding
# Clicar "Pular" (não "Próximo")
# Vai direto para Consentimento
```

### Cenário 3: Recusar Termos
```bash
# Na tela de Termos
# Ler 2x (contador 2/2)
# Clicar "Recusar"
# Diálogo: "Desfazer" ou "Confirmar Recusa"
```

### Cenário 4: Segundo Acesso
```bash
# Fechar e reabrir o app
# Deve ir direto para Home (sem fluxo)
# Verificar que status permanece
```

### Cenário 5: Reset do App
```bash
# Na Home
# Clicar "Resetar Aplicativo"
# Confirmar
# Volta para Splash como primeira vez
```

## Debug e Troubleshooting

### Ver Dados Salvos (Android)

```bash
# Conectar device e executar
adb shell
run-as com.example.flutter_application_1
cat /data/data/com.example.flutter_application_1/shared_prefs/flutter_application_1.xml
```

### Ver Logs do App

```bash
# Terminal 1: Start app
flutter run

# Terminal 2: Ver logs
flutter logs
```

### Debug Acessibilidade

```dart
// Em main.dart, mude para true:
showSemanticsDebugger: true,

// Rebuild e veja a árvore semântica
```

### Limpar SharedPreferences

```bash
# Se dados estiverem corrompidos
flutter clean
flutter pub get
flutter run
```

## Constantes Importantes

```dart
// app_constants.dart
splashDurationSeconds = 3           // Tempo do splash
minimumTermsReadCount = 2            // Vezes que deve ler
minTouchSize = 48.0                  // Tamanho mínimo botão
currentTermsVersion = '1.0.0'        // Versão dos termos
```

## Rotas do App

```dart
// main.dart - Todas as rotas disponíveis
'/splash'      → SplashScreen()
'/onboarding'  → OnboardingScreen()
'/terms'       → TermsScreen()
'/consent'     → ConsentScreen()
'/home'        → HomeScreen()
```

## Acessibilidade - Testando

### Android TalkBack
```
1. Settings > Accessibility > TalkBack
2. Volume + ambos os lados para iniciar
3. Usar swipe right/left para navegar
4. Double tap para ativar
```

### iOS VoiceOver
```
1. Settings > Accessibility > VoiceOver
2. Toggle para ligar
3. Swipe right/left para navegar
4. Double tap para ativar
```

### Teste Rápido de Toque
```
- Todos botões devem ter área mínima 48x48 dp
- Deve caber o dedo inteiro sem problema
- Não deve ser necessário ser preciso
```

## LGPD - Conformidade Checklist

```
✓ Consentimento explícito (opt-in)
✓ Versão de termos registrada (1.0.0)
✓ Histórico de aceitos/recusados
✓ Dados armazenados localmente
✓ Sem coleta automática
✓ Informações claras sobre dados
✓ Opção de desfazer
✓ Interface transparente
```

## Próximos Passos

Após validar este fluxo:

1. **Autenticação**: Implementar login/cadastro
2. **Backend**: Conectar API para sincronização
3. **Notificações**: Integrar push notifications
4. **Analytics**: Implementar Google Analytics (com consentimento)
5. **Banco de Dados**: SQLite para listas offline
6. **Compartilhamento**: Funcionalidade de compartilhamento
7. **Temas**: Dark mode e light mode

## Documentação Completa

- `FLUXO_APP.md` - Visão geral e arquitetura
- `IMPLEMENTACAO_TECNICA.md` - Detalhes técnicos de cada arquivo
- `GUIA_TESTES.md` - Procedimentos de teste
- `QUICK_START.md` - Este arquivo (início rápido)

## Support

Para dúvidas sobre o fluxo:
1. Verifique os comentários no código
2. Consulte FLUXO_APP.md para arquitetura
3. Consulte IMPLEMENTACAO_TECNICA.md para detalhes
4. Consulte GUIA_TESTES.md para validação

## Versão

- Flutter: ^3.9.0
- SharedPreferences: ^2.2.2
- Material Design 3: Integrado
- LGPD: Compatível
- Acessibilidade: WCAG 2.1 AA

---

**Data de Criação**: Dezembro 2025
**Status**: Pronto para teste e customização
