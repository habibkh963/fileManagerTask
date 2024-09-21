import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/PermissionControlle.dart';
import '../../controller/files_controller.dart';
import '../../../../core/utils/const.dart';

import '../widgets/subtitleWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FilesController myController = Get.put(FilesController());
  String searchQuery = '';
  final Permissioncontrolle permissioncontrolle =
      Get.put(Permissioncontrolle());
  var isSearching = false;

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: myController.controller,
      child: Scaffold(
        appBar: myController.appBar(context, () {
          setState(() {});
        }),
        body: FileManager(
          controller: myController.controller,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = isSearching
                ? snapshot
                    .where((element) => element.path.contains(searchQuery))
                    .toList()
                : snapshot
                    .where((element) =>
                        element.path != '/storage/emulated/0/Android')
                    .toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Visibility(
                      visible: !myController.fullScreen,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 50.h,
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    isSearching = true;
                                    searchQuery = value;
                                    if (searchQuery.isEmpty ||
                                        searchQuery == "" ||
                                        searchQuery == " ") {
                                      isSearching = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Search Files',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Recent Files",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    )),
                                InkWell(
                                  onTap: () {
                                    myController.fullScreen = true;
                                    setState(() {});
                                  },
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  GetBuilder<FilesController>(builder: (_) {
                    return Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: entities.length,
                        itemBuilder: (context, index) {
                          FileSystemEntity entity = entities[index];

                          return fileWidget(entity, context);
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
        floatingActionButton: GetBuilder<Permissioncontrolle>(builder: (_) {
          return !permissioncontrolle.gotPermission
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    await permissioncontrolle.getPermission();
                  },
                  label: const Text("get Permission"),
                )
              : SizedBox();
        }),
      ),
    );
  }

  Ink fileWidget(FileSystemEntity entity, BuildContext context) {
    return Ink(
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: FileManager.isFile(entity)
                ? FileManager.getFileExtension(entity) == 'apk'
                    ? Card(
                        color: Colors.green[600],
                        elevation: 0,
                        child: Padding(
                            padding: EdgeInsets.all(40.0.w),
                            child: Icon(
                              Icons.android,
                              color: Colors.white,
                            )),
                      )
                    : Card(
                        color: Colors.green[200],
                        elevation: 0,
                        child: Padding(
                            padding: EdgeInsets.all(40.0.w),
                            child: Icon(
                              Icons.file_copy_outlined,
                              color: Colors.white,
                            )),
                      )
                : Card(
                    color: teal2,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/3d/folder-dynamic-color.png"),
                    ),
                  ),
          ),
          Expanded(
            flex: 1,
            child: ListTile(
              trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry>[
                      PopupMenuItem(
                        value: 'button1',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.delete, color: teal2),
                            const Text("Delete"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'button2',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.drive_file_rename_outline_outlined,
                                color: Colors.black),
                            const Text("Rename"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'button3',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.drive_file_move_outline,
                                color: Colors.indigo),
                            const Text("Move"),
                          ],
                        ),
                      )
                    ];
                  },
                  onSelected: (value) async {
                    myController.menueAction(value, entity, context);
                  },
                  child: const Icon(Icons.more_vert)),
              title: Text(
                FileManager.basename(
                  entity,
                  showFileExtension: true,
                ),
                maxLines: 1,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: subtitle(
                entity,
              ),
              onTap: () async {
                if (FileManager.isDirectory(entity)) {
                  try {
                    myController.controller.openDirectory(entity);
                  } catch (e) {
                    myController.alert(context, "Enable to open this folder");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
