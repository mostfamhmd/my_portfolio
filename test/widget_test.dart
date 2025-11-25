import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_portfolio/main.dart';
import 'package:my_portfolio/services/storage_service.dart';
import 'package:my_portfolio/providers/portfolio_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // TODO: Implement proper testing with Mock StorageService
    // final storageService = StorageService();
    // await tester.pumpWidget(
    //   ChangeNotifierProvider(
    //     create: (_) => PortfolioProvider(storageService),
    //     child: const MyPortfolioApp(),
    //   ),
    // );
    // expect(find.byType(MaterialApp), findsOneWidget);
  });
}
