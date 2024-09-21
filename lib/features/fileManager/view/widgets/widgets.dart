import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/utils/const.dart';

// Widget storagePercentWidget(int totalStorage, int usedStorage) => Container(
//       height: 13.h,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26),
//         border: Border.all(color: Colors.grey, width: 0.5),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("${usedStorage} GB / $totalStorage GB",
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.bold,
//                   )),
//               Text("Used Storage",
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400,
//                   )),
//             ],
//           ),
//           CircularPercentIndicator(
//             animateFromLastPercent: true,
//             animation: true,
//             animationDuration: 1200,
//             radius: 31.0,
//             lineWidth: 5.0,
//             percent: usedStorage / totalStorage,
//             progressColor: orange,
//             backgroundColor: orage2,
//           )
//         ],
//       ),
//     );

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../utils/const.dart';

// Widget fileTypeWidget(String type, String size, String iconPath, Color color) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(26),
//       child: Stack(
//         children: [
//           Container(
//             height: 40.h,
//             width: 80.w,
//             decoration: BoxDecoration(
//               color: color == orange ? orange.withOpacity(0.8) : color,
//               borderRadius: BorderRadius.circular(26),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(type,
//                       style: TextStyle(
//                         color: color == yellow ? Colors.black : Colors.white,
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600,
//                       )),
//                   Text(size,
//                       style: TextStyle(
//                         color: color == orange
//                             ? Colors.black.withOpacity(0.5)
//                             : Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       )),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             right: -30,
//             bottom: -50,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(iconPath,
//                   height: 20.h, width: 30.w, fit: BoxFit.contain),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }



//UI
    // SizedBox(
                          //   height: 100.h,
                          //   child: ListView(
                          //     scrollDirection: Axis.horizontal,
                          //     children: [
                          //       fileTypeWidget(
                          //           "Document",
                          //           "${myController.documentSize.toStringAsFixed(2)} MB",
                          //           "assets/3d/folder-dynamic-color.png",
                          //           orange),
                          //       fileTypeWidget(
                          //           "Videos",
                          //           "${myController.videoSize.toStringAsFixed(2)} MB",
                          //           "assets/3d/video-camera-iso-color.png",
                          //           yellow),
                          //       fileTypeWidget(
                          //           "Images",
                          //           "${myController.imageSize.toStringAsFixed(2)} MB",
                          //           "assets/3d/Image_perspective_matte.png",
                          //           black),
                          //       fileTypeWidget(
                          //           "Music",
                          //           "${myController.soundSize.toStringAsFixed(2)} MB",
                          //           "assets/3d/Music_perspective_matte.png",
                          //           orange),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 20, horizontal: 8),
                          //   child: storagePercentWidget(
                          //       myController.deviceTotalSize.toInt(),
                          //       myController.deviceAvailableSize.toInt()),
                          // ),

                            //  Visibility(
        //   visible: !isMoving,
        //   child: IconButton(
        //     onPressed: () => myController.sort(context),
        //     icon: const Icon(Icons.sort_rounded),
        //   ),
        // ),








  //         calculateSize(List<FileSystemEntity> entities) {
  //   documentSize = 0;
  //   videoSize = 0;
  //   imageSize = 0;
  //   soundSize = 0;
  //   for (var i = 0; i < entities.length; i++) {
  //     if (entities[i].path.contains(".pdf") ||
  //         entities[i].path.contains(".doc") ||
  //         entities[i].path.contains(".txt") ||
  //         entities[i].path.contains(".ppt") ||
  //         entities[i].path.contains(".docx") ||
  //         entities[i].path.contains(".pptx") ||
  //         entities[i].path.contains(".xlsx") ||
  //         entities[i].path.contains(".xls")) {
  //       documentSize += entities[i].statSync().size / 1000000;
  //     }
  //     if (entities[i].path.contains(".mp4") ||
  //         entities[i].path.contains(".mkv") ||
  //         entities[i].path.contains(".avi") ||
  //         entities[i].path.contains(".flv") ||
  //         entities[i].path.contains(".wmv") ||
  //         entities[i].path.contains(".mov") ||
  //         entities[i].path.contains(".3gp") ||
  //         entities[i].path.contains(".webm")) {
  //       videoSize += entities[i].statSync().size / 1000000;
  //     }
  //     if (entities[i].path.contains(".jpg") ||
  //         entities[i].path.contains(".jpeg") ||
  //         entities[i].path.contains(".png") ||
  //         entities[i].path.contains(".gif") ||
  //         entities[i].path.contains(".bmp") ||
  //         entities[i].path.contains(".webp")) {
  //       imageSize += (entities[i].statSync().size / 1000000);
  //     }
  //     if (entities[i].path.contains(".mp3") ||
  //         entities[i].path.contains(".wav") ||
  //         entities[i].path.contains(".aac") ||
  //         entities[i].path.contains(".ogg") ||
  //         entities[i].path.contains(".wma") ||
  //         entities[i].path.contains(".flac") ||
  //         entities[i].path.contains(".m4a")) {
  //       soundSize += entities[i].statSync().size / 1000000;
  //     }
  //   }

  //   update();
  // }
