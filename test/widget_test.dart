import 'package:flutter_test/flutter_test.dart';

import 'package:crud_sqlite/main.dart';

void main() {
  testWidgets('App builds and shows marca list app bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Marcas de motos/autos'), findsOneWidget);
  });
}
