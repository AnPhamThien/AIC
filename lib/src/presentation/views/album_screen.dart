// import 'package:flutter/material.dart';
// import 'package:imagecaptioning/src/presentation/views/post_detail_screen.dart';
// import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

// class AlbumScreen extends StatefulWidget {
//   const AlbumScreen({Key? key, }) : super(key: key);

 
//   @override
//   _AlbumScreenState createState() => _AlbumScreenState();
// }

// class _AlbumScreenState extends State<AlbumScreen> {
//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: getAppBar(album),
//       body: getBody(album),
//     );
//   }

//   SafeArea getBody(Album album) {
//     return SafeArea(
//       child: GridView.builder(
//         padding: const EdgeInsets.all(15),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             childAspectRatio: 1,
//             crossAxisCount: 2,
//             crossAxisSpacing: 25,
//             mainAxisSpacing: 20),
//         itemCount: album.albumImages.length,
//         itemBuilder: (_, index) {
//           final String albumImage = album.albumImages[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const PostDetailScreen()),
//               );
//             },
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: Container(
//                 decoration: album.albumImages.isNotEmpty
//                     ? BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         image: DecorationImage(
//                             image: AssetImage(albumImage), fit: BoxFit.cover),
//                       )
//                     : BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   AppBar getAppBar(Album album) {
//     return AppBar(
//       elevation: 0,
//       leadingWidth: 30,
//       title: AppBarTitle(title: album.albumName),
//       actions: [
//         IconButton(
//           onPressed: () {
//             getSheet(context, album);
//           },
//           icon: const Icon(
//             Icons.more_vert_rounded,
//             color: Colors.black87,
//             size: 30,
//           ),
//         )
//       ],
//     );
//   }

//   Future<dynamic> getSheet(BuildContext context, Album album) {
//     return showModalBottomSheet(
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
//       enableDrag: true,
//       context: context,
//       builder: (context) {
//         return Wrap(
//           direction: Axis.vertical,
//           children: [
//             const SizedBox(height: 10),
//             const SheetLine(),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Text(
//                 album.albumName, //TODO nhét contest name vào đây
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87),
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: const Divider(
//                 color: Colors.grey,
//                 height: 25,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 18,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "Images: " +
//                           album.albumImages.length.toString() +
//                           "\n\n",
//                     ),
//                     const TextSpan(
//                       text: "Created on: 21/09/2000",
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: const Divider(
//                 color: Colors.grey,
//                 height: 25,
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: ListTile(
//                 leading: const Icon(
//                   Icons.delete_rounded,
//                   color: Colors.redAccent,
//                   size: 35,
//                 ),
//                 title: const Text(
//                   "Delete",
//                   style: TextStyle(fontSize: 19, color: Colors.redAccent),
//                 ),
//                 onTap: () {
//                   //TODO hàm delete album
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
