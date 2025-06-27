import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:atomic_flutter/atomic_flutter.dart';

void main() {
  group('AtomicColors', () {
    test('should have correct primary color', () {
      expect(AtomicColors.primary, const Color(0xFF8B5CF6));
    });

    test('should generate correct opacity values', () {
      final colorWithAlpha = AtomicColors.withAlpha(AtomicColors.primary, 0.5);
      expect((colorWithAlpha.a * 255.0).round() & 0xff, 128);
    });
  });

  group('AtomicSpacing', () {
    test('should have correct spacing values', () {
      expect(AtomicSpacing.xs, 8.0);
      expect(AtomicSpacing.sm, 12.0);
      expect(AtomicSpacing.md, 16.0);
      expect(AtomicSpacing.lg, 24.0);
    });
  });

  group('AtomicButton', () {
    testWidgets('should render with correct label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AtomicButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should show loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AtomicButton(
              label: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('AtomicCard', () {
    testWidgets('should render child content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AtomicCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });
  });

  group('AtomicTextField', () {
    testWidgets('should show label when provided', (WidgetTester tester) async {
      final controller = TextEditingController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AtomicTextField(
              controller: controller,
              label: 'Test Label',
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });
  });
}
