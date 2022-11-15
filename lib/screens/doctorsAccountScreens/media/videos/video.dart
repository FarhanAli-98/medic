
     
// import 'dart:io';
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';


// class UploadAkhadavideo extends StatefulWidget {
//   @override
//   _UploadAkhadaState createState() => _UploadAkhadaState();
// }

// class _UploadAkhadaState extends State<UploadAkhadavideo>
//     with TickerProviderStateMixin {
//   TabController tabController;
//   int selectedIndex = 0;
//   String _videoLink;
//   File _video;

//   final AuthService _auth = AuthService();
//   @override
//   void initState() {
//     super.initState();
//     tabController =
//         new TabController(vsync: this, initialIndex: selectedIndex, length: 2);
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     User user = Provider.of<User>(context);
//     final _uploadKey = GlobalKey<FormState>();

//     String details;
//     String title;
//     String error_upload;

//     return  MaterialApp(
//             home: Scaffold(
//               drawer: Drawer(
//                 child: Container(
//                   color: Colors.white,
//                   child: ListView(
//                     padding: EdgeInsets.only(
//                       top: 0,
//                     ),
//                     physics: NeverScrollableScrollPhysics(),
//                     children: <Widget>[
//                       UserAccountsDrawerHeader(
//                         accountName: Text(userData.username),
//                         accountEmail: Text(userData.email),
//                         currentAccountPicture: userData.imageLink != null
//                             ? CircleAvatar(
//                                 backgroundColor: Colors.transparent,
//                                 child: ClipOval(
//                                   child: Image.network(userData.imageLink),
//                                 ),
//                                 radius: 100,
//                               )
//                             : CircleAvatar(
//                                 child: Icon(
//                                   Icons.person,
//                                   size: 50,
//                                 ),
//                                 radius: 100,
//                               ),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Color(0XFF292C36), Color(0xFF696D77)],
//                           ),
//                         ),
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.accessibility),
//                         title: Text('Home'),
//                         onTap: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => HomePage()),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.upload_rounded),
//                         title: Text('Your Uploads'),
//                         onTap: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Uploads()),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.account_circle_rounded),
//                         title: Text('profile'),
//                         onTap: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Profile()),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.account_balance_rounded),
//                         title: Text('About'),
//                         onTap: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => About()),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.add),
//                         title: Text('Upload'),
//                         onTap: () async {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => UploadAkhadavideo()),
//                           );
//                         },
//                       ),
//                       ListTile(
//                         leading: Icon(Icons.airline_seat_flat_angled_outlined),
//                         title: Text('Signout'),
//                         onTap: () async {
//                           dynamic result = await _auth.signOut();

//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => SignIn()),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               appBar: AppBar(
//                 iconTheme: IconThemeData(
//                   color: Colors.pinkAccent,
//                 ),
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 // centerTitle: true,
//               ),
//               body: Center(
//                 child: Container(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         SingleChildScrollView(
//                           child: Form(
//                             key: _uploadKey,
//                             child: Column(
//                               children: [
//                                 TextFormField(
//                                   maxLines: 2,
//                                   minLines: 1,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter Title',
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors.black,
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                   ),
//                                   validator: (val) =>
//                                       val.isEmpty ? 'Enter Title' : null,
//                                   onChanged: (val) {
//                                     title = val;
//                                   },
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 TextFormField(
//                                   maxLines: 10,
//                                   minLines: 3,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter details',
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors.black,
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                   ),
//                                   validator: (val) => val.isEmpty
//                                       ? 'Enter Details of video'
//                                       : null,
//                                   onChanged: (val) {
//                                     details = val;
//                                   },
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 _videoLink != null
//                                     ? Container(
//                                         child: Image.network(_videoLink),
//                                       )
//                                     : Container(
//                                         child: Icon(
//                                           Icons.video_collection_outlined,
//                                           size: 100,
//                                         ),
//                                       ),
//                                 FlatButton(
//                                   child: RichText(
//                                     text: TextSpan(
//                                       children: [
//                                         TextSpan(
//                                           text: "Click ",
//                                         ),
//                                         WidgetSpan(
//                                           child: Icon(Icons.add, size: 15),
//                                         ),
//                                         TextSpan(
//                                           text: " to add",
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     _video = await ImagePicker.pickVideo(
//                                         source: ImageSource.gallery);

//                                     FirebaseStorage fs =
//                                         FirebaseStorage.instance;

                                  //  StorageReference rootReference = fs.ref();

//                                     StorageReference videoFolderRef =
//                                         rootReference
//                                             .child("videos")
//                                             .child(userData.email);

//                                     videoFolderRef
//                                         .putFile(
//                                           _video,
//                                           StorageMetadata(
//                                               contentType: 'video/mp4'),
//                                         )
//                                         .onComplete
//                                         .then((storageTask) async {
//                                       String link = await storageTask.ref
//                                           .getDownloadURL();

//                                       print("uploaded");
//                                       setState(() {
//                                         _videoLink = link;
//                                       });
//                                       print('Link : ' + _videoLink);
//                                       await DatabaseService(uid: user.uid)
//                                           .updateAkhadaData(
//                                               title, details, _videoLink);
//                                       await DatabaseHome().updateAkhadaDataHome(
//                                           title, details, _videoLink);
//                                     });
//                                   },
                                 
                                 
                                  
//                                   color: Colors.pinkAccent,
//                                   textColor: Colors.white,
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 new Container(
//                                   width: double.infinity,
//                                   height: 55,
//                                   padding: const EdgeInsets.only(top: 15.0),
//                                   child: new RaisedButton(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(18.0),
//                                     ),
//                                     color: Colors.pinkAccent,
//                                     child: const Text(
//                                       'Upload',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     onPressed: () async {
//                                       print('New : ' + _videoLink);
//                                       await DatabaseService(uid: user.uid)
//                                           .updateAkhadaData(
//                                               title, details, _videoLink);
//                                       await DatabaseHome().updateAkhadaDataHome(
//                                           title, details, _videoLink);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
