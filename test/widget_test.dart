import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_ui/main.dart';

void main() {
  testWidgets('shows login form content', (tester) async {
    await tester.pumpWidget(const LoginUiApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('rememberMeCheckbox')), findsOneWidget);
    expect(find.byKey(const Key('signInButton')), findsOneWidget);
  });

  testWidgets('validates empty login form', (tester) async {
    await tester.pumpWidget(const LoginUiApp());

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('submits valid credentials', (tester) async {
    await tester.pumpWidget(const LoginUiApp());

    await tester.enterText(
        find.byKey(const Key('emailField')), 'sam@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret1');
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(find.text('Welcome back, sam@example.com!'), findsOneWidget);
  });
}
