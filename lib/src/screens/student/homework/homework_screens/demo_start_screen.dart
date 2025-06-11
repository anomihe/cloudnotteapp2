import 'package:cloudnottapp2/src/data/models/homework_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DemoStartScreen extends StatelessWidget {
  const DemoStartScreen({
    super.key,
  });

  static const String routeName = '/homework_demo_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // context.push(
                //   '/homework_entry_screen',
                //   extra: HomeworkModel(
                //     subject: '',
                //     // status: 'Open',
                //     task: '',
                //     date: DateTime.now(), questions: [],
                //     duration: Duration(minutes: 30), groupName: '', mark: 10,
                //     // id: '123',
                //   ),
                // );
              },
              child: const Text('Student view'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push(
                  '/teacher_entry_screen',
                );
              },
              child: const Text('Teacher view'),
            ),
          ],
        ),
      ),
    );
  }
}
