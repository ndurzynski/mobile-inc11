import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inc11/main.dart';
import 'package:inc11/screens/signup_screen.dart';
import 'package:inc11/screens/success_screen.dart';

void main() {
  testWidgets('Signup validates required and invalid input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupScreen()));

    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please choose a creature type'), findsOneWidget);
    expect(find.byType(SuccessScreen), findsNothing);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '   ');
    await tester.enterText(fields.at(1), 'invalid-email');
    await tester.enterText(fields.at(3), '12345');
    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    expect(find.byType(SuccessScreen), findsNothing);
  });

  testWidgets('Welcome, signup, success, and return flow works', (
    tester,
  ) async {
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter the Registry'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '  Drac  ');
    await tester.enterText(fields.at(1), ' drac@example.com ');
    await tester.enterText(fields.at(3), 'secret123');
    await tester.ensureVisible(fields.at(2));
    await tester.tap(fields.at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final creatureDropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(creatureDropdown);
    await tester.tap(creatureDropdown);
    await tester.pumpAndSettle();
    for (final creature in [
      'Ghost',
      'Bat',
      'Black Cat',
      'Pumpkin Spirit',
      'Witch',
    ]) {
      expect(find.text(creature), findsOneWidget);
    }
    await tester.tap(find.text('Ghost'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Register Creature'));
    await tester.tap(find.text('Register Creature'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final registerButton = tester.widget<ElevatedButton>(
      find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(registerButton.onPressed, isNull);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Creature registered: Ghost.'), findsOneWidget);
    expect(find.text('Welcome, Drac!'), findsOneWidget);
    expect(find.byType(SignupScreen), findsNothing);
    await tester.tap(find.text('Back to the Foyer'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the Registry'), findsOneWidget);
  });
}
