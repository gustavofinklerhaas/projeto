# Relatório: Utilização de Assistente de IA no Desenvolvimento do Shopping List App

**Autores:** Gustavo Finkler Haas e GitHub Copilot  
**Data:** Dezembro de 2025  
**Projeto:** Shopping List App - Aplicação Flutter com Conformidade LGPD  
**Propósito:** Documentar o processo de desenvolvimento, decisões técnicas e iterações com assistência de IA.

---

## 1. Objetivo e Escopo do Projeto

Implementar uma aplicação móvel (Flutter) de lista de compras que atenda aos seguintes requisitos:

- **Conformidade Legal:** Lei Geral de Proteção de Dados Pessoais (LGPD)
- **Acessibilidade:** Diretrizes WCAG 2.1 nível AA
- **Usabilidade:** Fluxo intuitivo com termos, consentimento e revogação
- **Experiência:** Suporte a modo escuro, categorização de produtos, persistência de dados
- **Arquitetura:** Clean Architecture com separação de responsabilidades

---

## 2. Metodologia de Utilização de IA

### 2.1 Fase 1: Planejamento e Arquitetura

**Objetivo:** Definir estrutura do projeto, padrões de código e dependências.

**Prompts Utilizados:**

1. **"Crie uma estrutura de projeto Flutter seguindo Clean Architecture com camadas: presentation, domain, data e core. Inclua pastas para features e shared widgets. Quero conformidade LGPD e acessibilidade WCAG 2.1 AA."**
   - *Resposta:* Geração da estrutura hierárquica de pastas, organização de arquivos por funcionalidade
   - *Decisão:* Adotar padrão de features por domínio (home, splash, terms, etc.)

2. **"Defina um sistema de tema Material Design 3 para Flutter com suporte a modo claro e escuro, incluindo 24 estilos de texto padronizados e cores em conformidade com acessibilidade."**
   - *Resposta:* Implementação de `AppTheme` com `ThemeData` customizado
   - *Validação:* Verificação de contraste mínimo 4.5:1 para texto

3. **"Crie um serviço de preferências usando SharedPreferences para persistência de: termos aceitos, versão de termos, consentimento, modo escuro, listas de compras e categorias."**
   - *Resposta:* Classe `PreferencesService` com métodos CRUD para cada entidade
   - *Validação:* Testado armazenamento e recuperação em emulador Android

---

### 2.2 Fase 2: Implementação de Features Principais

#### Feature 1: Fluxo de Inicialização (Splash → Onboarding → Termos → Consentimento)

**Prompts:**

1. **"Implemente uma Splash Screen que exiba por 3 segundos e redirecione automaticamente baseado em: (1) versão de termos desatualizada?, (2) onboarding não concluído?, (3) termos ou consentimento não aceitos?. Se tudo OK, vá para Home."**
   - *Resposta:* Lógica de roteamento em `_initializeAndNavigate()` com 4 condições prioritárias
   - *Decisão:* Usar `pushReplacementNamed()` para limpar stack de navegação
   - *Validação:* Testado cada caminho de condição no emulador

2. **"Crie uma tela de Onboarding que exiba bem-vindas ao usuário, permita definir nome e mostre 3 passos visuais explicando a app."**
   - *Resposta:* Tela com `PageView` mostrando slides informativos
   - *Validação:* Verificado acessibilidade semântica com `Semantics` widgets

3. **"Implemente tela de Termos e Políticas com scroll de conteúdo, checkbox de leitura (que só habilita botão após marcar) e versioning de termos."**
   - *Resposta:* Tela com campo versioning integrado, lógica de checkbox com `setState()`
   - *Decisão:* Adicionar campo de versão visível ao usuário (ex: "v2.0.0")

4. **"Crie tela de Consentimento de Dados explicando coleta de dados, com toggle para aceitar/rejeitar e informações LGPD."**
   - *Resposta:* Tela com UI intuitiva, informações estruturadas sobre privacidade
   - *Validação:* Textos alinhados com marco legal LGPD

#### Feature 2: Sistema de Categorias com Persistência

**Prompt:**

**"Implemente um sistema de categorias de produtos com: (1) 8 categorias padrão (Alimentos, Bebidas, Higiene, etc), (2) cores customizáveis, (3) CRUD completo, (4) agrupamento de itens por categoria na lista de compras, (5) persistência em SharedPreferences."**
   - *Resposta:* Classes `Category`, `PreferencesService` com métodos de categoria, UI com dropdown e color picker
   - *Decisão:* Armazenar categorias como JSON serializado no SharedPreferences
   - *Validação:* Testado criação, edição, deleção e persistência no emulador

#### Feature 3: Revogação de Consentimento

**Prompts:**

1. **"Crie um método de revogação de consentimento que: (1) mostra diálogo de confirmação, (2) ao confirmar, exibe SnackBar com opção 'Desfazer' por 5 segundos, (3) se não clicar Desfazer, redireciona para tela de Termos, (4) se clicar Desfazer, restaura o consentimento."**
   - *Resposta:* Implementação com `Timer` explícito para controle robusto do timeout
   - *Decisão:* Usar `Timer` em vez de `Future.delayed()` para evitar race conditions
   - *Validação:* Testado todos os caminhos (timeout, undo)

2. **"Implemente sistema de versioning de termos: se a versão atual diferir da salva, force o usuário a reler mesmo que já tenha aceito antes."**
   - *Resposta:* Método `isTermsVersionOutdated()` em `PreferencesService`, constante `AppConstants.currentTermsVersion`
   - *Decisão:* Versioning semântico (ex: "2.0.0")

---

### 2.3 Fase 3: Acessibilidade e Conformidade

**Prompts:**

1. **"Padronize todos os botões e áreas clicáveis para mínimo 48x48 dp (WCAG 2.1 AA). Atualize constante AppConstants.minTouchSize = 48.0 e aplique em todos os widgets interativos."**
   - *Resposta:* Auditoria de todos os ElevatedButton, IconButton, InkWell
   - *Decisão:* Usar `constraints: BoxConstraints(minHeight: 48, minWidth: 48)`
   - *Validação:* Checagem visual em múltiplas resoluções

2. **"Adicione labels semânticos a todos os widgets interativos usando Semantics, com descrições descritivas (label, button, enabled, onTap)."**
   - *Resposta:* Wrapper de `Semantics` em botões, cards, ícones
   - *Validação:* Estrutura para TalkBack/VoiceOver no futuro

3. **"Implemente suporte a modo escuro completo com cores em conformidade de contraste (4.5:1 mínimo para texto)."**
   - *Resposta:* `app_theme.dart` com `ThemeData.dark()` customizado
   - *Validação:* Verificado contraste em Color Contrast Analyzer

---

### 2.4 Fase 4: Resolução de Problemas e Iterações

**Problemas Encontrados e Soluções com IA:**

| Problema | Prompt Utilizado | Solução | Validação |
|----------|------------------|---------|-----------|
| Botão de Termos "piscando" ao clicar | "Por que meu botão fica intermitente ao clicar? Como evitar re-renders desnecessários?" | Remover `setState()` desnecessário, usar `UniqueKey` | Testado no emulador |
| Menu de editar/deletar não funcionava | "Como debugar ações que não respondem em PopupMenuButton? Qual é a ordem correta de callbacks?" | Adicionar `debugPrint()`, verificar contexto de navegação | Logs mostrando execução |
| Erro "Erro ao criar lista" ao salvar | "Como persistir corretamente um Map<String, dynamic> em SharedPreferences? Como serializar e desserializar?" | Usar `jsonEncode()` e `jsonDecode()` | Teste de round-trip |
| Consentimento não redireciona após 5s | "Como executar navegação confiável após Timer? Qual é a melhor prática para pushReplacementNamed em callbacks?" | Usar `Timer` com `mounted` guard, contexto da screen | Fluxo completo testado |
| Null Safety na navegação de dialog | "Como acessar NavigatorState depois que uma dialog fecha? Qual contexto usar?" | Usar `dialogContext` separado e passar `context` original para Timer | Sem exceções |

---

## 3. Prompts Profissionais Utilizados (Simulação)

### 3.1 Prompts de Análise

```
"Analise a implementação atual de acessibilidade do projeto Flutter. 
Identifique todas as áreas que não atendem a WCAG 2.1 nível AA, 
incluindo tamanhos de toque, contraste de cores, labels semânticos 
e navegação por teclado. Forneça recomendações específicas com exemplos de código."
```

```
"Revise o diagrama arquitetural da aplicação em relação a Clean Architecture. 
Verifique se há violação de dependências entre camadas (presentation → domain → data). 
Identifique acoplamentos indevidos e sugira refatorações."
```

### 3.2 Prompts de Implementação

```
"Implemente um sistema robusto de persistência de estado para o Shopping List App que:
1. Utilize SharedPreferences para armazenamento local
2. Suporte versionamento de esquema de dados
3. Implemente migração automática se a versão mudar
4. Garanta consistência transacional em operações múltiplas
5. Forneca métodos de backup e restauração de dados"
```

```
"Crie um módulo de conformidade LGPD que:
1. Registre cada interação do usuário com consentimento (timestamp, ação)
2. Permita revogação de consentimento com histórico
3. Implemente direito ao esquecimento (deletar todos os dados)
4. Gere relatório de consentimento em formato compatível com auditorias"
```

### 3.3 Prompts de Validação

```
"Escreva testes unitários para o PreferencesService que cubra:
1. Persistência e recuperação de cada entidade (listas, itens, categorias)
2. Comportamento de timeout e erro de I/O
3. Migração de versão de dados
4. Validação de tipos e null-safety
Alvo: 90% de cobertura de código"
```

---

## 4. Decisões Técnicas Validadas com IA

| Decisão | Alternativa Considerada | Justificativa | IA Consultada |
|---------|-------------------------|---------------|---------------|
| **Clean Architecture** | MVC / MVVM | Escalabilidade, testabilidade, separação de concerns | Sim |
| **SharedPreferences** | SQLite / Hive | Simplicidade para MVP, sem dependências nativas | Sim |
| **Material Design 3** | Custom Design System | Conformidade com Google, acessibilidade built-in | Sim |
| **Timer para Revogação** | Future.delayed() | Evitar race conditions e context issues | Sim |
| **Versioning Semântico** | Timestamp / Hash | Clareza para usuário final | Sim |
| **Semantic Widgets** | Apenas MaterialApp | Compatibilidade com leitores de tela | Sim |

---

## 5. Iterações Realizadas

### Iteração 1: Estrutura Base
- ✅ Criação de arquitetura Clean
- ✅ Setup de temas Light/Dark
- ✅ Inicialização de PreferencesService

### Iteração 2: Fluxo de Autenticação
- ✅ Splash com auto-routing
- ✅ Telas de Onboarding, Termos, Consentimento
- ✅ Persistência de estado

### Iteração 3: Features de Domínio
- ✅ Criar/Editar/Deletar listas e itens
- ✅ Sistema de categorias
- ✅ Agrupamento visual por categoria

### Iteração 4: Acessibilidade
- ✅ Botões 48x48dp
- ✅ Labels semânticos
- ✅ Modo escuro com contraste

### Iteração 5: Refinamento
- ✅ Revogação de consentimento com undo
- ✅ Versioning de termos
- ✅ Correção de bugs de navegação

---

## 6. Métricas de Desenvolvimento

| Métrica | Valor |
|---------|-------|
| Total de Features Implementadas | 6 |
| Total de Telas | 12+ |
| Linhas de Código (Dart) | ~3,500 |
| Arquivos de Configuração | 8+ |
| Commits Realizados | 15+ |
| Issues Resolvidas | 8 |
| Tempo Estimado sem IA | 40-50h |
| Tempo com IA | 20-25h |
| **Ganho de Produtividade** | **~50-60%** |

---

## 7. Validações Realizadas

### Testes Manuais
- ✅ Fluxo completo de inicialização
- ✅ Criação/edição/deleção de listas
- ✅ Categorias com persistência
- ✅ Revogação de consentimento com undo
- ✅ Modo escuro ativação/desativação
- ✅ Navegação em modo landscape/portrait

### Verificações de Conformidade
- ✅ Compilação sem erros críticos
- ✅ Nenhum warning relacionado a null-safety
- ✅ Tamanhos de toque ≥ 48dp (WCAG 2.1 AA)
- ✅ Contraste de cores ≥ 4.5:1 (WCAG 2.1 AA)
- ✅ Labels semânticos em widgets interativos
- ✅ Fluxo LGPD com consentimento e revogação

---

## 8. Aprendizados e Conclusões

### O que funcionou bem:
1. **Iteração rápida com feedback de IA** - Identificação e correção de issues em minutos
2. **Prompts específicos e contextualizados** - Resultados mais precisos e aplicáveis
3. **Validação contínua** - Testar após cada implementação preveniu bugs acumulativos
4. **Documentação paralela** - Manter registros de decisões facilitou reflexão posterior

### Desafios:
1. **Race conditions em callbacks assíncronos** - Requereram múltiplas iterações para resolver
2. **Contextos em diálogos** - Exigiu cuidado ao referenciar Navigator em callbacks
3. **Acessibilidade não é trivial** - Requer auditoria sistemática, não apenas implementação

### Recomendações para Próximas Fases:
1. **Testes Automatizados:** Implementar widget tests e integration tests com cobertura ≥ 80%
2. **Testes de Acessibilidade:** Usar TalkBack (Android) / VoiceOver (iOS) para validação real
3. **CI/CD:** Configurar GitHub Actions para rodar testes e análise lint em cada PR
4. **Observabilidade:** Adicionar analytics de comportamento de usuário (com consentimento)

---

## 9. Conclusão

O desenvolvimento do Shopping List App com assistência de IA demonstrou significativa melhoria em velocidade e qualidade. A abordagem de **prompts bem-estruturados, validação contínua e iteração rápida** resultou em uma aplicação que atende aos requisitos de funcionalidade, acessibilidade e conformidade legal, enquanto mantém código limpo e manutenível.

A IA foi utilizada não apenas para gerar código, mas para **validar decisões arquiteturais, identificar problemas potenciais e guiar refinamentos iterativos**. Isso resultou em um produto final robusto e alinhado com as melhores práticas da indústria.

---

**Assinado em:** 11 de dezembro de 2025  
**Desenvolvedor:** Gustavo Finkler Haas  
**Assistente de IA:** GitHub Copilot (Modelo Claude 3.5)
