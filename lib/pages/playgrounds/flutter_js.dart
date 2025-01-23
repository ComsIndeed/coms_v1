// import 'package:flutter/material.dart';
// import 'package:flutter_js/flutter_js.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class FlutterJs extends StatefulWidget {
//   const FlutterJs({
//     super.key,
//   });

//   @override
//   State<FlutterJs> createState() => _FlutterJsState();
// }

// class _FlutterJsState extends State<FlutterJs> {
//   String result = "No result";
//   late JavascriptRuntime javascriptRuntime;
//   final textEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     javascriptRuntime = getJavascriptRuntime();
//   }

//   void showResult() async {
//     try {
//       final evaluatedResult =
//           javascriptRuntime.evaluate(textEditingController.text);
//       setState(() {
//         result = evaluatedResult.stringResult;
//       });
//     } catch (e) {
//       setState(() {
//         result = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(border: Border.all(color: Colors.white24)),
//       child: Column(
//         children: [
//           TextField(
//             controller: textEditingController,
//             decoration: InputDecoration(
//                 border: const OutlineInputBorder(),
//                 hintText: "Write Javascript code here",
//                 suffix: IconButton(
//                     onPressed: showResult, icon: const Icon(Icons.send))),
//           ),
//           SelectableText(result),
//         ],
//       ),
//     );
//   }
// }
