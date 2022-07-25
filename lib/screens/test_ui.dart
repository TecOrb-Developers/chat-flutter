import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestUI extends StatelessWidget {
  const TestUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("location")
            .doc("7ASvN9mWp8bVxuVHL2ntaoG0P533")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            return Center(child: Text(data["lat"]));
          } else {
            return const Text("No Data");
          }
        },
      ),
    );
  }
}















// import 'package:flutter/material.dart';

// class TestUI extends StatefulWidget {
//   const TestUI({Key? key}) : super(key: key);

//   @override
//   State<TestUI> createState() => _TestUIState();
// }

// class _TestUIState extends State<TestUI> {
//   bool _isTapDown = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTapUp: (details) {
//                   setState(() {
//                     _isTapDown = !_isTapDown;
//                   });
//                 },
//                 onTapDown: (details) {
//                   setState(() {
//                     _isTapDown = !_isTapDown;
//                   });
//                 },
//                 child: AnimatedOpacity(
//                   duration: const Duration(milliseconds: 99),
//                   opacity: _isTapDown ? 0.4 : 1,
//                   child: Container(
//                     height: 50,
//                     width: 120,
//                     decoration: const BoxDecoration(
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
