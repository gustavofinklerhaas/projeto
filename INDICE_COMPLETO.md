# 📑 Índice Completo - Fluxo do App Shopping List

## 📌 Onde Começar?

### 1️⃣ Novo no Projeto?
- Leia: [SUMARIO_EXECUTIVO.md](SUMARIO_EXECUTIVO.md) (5 min)
- Depois: [QUICK_START_FLUXO.md](QUICK_START_FLUXO.md) (10 min)
- Execute: `flutter run` (30 seg)

### 2️⃣ Quer Entender a Arquitetura?
- Leia: [FLUXO_APP.md](FLUXO_APP.md) (15 min)
- Depois: [IMPLEMENTACAO_TECNICA.md](IMPLEMENTACAO_TECNICA.md) (20 min)

### 3️⃣ Precisa Testar?
- Leia: [GUIA_TESTES.md](GUIA_TESTES.md) (30 min)
- Siga os passos de cada cenário

### 4️⃣ Quer Copiar Código?
- Veja: [SNIPPETS_EXEMPLOS.md](SNIPPETS_EXEMPLOS.md) (16 tópicos prontos)

### 5️⃣ Consultando Rapidamente?
- Use: [REFERENCIA_RAPIDA.md](REFERENCIA_RAPIDA.md) (tabelas e listas)
- Abra: [FLUXO_APP_VISUAL.html](FLUXO_APP_VISUAL.html) (no navegador)

---

## 📂 Estrutura de Arquivos

### 🔵 Core (Fundação)

#### `lib/src/core/constants/app_constants.dart`
**Responsabilidade**: Constantes globais  
**Conteúdo**:
- `splashDurationSeconds = 3`
- `minimumTermsReadCount = 2`
- `minTouchSize = 48.0`
- `currentTermsVersion = '1.0.0'`

**Quando usar**: Import quando precisa de valores constantes  
**Exemplo**:
```dart
import 'package:flutter_application_1/src/core/constants/app_constants.dart';
SizedBox(height: AppConstants.minTouchSize);
```

---

#### `lib/src/core/data/preferences_service.dart`
**Responsabilidade**: Persistência de dados (SharedPreferences)  
**Métodos principais**:
```dart
await prefs.areTermsAccepted()          // bool
await prefs.setTermsAccepted('1.0.0')   // void
await prefs.getTermsReadCount()         // int
await prefs.incrementTermsReadCount()   // void
await prefs.refuseTerms()               // void
await prefs.clearAll()                  // void
```

**Quando usar**: Sempre que precisa salvar/recuperar dados  
**Exemplo**:
```dart
final prefs = PreferencesService();
await prefs.init();
await prefs.setTermsAccepted('1.0.0');
```

---

#### `lib/src/core/theme/app_theme.dart`
**Responsabilidade**: Tema Material Design 3 com acessibilidade  
**Componentes**:
- Cores (verde, laranja, vermelho, tons de cinza)
- Tipografia (display, headline, title, body, label)
- Botões, inputs, checkboxes com 48dp mínimo
- Contrastes WCAG 2.1 AA

**Quando usar**: Importar em main.dart para aplicar tema  
**Exemplo**:
```dart
MaterialApp(
  theme: AppTheme.getTheme(),
)
```

---

### 🟢 Features (Telas)

#### `lib/src/features/splash/splash_screen.dart`
**Responsabilidade**: Tela inicial que decide o fluxo  
**Duração**: 3 segundos  
**Lógica**:
- Se termos aceitos + onboarding completo → Home
- Se onboarding não completo → Onboarding
- Caso contrário → Termos

**Quando usar**: Homepage do app (setado em main.dart)  
**Widgets**:
- Logo circular
- Título
- Indicador de carregamento

---

#### `lib/src/features/onboarding/onboarding_screen.dart`
**Responsabilidade**: Onboarding com 4 páginas deslizáveis  
**Páginas**:
1. Bem-vindo
2. Organizado
3. Sincronizador
4. Comece Agora

**Controles**:
- PageView (desliza entre páginas)
- Dots indicadores (somem na última página)
- Botão "Pular" (vai para Consentimento, não fim)
- Botão "Próximo" → "Começar"

**Quando usar**: Explicar app para primeira vez

---

#### `lib/src/features/terms/terms_screen.dart`
**Responsabilidade**: Termos com progresso de leitura  
**Características principais**:
- SingleChildScrollView com barra de progresso
- Progresso visual (LinearProgressIndicator 0-100%)
- Contador de leituras (X/2)
- Botão "Marcar como Lido" aparece aos 95%
- Obriga ler 2 vezes
- Botão "Aceitar" desativado até ler 2x
- Botão "Recusar" com diálogo de confirmação

**Conteúdo dos termos**: Customizável em `_termsContent`

**Quando usar**: Após onboarding, antes de consentimento

---

#### `lib/src/features/consent/consent_screen.dart`
**Responsabilidade**: Consentimento opt-in (LGPD)  
**Consentimentos**:
1. Análise de Uso
2. Comunicações de Marketing

**Características**:
- Cards interativos com checkboxes
- Pode continuar SEM aceitar nada
- Visualização clara do selecionado
- Informações sobre LGPD

**Quando usar**: Antes de ir para Home

---

#### `lib/src/features/home/home_screen.dart`
**Responsabilidade**: Tela principal do app  
**Componentes**:
- Boas-vindas
- Cards de status (termos, consentimento)
- Grade de ações rápidas (4 cards)
- Informações sobre privacidade
- Botão de reset (desenvolvimento)

**Quando usar**: Após aceitar tudo (2º acesso vai direto aqui)

---

### 🟡 Main & Rotas

#### `lib/main.dart`
**Responsabilidade**: Inicialização do app e configuração de rotas  
**O que faz**:
1. Inicializa WidgetsFlutterBinding
2. Carrega PreferencesService
3. Configura MaterialApp com tema
4. Define todas as rotas

**Rotas disponíveis**:
```
/splash      → SplashScreen()
/onboarding  → OnboardingScreen()
/terms       → TermsScreen()
/consent     → ConsentScreen()
/home        → HomeScreen()
```

---

## 📄 Documentação

### 🔴 SUMARIO_EXECUTIVO.md
**Leia se**: Quer visão geral rápida  
**Tempo**: 5 minutos  
**Conteúdo**:
- O que foi entregue
- Checklist de requisitos
- Tabelas comparativas
- Valor entregue
- Métricas de sucesso

---

### 🔴 FLUXO_APP.md
**Leia se**: Quer entender a arquitetura completa  
**Tempo**: 15 minutos  
**Conteúdo**:
- Visão geral
- Arquitetura do projeto
- Fluxo de navegação detalhado
- Requisitos implementados
- Documentação de cada arquivo

---

### 🔴 IMPLEMENTACAO_TECNICA.md
**Leia se**: Quer entender linha por linha  
**Tempo**: 25 minutos  
**Conteúdo**:
- Código de cada arquivo
- Explicações técnicas
- Padrões usados
- Boas práticas implementadas

---

### 🔴 GUIA_TESTES.md
**Leia se**: Quer testar o app  
**Tempo**: 30 minutos (para executar todos)  
**Conteúdo**:
- Testes de acessibilidade
- Testes de fluxo
- Testes de LGPD
- Checklist final
- Relatório de teste

---

### 🔴 QUICK_START_FLUXO.md
**Leia se**: Quer começar do zero  
**Tempo**: 10 minutos  
**Conteúdo**:
- Como começar
- Estrutura criada
- Como testar cenários
- Debug e troubleshooting

---

### 🔴 REFERENCIA_RAPIDA.md
**Leia se**: Precisa consultar rapidamente  
**Tempo**: 2 minutos (cada tabela)  
**Conteúdo**:
- Tabelas de rotas
- Métodos de PreferencesService
- Dados persistidos
- Cores e tema
- Versões

---

### 🔴 SNIPPETS_EXEMPLOS.md
**Leia se**: Quer copiar código para expandir  
**Tempo**: Varie (cada snippet 1-2 min)  
**Conteúdo**:
- 16 tópicos com exemplos
- PreferencesService
- Navegação
- Componentes acessíveis
- Validações
- Testes

---

### 🔴 FLUXO_APP_VISUAL.html
**Abra se**: Quer sumário visual no navegador  
**Tempo**: 5 minutos  
**Conteúdo**:
- Cards coloridos
- Fluxos visuais
- Tabelas
- Checklist

---

## 🎯 Quick Links (O Que Procura)

### Acessibilidade
- **WCAG 2.1 AA implementado**: [FLUXO_APP.md#acessibilidade](FLUXO_APP.md)
- **Como fazer componentes acessíveis**: [SNIPPETS_EXEMPLOS.md#3-componentes-acessíveis](SNIPPETS_EXEMPLOS.md)
- **Testes de acessibilidade**: [GUIA_TESTES.md#testes-de-acessibilidade](GUIA_TESTES.md)

### LGPD
- **Conformidade LGPD**: [FLUXO_APP.md#lgpd](FLUXO_APP.md)
- **Testes LGPD**: [GUIA_TESTES.md#testes-de-lgpd](GUIA_TESTES.md)
- **Como versionar termos**: [SNIPPETS_EXEMPLOS.md#14-testar-preferencesservice](SNIPPETS_EXEMPLOS.md)

### Código
- **PreferencesService API**: [REFERENCIA_RAPIDA.md#preferencesservice](REFERENCIA_RAPIDA.md)
- **Exemplos de PreferencesService**: [SNIPPETS_EXEMPLOS.md#1-como-usar-preferencesservice](SNIPPETS_EXEMPLOS.md)
- **Como navegar entre telas**: [SNIPPETS_EXEMPLOS.md#2-navegação-entre-telas](SNIPPETS_EXEMPLOS.md)

### Setup
- **Como começar**: [QUICK_START_FLUXO.md#começar-do-zero](QUICK_START_FLUXO.md)
- **Como executar**: [SUMARIO_EXECUTIVO.md#como-começar-30-segundos](SUMARIO_EXECUTIVO.md)
- **Debug**: [QUICK_START_FLUXO.md#debug-e-troubleshooting](QUICK_START_FLUXO.md)

### Testes
- **Guia completo de testes**: [GUIA_TESTES.md](GUIA_TESTES.md)
- **Cenários de teste**: [QUICK_START_FLUXO.md#testando-diferentes-cenários](QUICK_START_FLUXO.md)

---

## 🔍 Índice de Métodos (PreferencesService)

| Método | Retorno | Descrição | Arquivo |
|--------|---------|-----------|---------|
| `init()` | Future | Inicializa SharedPreferences | `preferences_service.dart` |
| `areTermsAccepted()` | Future<bool> | Termos foram aceitos? | `preferences_service.dart` |
| `setTermsAccepted(version)` | Future | Marca como aceitos | `preferences_service.dart` |
| `getTermsReadCount()` | Future<int> | Quantas vezes leu? | `preferences_service.dart` |
| `incrementTermsReadCount()` | Future | Incrementa leitura | `preferences_service.dart` |
| `refuseTerms()` | Future | Marca como recusados | `preferences_service.dart` |
| `isConsentGiven()` | Future<bool> | Consentimento dado? | `preferences_service.dart` |
| `setConsentGiven()` | Future | Marca consentimento | `preferences_service.dart` |
| `isOnboardingCompleted()` | Future<bool> | Onboarding completo? | `preferences_service.dart` |
| `setOnboardingCompleted()` | Future | Marca onboarding | `preferences_service.dart` |
| `clearAll()` | Future | Limpa tudo | `preferences_service.dart` |

---

## 📊 Matriz de Compatibilidade

| Aspecto | Android | iOS | Web | Status |
|---------|---------|-----|-----|--------|
| Splash | ✓ | ✓ | ✓ | Completo |
| Onboarding | ✓ | ✓ | ✓ | Completo |
| Termos | ✓ | ✓ | ✓ | Completo |
| Consentimento | ✓ | ✓ | ✓ | Completo |
| Home | ✓ | ✓ | ✓ | Completo |
| SharedPreferences | ✓ | ✓ | ✓ | Completo |
| Acessibilidade | ✓ | ✓ | ✓ | WCAG AA |
| LGPD | ✓ | ✓ | ✓ | Completo |

---

## 🚀 Mapa de Estudo Recomendado

### Dia 1: Setup
1. Leia [SUMARIO_EXECUTIVO.md](SUMARIO_EXECUTIVO.md) (5 min)
2. Leia [QUICK_START_FLUXO.md](QUICK_START_FLUXO.md) (10 min)
3. Execute `flutter run` (30 seg)
4. Complete o fluxo manualmente (5 min)
5. **Total: 20 minutos**

### Dia 2: Entendimento
1. Leia [FLUXO_APP.md](FLUXO_APP.md) (15 min)
2. Abra [FLUXO_APP_VISUAL.html](FLUXO_APP_VISUAL.html) (5 min)
3. Leia [REFERENCIA_RAPIDA.md](REFERENCIA_RAPIDA.md) (10 min)
4. **Total: 30 minutos**

### Dia 3: Detalhes Técnicos
1. Leia [IMPLEMENTACAO_TECNICA.md](IMPLEMENTACAO_TECNICA.md) (25 min)
2. Veja [SNIPPETS_EXEMPLOS.md](SNIPPETS_EXEMPLOS.md) (15 min)
3. **Total: 40 minutos**

### Dia 4: Testes
1. Leia [GUIA_TESTES.md](GUIA_TESTES.md) (30 min)
2. Execute testes manuais (1 hora)
3. **Total: 1,5 horas**

### **Tempo Total de Aprendizado: ~2,5 horas para dominar tudo**

---

## 💡 Dicas Importantes

### Para Iniciantes
1. Comece com [SUMARIO_EXECUTIVO.md](SUMARIO_EXECUTIVO.md)
2. Execute o app (`flutter run`)
3. Leia [QUICK_START_FLUXO.md](QUICK_START_FLUXO.md)
4. Customize cores e textos
5. Depois mergulhe em detalhes técnicos

### Para Desenvolvedores
1. Vá direto para [FLUXO_APP.md](FLUXO_APP.md)
2. Estude [IMPLEMENTACAO_TECNICA.md](IMPLEMENTACAO_TECNICA.md)
3. Use [SNIPPETS_EXEMPLOS.md](SNIPPETS_EXEMPLOS.md) para expandir
4. Siga [GUIA_TESTES.md](GUIA_TESTES.md) para validar

### Para Product Managers
1. Leia [SUMARIO_EXECUTIVO.md](SUMARIO_EXECUTIVO.md)
2. Abra [FLUXO_APP_VISUAL.html](FLUXO_APP_VISUAL.html)
3. Veja [GUIA_TESTES.md#checklist-final](GUIA_TESTES.md)

### Para QA/Tester
1. Leia [GUIA_TESTES.md](GUIA_TESTES.md)
2. Siga cada cenário
3. Preencha o relatório de teste
4. Documente bugs encontrados

---

## 📞 Como Usar Este Índice

### Procurando por algo?
Use `Ctrl+F` (Windows) ou `Cmd+F` (Mac) para buscar nesta página

### Não achou?
1. Veja [REFERENCIA_RAPIDA.md](REFERENCIA_RAPIDA.md) (tabelas)
2. Procure em [FLUXO_APP.md](FLUXO_APP.md) (conteúdo)
3. Verifique [SNIPPETS_EXEMPLOS.md](SNIPPETS_EXEMPLOS.md) (código)

---

## ✅ Checklist Antes de Começar

- [ ] Leio este índice
- [ ] Leio [SUMARIO_EXECUTIVO.md](SUMARIO_EXECUTIVO.md)
- [ ] Executo `flutter run`
- [ ] Completo o fluxo manualmente
- [ ] Leio [QUICK_START_FLUXO.md](QUICK_START_FLUXO.md)
- [ ] Estou pronto para customizar

---

**Bem-vindo ao Shopping List App com fluxo completo!** 🎉

**Próximo passo?**
```bash
flutter run
```

**Dúvidas?**
- Procure neste índice
- Consulte os 7 documentos
- Veja os exemplos de código

**Bom desenvolvimento!** 🚀
