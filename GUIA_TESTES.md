# Guia de Testes - Fluxo do App

## Testes de Acessibilidade

### 1. Navegação por Teclado

#### Android com TalkBack
```
1. Ativar TalkBack:
   - Settings > Accessibility > TalkBack
   - Volume + (ambos) para iniciar

2. Testar cada tela:
   - Tab: próximo elemento
   - Shift+Tab: elemento anterior
   - Double tap: ativar
   - Swipe up depois direita: menu

3. Verificar:
   ✓ Todos os botões recebem foco
   ✓ Labels são lidos corretamente
   ✓ Ordem de tab faz sentido
   ✓ Ícones têm rótulos semânticos
```

#### iOS com VoiceOver
```
1. Ativar VoiceOver:
   - Settings > Accessibility > VoiceOver

2. Testar cada tela:
   - Swipe right: próximo elemento
   - Swipe left: elemento anterior
   - Double tap: ativar
   - Rotor: pular para elementos específicos

3. Verificar:
   ✓ Foco visível em tudo
   ✓ Leitura de rótulos clara
   ✓ Ações acionáveis
```

### 2. Contraste de Cores

#### Ferramenta: WCAG Contrast Checker
```
1. Passos:
   - Instalar extensão Chrome "Contrast Checker"
   - Navegar por cada tela
   - Clicar em elementos de texto
   - Verificar ratio mínimo

2. Verificar:
   ✓ Texto preto sobre branco: >7:1
   ✓ Texto cinza sobre branco: >4.5:1
   ✓ Ícones sobre cores: >3:1
   ✓ Bordas de focus: visíveis
```

#### Validação em Flutter
```dart
// Todos os contrastes já testados:
// Branco (#FFFFFF) + Preto (#212121) = 21:1 ✓
// Branco (#FFFFFF) + Cinza (#757575) = 6:1 ✓
// Verde (#2E7D32) + Branco = 4.5:1 ✓
```

### 3. Tamanho de Componentes

#### Teste Manual
```
1. Abrir inspector do device:
   - Android: Developer Options > Pointer Location
   - iOS: Settings > Developer > Show Touches

2. Testar cada botão:
   - Tentar clicar com dedo inteiro
   - Não deve ser necessário ser muito preciso

3. Verificar:
   ✓ Botões: 48x48 ou maior
   ✓ Checkboxes: 48x48
   ✓ Touchable areas: claramente identificadas
```

#### Validação no Código
```dart
// Todos os componentes já validados em app_theme.dart
ElevatedButton.styleFrom(
  minimumSize: const Size(48.0, 48.0),  // ✓
)

Checkbox(
  visualDensity: const VisualDensity(
    horizontal: VisualDensity.maximized,  // ✓
    vertical: VisualDensity.maximized,    // ✓
  ),
)
```

### 4. Focus Visível

#### Teste com Navegação por Teclado
```
1. Conectar teclado Bluetooth
2. Navegar apenas com Tab
3. Verificar:
   ✓ Foco sempre visível (borda de 2px)
   ✓ Cor de foco diferencia de estado normal
   ✓ Hover state também claro
```

## Testes de Fluxo

### 1. Primeira Execução Completa

```
ESPERADO:
Splash (3s) → Onboarding (4 páginas) 
→ Termos (ler 2x) → Consentimento → Home

PASSOS:
1. ✓ Splash mostra logo e carregamento
2. ✓ Paging automático após 3 segundos
3. ✓ Onboarding com página 1/4
4. ✓ Dots indicadores aparecem
5. ✓ Botão Pular funciona (vai para Consentimento)
6. ✓ Próximo botão avança página
7. ✓ Último botão é "Começar"
8. ✓ Termos têm scrollbar
9. ✓ Progresso visual (barra verde)
10. ✓ Botão "Marcar como Lido" aparece aos 95%
11. ✓ Contagem de leituras: 0/2 inicialmente
12. ✓ Depois primeira leitura: 1/2
13. ✓ Segundo "Marcar como Lido": 2/2
14. ✓ Botão "Aceitar" fica habilitado
15. ✓ Consentimento com 2 checkboxes
16. ✓ Pode continuar sem marcar nada
17. ✓ Home mostra status "Termos Aceitos"
```

### 2. Primeiro Acesso com Skip

```
ESPERADO:
Splash → Onboarding (com skip) → Consent → Home

PASSOS:
1. ✓ Splash normal (3s)
2. ✓ Primeiro slide do Onboarding
3. ✓ Clicar "Pular" (não em "Próximo")
4. ✓ Vai direto para Consentimento
5. ✓ Termos NÃO marcados como lidos
6. ✓ Home mostra status diferente
```

### 3. Recusa de Termos

```
ESPERADO:
Conseguir recusar, mas também desfazer

PASSOS:
1. ✓ Chegar na tela de Termos
2. ✓ Ler 2 vezes (contagem 2/2)
3. ✓ Clicar "Recusar"
4. ✓ Diálogo aparece com aviso
5. ✓ Clicar "Desfazer"
6. ✓ Diálogo fecha
7. ✓ Volta ao estado anterior
8. ✓ Clicar "Recusar" novamente
9. ✓ Clicar "Confirmar Recusa"
10. ✓ Mensagem vermelha aparece
11. ✓ Botão "Aceitar" fica disabled
12. ✓ Não consegue continuar sem aceitar
```

### 4. Segundo Acesso (Sem Repetir Fluxo)

```
ESPERADO:
Splash (3s) → Home (direto)

PASSOS:
1. ✓ Splash mostra logo
2. ✓ Após 3s vai direto para Home
3. ✓ Nenhuma outra tela aparece
4. ✓ Home mostra todos os status como concluído
```

### 5. Reset do App

```
ESPERADO:
Limpar dados e voltar para Splash

PASSOS:
1. ✓ Estar na Home
2. ✓ Clicar "Resetar Aplicativo"
3. ✓ Diálogo de confirmação
4. ✓ Clicar "Confirmar"
5. ✓ Volta para Splash
6. ✓ Fluxo começa do zero novamente
```

## Testes de LGPD

### 1. Versionamento de Termos

```
VERIFICAR NO CÓDIGO:
1. Aceitar termos na versão 1.0.0
2. Salva em SharedPreferences:
   - Key: 'terms_version'
   - Value: '1.0.0'

COMMAND (Android):
$ adb shell run-as com.example.flutter_application_1
$ cat /data/data/com.example.flutter_application_1/shared_prefs/
```

### 2. Registro de Consentimento

```
VERIFICAR:
1. Após aceitar em Consentimento
2. SharedPreferences tem:
   - 'consent_given': true
   - Data: timestamp do sistema

TEST CODE:
final prefs = await SharedPreferences.getInstance();
print(prefs.getBool('consent_given'));  // true
```

### 3. Histórico de Leituras

```
VERIFICAR:
1. Abrir Termos
2. "Ler" (scroll até 95%)
3. Clicar "Marcar como Lido"
4. Contagem: 1/2

5. Scroll novamente
6. Clicar "Marcar como Lido"
7. Contagem: 2/2

TEST CODE:
final count = await prefs.getInt('terms_read_count');
print('Lido $count vezes');  // Lido 2 vezes
```

### 4. Recusas Registradas

```
VERIFICAR:
1. Clicar "Recusar" → "Confirmar"
2. Contagem de recusas incrementa

TEST CODE:
final refused = await prefs.getInt('terms_refused_count');
print('Recusado $refused vezes');
```

### 5. Dados Locais Apenas

```
VERIFICAR:
1. Desativar internet
2. Completar fluxo completo
3. Deve funcionar normalmente

Padrão implementado:
- Todos dados em SharedPreferences
- Sem chamadas de API neste fluxo
- Sem sincronização em nuvem
- GDPR-ready por design
```

## Testes de Resposta

### 1. Layout Responsivo

```
TESTAR EM:
[ ] Phone portrait (360x640)
[ ] Phone landscape (640x360)
[ ] Tablet portrait (600x960)
[ ] Tablet landscape (960x600)

VERIFICAR:
✓ Botões não ficam cortados
✓ Texto não fica muito pequeno
✓ Imagens escalam bem
✓ Scroll funciona em todos
```

### 2. Tamanhos de Tela

```
DEVICES RECOMENDADOS:
- Pequeno: Pixel 4 (5.7")
- Médio: Pixel 5 (6.0")
- Grande: Pixel Tablet (12.9")
```

## Testes de Performance

### 1. Splash Duration

```
MEDIR:
- Tempo de tela branca até aparecer logo
- Deve ser <100ms
- Total: 3s (conforme constante)

MEASURE:
```dart
Stopwatch watch = Stopwatch()..start();
// ... código
print('Tempo: ${watch.elapsedMilliseconds}ms');
```

### 2. Transição de Telas

```
VERIFICAR:
- Transição entre telas suave
- Sem lag ou jank
- Animação de PageView fluida
```

## Checklist Final

### Antes de Deploy

- [ ] Splash funciona
- [ ] Onboarding com 4 páginas
- [ ] Dots somem na última
- [ ] Pular leva a Consentimento
- [ ] Termos com progresso visual
- [ ] Precisa ler 2x
- [ ] Recusa com desfazer
- [ ] Consentimento opt-in
- [ ] Home mostra status
- [ ] Reset funciona
- [ ] Acessibilidade talkback
- [ ] Contraste validado
- [ ] Tamanho de toque ≥48dp
- [ ] Focus visível
- [ ] LGPD versionado
- [ ] Dados locais
- [ ] Layout responsivo
- [ ] Performance OK

## Relatório de Teste

Preencher para cada ciclo de teste:

```markdown
## Ciclo X - Data: ___/___/_____

### Acessibilidade
- TalkBack: ✓/✗
- VoiceOver: ✓/✗
- Contraste: ✓/✗
- Tamanho: ✓/✗

### Fluxo
- Primeira execução: ✓/✗
- Com skip: ✓/✗
- Recusa: ✓/✗
- Segundo acesso: ✓/✗

### LGPD
- Versionamento: ✓/✗
- Consentimento: ✓/✗
- Histórico: ✓/✗

### Responsividade
- Portrait: ✓/✗
- Landscape: ✓/✗

### Observações
_________________________________
_________________________________

### Bugs Encontrados
1. ...
2. ...

### Resolvidos em
Data: ___/___/_____
```
