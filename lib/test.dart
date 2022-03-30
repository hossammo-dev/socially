// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'constants/constant_colors.dart';

// class TestScreen extends StatelessWidget {
//   final List<Color> _colors = [
//     Colors.red,
//     Colors.amber,
//     Colors.orange,
//     Colors.green,
//     Colors.blue,
//     Colors.blueGrey,
//     Colors.white,
//     Colors.indigo,
//   ];

//   List<String> _images = [
//     'https://img.freepik.com/free-photo/confused-cute-silly-redhead-girl-dont-know-what-happened-cant-understand-why-so-many-followers-holding-smartphone-shrugging-spread-hands-dismay-grimacing-concerned-copy-space_176420-50911.jpg?t=st=1648458399~exp=1648458999~hmac=60a664805524f960897bf0dda2e8c0a90c06cff026eb948a2b82840cd5c3b1a8&w=1060',
//     'https://img.freepik.com/free-photo/it-s-easier-be-follower-need-take-photo-with-food-caucasian-woman-s-yellow-background-beautiful-female-red-hair-model-concept-human-emotions-facial-expression-sales-ad_155003-34150.jpg?t=st=1648458399~exp=1648458999~hmac=cf435d286b5916c94b0af1cf9214a6e92bb0de34cd032755b73bb4b8273715e9&w=360',
//     'https://img.freepik.com/free-photo/it-s-easier-be-follower-need-take-photo-with-food-caucasian-woman-s-yellow-background-beautiful-female-red-hair-model-concept-human-emotions-facial-expression-sales-ad_155003-30304.jpg?w=1060',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: GridView.custom(
//           gridDelegate: SliverQuiltedGridDelegate(
//             crossAxisCount: 4,
//             mainAxisSpacing: 4,
//             crossAxisSpacing: 4,
//             repeatPattern: QuiltedGridRepeatPattern.inverted,
//             pattern: [
//               QuiltedGridTile(2, 2),
//               QuiltedGridTile(1, 1),
//               QuiltedGridTile(1, 1),
//               QuiltedGridTile(1, 2),
//             ],
//           ),
//           childrenDelegate: SliverChildBuilderDelegate(
//             (context, index) => Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: ConstantColors.greyColor,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Center(
//                 child: Text(index.toString()),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// /*

//   Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: ConstantColors.greyColor,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Center(
//                 child: Text(index.toString()),
//               ),
//             ),

// */


// /*

//   GridView.custom(
//         gridDelegate: SliverWovenGridDelegate.count(
//           crossAxisCount: 3,
//           mainAxisSpacing: 4,
//           crossAxisSpacing: 4,
//           pattern: [
//             WovenGridTile(1),
//             WovenGridTile(
//               5 / 7,
//               // 4 / 6,
//               // crossAxisRatio: 0.9
//               crossAxisRatio: 1,
//               alignment: AlignmentDirectional.centerEnd,
//             ),
//           ],
//         ),
//         childrenDelegate: SliverChildBuilderDelegate(
//           (context, index) => Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: ConstantColors.greyColor,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Center(
//               child: Text(index.toString()),
//             ),
//           ),
//         ),
//       )),

// */