import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:storage_info/storage_info.dart';

class FilesController extends GetxController {
  final FileManagerController controller = FileManagerController();

  double deviceAvailableSize = 0;
  double deviceTotalSize = 0;

  var documentSize = 0.0;
  var videoSize = 0.0;
  var imageSize = 0.0;
  var soundSize = 0.0;

  @override
  void onInit() {
    super.onInit();

    _getSpace().then((value) {
      update();
    });
  }

  Future<void> _getSpace() async {
    deviceAvailableSize = 10;
    deviceTotalSize = 10;
    update();
  }

  Future<void> selectStorage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => ListTile(
                              title: Text(
                                FileManager.basename(e),
                              ),
                              onTap: () {
                                controller.openDirectory(e);
                                Navigator.pop(context);
                              },
                            ))
                        .toList()),
              );
            }
            return const Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: const Text("Name"),
                  trailing: Icon(
                    Icons.sort,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);

                    update();
                  }),
              ListTile(
                  title: const Text("Size"),
                  trailing: Icon(
                    Icons.sort,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                    update();
                  }),
              ListTile(
                  title: const Text("Date"),
                  trailing: Icon(
                    Icons.sort,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                    update();
                  }),
              ListTile(
                  title: const Text("type"),
                  trailing: Icon(
                    Icons.sort,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                    update();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  createFile(BuildContext context, String path) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController fileName = TextEditingController();
        TextEditingController fileSize = TextEditingController();
        TextEditingController fileExtension = TextEditingController();
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    decoration: const InputDecoration(
                      hintText: "File Name",
                    ),
                    controller: fileName,
                  ),
                ),
                ListTile(
                  trailing: const Text("Bytes"),
                  title: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "File Size",
                    ),
                    controller: fileSize,
                  ),
                ),
                ListTile(
                  title: TextField(
                    decoration: const InputDecoration(
                      hintText: "File Extension",
                    ),
                    controller: fileExtension,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: teal,
                  ),
                  onPressed: () async {
                    Directory documentsDir =
                        await getApplicationDocumentsDirectory();

                    String folderPath = path;
                    try {
                      Directory folder = Directory(folderPath);
                      if (!await folder.exists()) {
                        await folder.create(recursive: true);
                      }
                      File file = File(
                          '$folderPath/${fileName.text}.${fileExtension.text}');
                      if (!await file.exists()) {
                        await file.create();
                        RandomAccessFile raf =
                            await file.open(mode: FileMode.write);
                        for (int i = 0; i < int.parse(fileSize.text); i++) {
                          await raf.writeByte(0x00);
                        }

                        await raf.close().then((value) {
                          Navigator.pop(context);
                        });
                      }
                    } catch (e) {
                      alert(context, "somthing went wrong");
                    }
                  },
                  child: const Text(
                    'Create File',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
    update();
  }

  createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    decoration: const InputDecoration(
                      hintText: "Folder Name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    controller: folderName,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: teal,
                  ),
                  onPressed: () async {
                    if (folderName.text.isEmpty || folderName.text == "") {
                      return;
                    }

                    try {
                      await FileManager.createFolder(
                              controller.getCurrentPath, folderName.text)
                          .then((value) {
                        Navigator.pop(context);
                        controller.setCurrentPath =
                            "${controller.getCurrentPath}/${folderName.text}";
                      });
                    } catch (e) {
                      alert(context, "Folder already exists");
                    }
                    update();
                  },
                  child: const Text(
                    'Create Folder',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> alert(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(message),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: teal,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//menue action
  late FileSystemEntity selectedFile;
  GlobalKey<FormState> formKey = GlobalKey();
  var isMoving = false;
  menueAction(value, entity, context) async {
    switch (value) {
      case 'button1':
        if (FileManager.isDirectory(entity)) {
          await entity.delete(recursive: true).then((value) {
            update();
          });
          ;
        } else {
          await entity.delete().then((value) {
            update();
          });
          ;
        }

        break;
      case 'button2':
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController renameController = TextEditingController();
            return AlertDialog(
              title: Text(
                "Rename ${FileManager.basename(entity)}",
                style: TextStyle(fontSize: 18.sp, color: Colors.teal),
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  validator: (value) {
                    if (value!.length < 2) {
                      return 'too short Name';
                    }
                    if (value.contains('@') ||
                        value.contains('#') ||
                        value.contains('\$') ||
                        value.contains('*')) {
                      return 'un valid charcter used @,#,*';
                    }
                  },
                  controller: renameController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      fillColor: Colors.teal.withOpacity(0.2),
                      filled: true),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await entity
                          .rename(
                        "${controller.getCurrentPath}/${renameController.text.trim()}",
                      )
                          .then((value) {
                        Navigator.pop(context);
                        update();
                      });
                    } else {}
                  },
                  child: const Text("Rename"),
                ),
              ],
            );
          },
        );

        break;
      case 'button3':
        selectedFile = entity;

        isMoving = true;
        update();
        break;
    }
  }

  var fullScreen = false;
  AppBar appBar(BuildContext context, Function func) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: [
        Visibility(
            visible: isMoving,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  selectedFile.rename(
                      "${controller.getCurrentPath}/${FileManager.basename(selectedFile)}");

                  isMoving = false;
                  update();
                },
                child: Row(
                  children: const [
                    Text("Move here ",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Icon(Icons.paste),
                  ],
                ),
              ),
            )),
        Visibility(
          visible: !isMoving,
          child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'button1',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.file_present,
                          color: teal,
                        ),
                        const Text("New File     "),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'button2',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.folder_open, color: teal2),
                        const Text("New Folder"),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 'button1':
                    createFile(context, controller.getCurrentPath);

                    break;
                  case 'button2':
                    createFolder(context);

                    break;
                }
              },
              child: const Icon(Icons.add)),
        ),
        SizedBox(
          width: 10.w,
        ),
        Visibility(
          visible: !isMoving,
          child: IconButton(
            onPressed: () => sort(context),
            icon: const Icon(Icons.sort_rounded),
          ),
        ),
      ],
      title: const Text("File Manager",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          await controller.goToParentDirectory().then((value) {
            if (controller.getCurrentPath == "/storage/emulated/0") {
              fullScreen = false;

              func();
            }
          });
        },
      ),
    );
  }
}
