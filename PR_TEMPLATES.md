# GitHub Pull Request Templates

Cada PR deve seguir o template abaixo para garantir clareza e profissionalismo.

---

## 📋 Template Padrão de PR

```markdown
# [TIPO] - Descrição Breve da PR

## 📝 Descrição

Descrever a funcionalidade/mudança em 2-3 linhas.

### Contexto
Por que essa mudança é necessária? Qual problema resolve?

### Solução
Como foi resolvido? Qual é a abordagem técnica?

## 🎯 Objectives
- [ ] Objetivo 1
- [ ] Objetivo 2
- [ ] Objetivo 3

## 📋 Checklist de Implementação
- [ ] Funcionalidade implementada
- [ ] Testes adicionados
- [ ] Documentação atualizada
- [ ] Sem erros de compilação
- [ ] Sem warnings críticos

## 🧪 Validação

### Testes Realizados
- [ ] Teste A
- [ ] Teste B
- [ ] Teste C

### Screenshots (se aplicável)
[Adicionar screenshots]

## 📊 Impacto

### Arquivos Alterados
- `file1.dart` - O que foi mudado
- `file2.dart` - O que foi mudado

### Linhas de Código
- Adições: X linhas
- Remoções: Y linhas
- Modificações: Z linhas

## 🔗 Links Relacionados
- Issue #X
- Documentação relacionada

## 📝 Notas Adicionais
[Qualquer nota relevante]
```

---

## PR #1: Setup e Arquitetura Base

```markdown
# feat: Setup e Arquitetura Base

## 📝 Descrição
Configurar o projeto Flutter com estrutura de Clean Architecture, tema Material Design 3 e constants centralizados.

### Contexto
O projeto necessita de uma base sólida seguindo padrões de arquitetura profissional para garantir escalabilidade, testabilidade e manutenibilidade.

### Solução
- Estrutura Clean Architecture com camadas: presentation, domain, data, core
- AppTheme com Material Design 3 para modos claro/escuro
- AppConstants para configurações centralizadas
- AppAssets para gerenciamento de assets
- Named routes para navegação

## 🎯 Objectives
- [x] Inicializar projeto Flutter
- [x] Implementar Clean Architecture
- [x] Criar tema Material Design 3
- [x] Centralizar constants e assets
- [x] Configurar roteamento com named routes

## 📋 Checklist de Implementação
- [x] pubspec.yaml atualizado com dependências
- [x] Estrutura de pastas criada
- [x] AppTheme com 24+ text styles
- [x] Colors com light/dark mode
- [x] Named routes configuradas
- [x] Compilação sem erros
- [x] Sem warnings críticos

## 🧪 Validação
- [x] `flutter pub get` sem erros
- [x] `flutter analyze` sem warnings críticos
- [x] Compilação bem-sucedida
- [x] Hot reload funciona

## 📊 Impacto

### Arquivos Alterados
- `pubspec.yaml` - Dependências base
- `lib/main.dart` - Entry point
- `lib/src/app/app_theme.dart` - Tema (novo)
- `lib/src/app/app_constants.dart` - Constants (novo)
- `lib/src/app/routes.dart` - Rotas (novo)
- Estrutura de pastas: `presentation/`, `domain/`, `data/`, `core/`, `shared/`

### Linhas de Código
- Adições: ~800 linhas
- Remoções: 0 linhas
- Modificações: ~100 linhas

## 📝 Notas
Base sólida para todas as PRs subsequentes.
```

---

## PR #2: Fluxo de Autenticação

```markdown
# feat: Fluxo de Autenticação (Splash → Onboarding → Termos → Consentimento)

## 📝 Descrição
Implementar fluxo completo de inicialização com 4 telas e auto-routing inteligente baseado no estado do usuário.

### Contexto
A aplicação necessita de um fluxo de onboarding robusto que:
- Apresente termos e políticas (LGPD)
- Colha consentimento do usuário
- Permita pular etapas se já completadas
- Force re-leitura se termos forem atualizados

### Solução
- **SplashScreen:** Auto-routing com 4 condições de prioridade
- **OnboardingScreen:** Múltiplos slides com entrada de nome
- **TermsScreen:** Conteúdo scrollável com versioning
- **ConsentScreen:** Toggle com informações LGPD
- **PreferencesService:** Persistência de estado com SharedPreferences

## 🎯 Objectives
- [x] SplashScreen com auto-routing
- [x] OnboardingScreen com slides
- [x] TermsScreen com versioning
- [x] ConsentScreen com LGPD
- [x] PreferencesService implementado
- [x] Fluxo completo funcional

## 📋 Checklist de Implementação
- [x] Todas as 4 telas implementadas
- [x] PreferencesService com persistência
- [x] Roteamento com 4 prioridades
- [x] Validação de campos
- [x] Sem erros de navegação
- [x] Testes manuais completos

## 🧪 Validação
- [x] Fluxo: Splash → Onboarding → Terms → Consent → Home
- [x] Auto-routing funciona em cada cenário
- [x] Dados persistem após reinicio
- [x] Versão de termos detecta mudanças
- [x] Testar em landscape/portrait

## 📊 Impacto

### Arquivos Criados
- `lib/src/features/splash/splash_screen.dart`
- `lib/src/features/onboarding/onboarding_screen.dart`
- `lib/src/features/terms/terms_screen.dart`
- `lib/src/features/consent/consent_screen.dart`
- `lib/src/core/data/preferences_service.dart`

### Linhas de Código
- Adições: ~1200 linhas
- Remoções: 0 linhas

## 📝 Notas
Primeira experiência do usuário é crítica. Fluxo validado em emulador.
```

---

## PR #3: Home Screen e Features Base

```markdown
# feat: Home Screen e Gerenciamento de Listas

## 📝 Descrição
Implementar tela Home com dashboard, ações rápidas e funcionalidade de criar/gerenciar listas de compras.

### Contexto
Após autenticação, o usuário precisa de:
- Dashboard com status e ações rápidas
- Criar nova lista de compras
- Visualizar e editar listas existentes
- Adicionar/editar/remover items
- Toggle de tema claro/escuro

### Solução
- **HomeScreen:** Cards de status + grid 2x2 de ações
- **NewListScreen:** Formulário para criar lista
- **MyListsScreen:** Lista de todas as listas com menu de ações
- **ListDetailsScreen:** Adicionar/editar items com persistência
- Persistência em SharedPreferences

## 🎯 Objectives
- [x] HomeScreen com dashboard
- [x] NewListScreen funcional
- [x] MyListsScreen com CRUD
- [x] ListDetailsScreen com items
- [x] Tema toggle funcional
- [x] Persistência completa

## 📋 Checklist de Implementação
- [x] Todas as telas implementadas
- [x] Menu de ações (edit, duplicate, delete)
- [x] Formulários com validação
- [x] Toggle de tema persistido
- [x] Sem erros de navegação
- [x] Testes manuais

## 🧪 Validação
- [x] Criar lista e persistir
- [x] Minhas listas exibe corretamente
- [x] Menu de ações responde
- [x] Adicionar item funciona
- [x] Modo claro/escuro alterna corretamente

## 📊 Impacto

### Arquivos Criados
- `lib/src/features/home/home_screen.dart`
- `lib/src/features/home/new_list_screen.dart`
- `lib/src/features/home/my_lists_screen.dart`
- `lib/src/features/home/list_details_screen.dart`
- `lib/src/core/data/models/` (entidades)

### Linhas de Código
- Adições: ~1000 linhas
- Remoções: 0 linhas

## 📝 Notas
Core da funcionalidade. UI responsiva em portrait/landscape.
```

---

## PR #4: Sistema de Categorias

```markdown
# feat: Sistema de Categorias de Produtos

## 📝 Descrição
Implementar categorias de produtos com CRUD, color picker e agrupamento visual de items.

### Contexto
Usuários precisam organizar produtos em categorias para melhor gestão da lista. O sistema deve:
- Carregar 8 categorias padrão
- Permitir criar/editar/deletar categorias
- Permitir customizar cores
- Agrupar items por categoria visualmente

### Solução
- **CategoriesScreen:** CRUD de categorias com color picker
- **Color Picker:** 8 cores padrão para escolher
- **Agrupamento:** List Details agrupa items por categoria
- **Persistência:** Salva categorias e referências em SharedPreferences

## 🎯 Objectives
- [x] CRUD de categorias
- [x] Color picker implementado
- [x] 8 categorias padrão carregadas
- [x] Agrupamento visual em List Details
- [x] Persistência funcional

## 📋 Checklist de Implementação
- [x] CategoriesScreen implementada
- [x] Color picker com 8 cores
- [x] Criar/editar/deletar funcional
- [x] Agrupamento visual funciona
- [x] Persistência testada
- [x] Sem erros

## 🧪 Validação
- [x] Categorias padrão carregadas
- [x] CRUD funciona
- [x] Items agrupados por categoria
- [x] Cores exibidas corretamente
- [x] Deletar categoria não causa erro

## 📊 Impacto

### Arquivos Alterados
- `lib/src/features/home/categories_screen.dart` (novo)
- `lib/src/features/home/list_details_screen.dart` (updated)
- `lib/src/core/data/preferences_service.dart` (updated)

### Linhas de Código
- Adições: ~600 linhas
- Remoções: 0 linhas
- Modificações: ~200 linhas

## 📝 Notas
8 categorias padrão: Alimentos, Bebidas, Higiene, Limpeza, Eletrônicos, Roupas, Livros, Outros.
```

---

## PR #5: Acessibilidade WCAG 2.1 AA

```markdown
# feat: Acessibilidade WCAG 2.1 Nível AA

## 📝 Descrição
Implementar conformidade completa com diretrizes WCAG 2.1 nível AA para acessibilidade.

### Contexto
Acessibilidade é direito fundamental. A aplicação deve:
- Tamanho mínimo de 48x48dp para toques
- Contraste ≥ 4.5:1 para textos
- Labels semânticos em elementos interativos
- Modo escuro otimizado

### Solução
- **Constante minTouchSize:** 48dp para todos os botões
- **Semantics widgets:** Labels descritivos em elementos interativos
- **Contraste validado:** Cores em conformidade em light/dark
- **Modo escuro:** Cores otimizadas para OLED

## 🎯 Objectives
- [x] Botões padronizados 48x48dp
- [x] Labels semânticos adicionados
- [x] Contraste validado
- [x] Modo escuro otimizado

## 📋 Checklist de Implementação
- [x] Constante minTouchSize criada
- [x] Todos botões com tamanho mínimo
- [x] Semantics em elementos interativos
- [x] Contraste ≥ 4.5:1 validado
- [x] Modo escuro refinado
- [x] Auditoria visual completa

## 🧪 Validação
- [x] Auditoria visual de tamanhos
- [x] Verificação de contraste online
- [x] Teste em landscape/portrait
- [x] Ordem de leitura semântica verificada

## 📊 Impacto

### Arquivos Modificados
- `lib/src/app/app_constants.dart` (minTouchSize)
- `lib/src/app/app_theme.dart` (contraste)
- Todos `*_screen.dart` (Semantics)
- `lib/src/shared/**/*.dart` (acessibilidade)

### Linhas de Código
- Adições: ~400 linhas
- Modificações: ~500 linhas

## 📝 Notas
Conformidade WCAG 2.1 AA atingida. Preparado para TalkBack/VoiceOver futuros.
```

---

## PR #6: Revogação de Consentimento e Versioning

```markdown
# feat: Revogação de Consentimento com Undo e Versioning de Termos

## 📝 Descrição
Implementar revogação de consentimento com opção de "desfazer" e sistema de versioning para forçar re-aceitação de termos.

### Contexto
LGPD requer que usuários possam:
- Revogar consentimento a qualquer momento
- Ter período de "undo" por segurança
- Ser forçados a re-aceitar termos atualizados

### Solução
- **Botão Revogar:** Na Home com estilo alarme
- **Dialog confirmação:** Não dismissível
- **SnackBar undo:** 5 segundos com Timer
- **Versioning:** Constante currentTermsVersion + verificação
- **Redirecionamento:** Auto-navega para /terms após timeout

## 🎯 Objectives
- [x] Botão "Revogar Consentimento" na Home
- [x] Dialog de confirmação implementado
- [x] SnackBar com undo 5 segundos
- [x] Auto-redirecionamento para termos
- [x] Versioning de termos funcional
- [x] Splash verifica versão

## 📋 Checklist de Implementação
- [x] Botão implementado
- [x] Dialog não dismissível
- [x] SnackBar com undo funciona
- [x] Timer robusto (não Future.delayed)
- [x] Versioning implementado
- [x] Splash verifica versão
- [x] Testes manuais completos

## 🧪 Validação
- [x] Clicar "Revogar" → SnackBar aparece
- [x] Não clicar "Desfazer" → 5s depois redireciona
- [x] Clicar "Desfazer" → Restaura, fica em Home
- [x] Atualizar versão → Força re-aceitação

## 📊 Impacto

### Arquivos Alterados
- `lib/src/features/home/home_screen.dart` (updated)
- `lib/src/core/data/preferences_service.dart` (updated)
- `lib/src/app/app_constants.dart` (versioning)
- `lib/src/features/splash/splash_screen.dart` (version check)

### Linhas de Código
- Adições: ~500 linhas
- Modificações: ~200 linhas

## 📝 Notas
Implementação robusta com Timer em vez de Future.delayed(). Validado em emulador.
```

---

## PR #7: Documentação e Conformidade

```markdown
# docs: Documentação Completa e Conformidade LGPD/WCAG

## 📝 Descrição
Adicionar documentação abrangente do projeto, processo de desenvolvimento com IA e checklist de conformidade.

### Contexto
Transparência total sobre:
- Como o projeto foi desenvolvido com assistência de IA
- Prompts e decisões técnicas
- Status de conformidade com LGPD e WCAG 2.1 AA
- Roadmap de próximos passos

### Solução
- **RELATORIO_IA.md:** Detalhado processo de desenvolvimento (900+ linhas)
- **CHECKLIST_CONFORMIDADE.md:** Checklist executivo (500+ linhas)
- **PR_STRUCTURE.md:** Estrutura de PRs (este documento)

## 🎯 Objectives
- [x] Relatório IA documentado
- [x] Checklist de conformidade criado
- [x] Estrutura de PRs documentada
- [x] Prompts profissionalizados listados
- [x] Decisões rastreadas

## 📋 Checklist de Implementação
- [x] RELATORIO_IA.md completo
- [x] CHECKLIST_CONFORMIDADE.md completo
- [x] PR_STRUCTURE.md documentado
- [x] Todos arquivos em markdown profissional
- [x] Links cruzados

## 🧪 Validação
- [x] Documentação clara e acessível
- [x] Exemplos e prompts inclusos
- [x] Status transparente (74% completo)
- [x] Roadmap definido

## 📊 Impacto

### Arquivos Criados
- `RELATORIO_IA.md` (~900 linhas)
- `CHECKLIST_CONFORMIDADE.md` (~500 linhas)
- `PR_STRUCTURE.md` (~600 linhas)

### Linhas de Código
- Adições: ~2000 linhas de documentação

## 📝 Notas
Documentação destinada a fins educacionais e demonstração de processo profissional.
```

---

## 📌 Referências

- **Conventional Commits:** https://www.conventionalcommits.org/
- **WCAG 2.1:** https://www.w3.org/WAI/WCAG21/quickref/
- **LGPD:** https://www.gov.br/cidadania/pt-br/acesso-a-informacao/lgpd
- **Flutter Best Practices:** https://flutter.dev/docs/development/best-practices

---

**Desenvolvido com assistência de IA (GitHub Copilot)**  
**Data:** Dezembro de 2025
