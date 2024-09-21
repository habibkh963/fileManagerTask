import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:filmanager/features/fileManager/controller/PermissionControlle.dart';
import 'package:filmanager/features/fileManager/controller/files_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:filmanager/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void main() {
  FilesController controller = Get.put(FilesController());
  testWidgets('sort testing', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          var act = controller.sort(context);
          expect(act, Dialog);

          // The builder function must return a widget.
          return Placeholder();
        },
      ),
    );
    await tester.pump();
  });

  test('check permissons', () {
    Permissioncontrolle permissioncontrolle = Get.put(Permissioncontrolle());
    permissioncontrolle.getPermission();
    expect(permissioncontrolle.gotPermission, false);
  });
  testWidgets('fiels', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final FilesController myController = Get.put(FilesController());
    List entities = [];
    await tester.pumpWidget(MyApp());
    // await tester.pumpWidget(FileManager(
    //     controller: myController.controller,
    //     builder: (context, snapshot) {
    //       print('object');
    //       entities = snapshot
    //           .where((element) => element.path != '/storage/emulated/0/Android')
    //           .toList();
    //       return snapshot.isEmpty
    //           ? SizedBox()
    //           : ListView(
    //               children: [],
    //             );
    //     }));

    // Verify that our counter starts at 0.
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);

    await tester.pump();

    // Verify that our counter has incremented.
  });
}
