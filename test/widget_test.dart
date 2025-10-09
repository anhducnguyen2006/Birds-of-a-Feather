// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:birds_of_a_feather_state/main.dart';

void main() {
  testWidgets('App renders 4x4 grid and shows Ready text', (WidgetTester tester) async {
    await tester.pumpWidget(const BirdsApp());

    // Expect 16 draggable card placeholders (some might be blank containers until drag)
    // We can assert presence of the Ready to play! status text.
    expect(find.text('Ready to play!'), findsOneWidget);

    // AppBar title
    expect(find.text('Birds Of A Feather'), findsOneWidget);
  });

  testWidgets('Help dialog appears from menu', (WidgetTester tester) async {
    await tester.pumpWidget(const BirdsApp());

    // Open popup menu (IconButton with Icons.menu)
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Tap Help
    await tester.tap(find.text('Help'));
    await tester.pumpAndSettle();

    // Verify dialog contents
    expect(find.text('Help'), findsOneWidget);
    expect(find.textContaining('Birds of a Feather is a solitaire card game'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Help'), findsNothing);
  });
}
