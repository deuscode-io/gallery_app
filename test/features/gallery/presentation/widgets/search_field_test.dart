import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_app/features/gallery/presentation/widgets/search_field.dart';

String _callbackValue = '';
const _query = '  query     ';
const _queryTrimmed = 'query';

void main() {
  setUp(() => _callbackValue = '');

  group(
    'GIVEN $SearchField to test callbacks',
    () {
      testWidgets(
        'WHEN entered a text '
        'AND not settled for 500 milliseconds '
        'THEN a callback value should be an empty string',
        (tester) async {
          await tester.appPumpWidget(
            onChanged: (text) => _callbackValue = text,
          );

          await tester.enterText(find.byType(TextField), _query);

          expect(_callbackValue, '');
        },
      );

      testWidgets(
        'WHEN entered a text '
        'AND settled for 500 milliseconds '
        'THEN a callback value should match the entered text',
        (tester) async {
          await tester.appPumpWidget(
            onChanged: (text) => _callbackValue = text,
          );

          await tester.enterText(find.byType(TextField), _query);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(_callbackValue, _queryTrimmed);
        },
      );
    },
  );
}

extension on WidgetTester {
  Future<void> appPumpWidget({
    required ValueChanged<String> onChanged,
  }) async {
    return pumpWidget(
      MaterialApp(
        home: Material(
          child: SearchField(
            onSearch: onChanged,
          ),
        ),
      ),
    );
  }
}
