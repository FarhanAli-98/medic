// // ignore_for_file: deprecated_member_use, always_declare_return_types

// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// import '../../constants/appStrings.dart';

// class Calling extends StatefulWidget {
//   const Calling({
//     Key key,
//     this.channelName,
//     this.isAudio,
//   }) : super(key: key);

//   /// non-modifiable channel name of the page
//   final String channelName;
//   final bool isAudio;
//   @override
//   _CallingState createState() => _CallingState();
// }

// class _CallingState extends State<Calling> {
//   // final AgoraClient client = AgoraClient(
//   //   agoraConnectionData: AgoraConnectionData(
//   //       appId: 'b6342b4edeb94e18ae31440aa0f9a620',
//   //       channelName: 'test',
//   //       tempToken:
//   //           '006b6342b4edeb94e18ae31440aa0f9a620IAB3+eulMfRwx6C4FFtBEocA++RhAlrk5SteQo+n4TvCEAx+f9gAAAAAEAANqJukbQNYYgEAAQBsA1hi'),
//   //   enabledPermission: [
//   //     Permission.camera,
//   //     Permission.microphone,
//   //   ],
//   // );

//   @override
//   void initState() {
//     super.initState();
//    // initAgora();
//   }

//   // initAgora() async {
//   //   await client.initialize();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//             // appBar: AppBar(
//             //   title: const Text('Agora UIKit'),
//             //   centerTitle: true,
//             // ),
//             body: SafeArea(
//                 top: true,
//                 bottom: true,
//                 child: WillPopScope(
//                   onWillPop: () {
//                     return showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           backgroundColor: Colors.white,
//                           title: const Text(
//                             AppStrings.endCallText,
//                             textAlign: TextAlign.center,
//                           ),
//                           titleTextStyle: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                           ),
//                           actions: <Widget>[
//                             FlatButton(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               color: Colors.red,
//                               child: const Text(
//                                 AppStrings.yesUpperCase,
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop(true);
//                               },
//                             ),
//                             FlatButton(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               color: Colors.blue,
//                               child: const Text(
//                                 AppStrings.noUpperCase,
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop(false);
//                               },
//                             )
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: SafeArea(
//                     child: Stack(
//                       children: [
//                         AgoraVideoViewer(
//                           videoRenderMode: VideoRenderMode.Fit,
//                           client: client,
//                         ),
//                         AgoraVideoButtons(
//                           client: client,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ))));
//   }
// }
