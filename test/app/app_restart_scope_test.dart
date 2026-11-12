import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/app_restart_scope.dart';

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: Column(
      children: [
        Text('count $count'),
        TextButton(
          onPressed: () => setState(() => count++),
          child: const Text('add'),
        ),
        TextButton(
          onPressed: () => AppRestartScope.restart(context),
          child: const Text('restart'),
        ),
      ],
    ),
  );
}

void main() {
  testWidgets('restart throws away all state below the scope', (tester) async {
    await tester.pumpWidget(const AppRestartScope(child: _Counter()));
    await tester.tap(find.text('add'));
    await tester.pump();
    expect(find.text('count 1'), findsOneWidget);

    await tester.tap(find.text('restart'));
    await tester.pump();
    expect(find.text('count 0'), findsOneWidget);
  });
}
