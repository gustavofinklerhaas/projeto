import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Settings tests placeholder',
      (WidgetTester tester) async {
    // Set up mock shared preferences
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Settings')),
      ),
    ));

    // Verify that the "Notificações" section is present
    expect(find.text('Notificações'), findsOneWidget);

    // Verify that the "Ativar lembretes" switch is present
    expect(find.text('Ativar lembretes'), findsOneWidget);

    // Verify that the "Horário do lembrete" list tile is present
    expect(find.text('Horário do lembrete'), findsOneWidget);

    // Tap the switch to enable notifications
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    // Verify that the "Horário do lembrete" list tile is enabled
    expect(
        tester.widget<ListTile>(find.ancestor(
            of: find.text('Horário do lembrete'),
            matching: find.byType(ListTile))),
        isA<ListTile>().having((p0) => p0.enabled, 'enabled', true));
  });
}
