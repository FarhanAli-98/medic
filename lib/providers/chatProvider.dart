// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/chatMessageModel.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ChatProvider with ChangeNotifier {
  bool isDoctorAccount = false;
  String peerId;
  String id;
  List<ChatMessage> messagesList = [];
  String groupChatId;
  File _imageFile;
  bool isLoading = false;
  String error = '';

  /// Flag to check if the stream is being setup for the first time
  bool _initialStreamSetup = true;

  DocumentSnapshot _lastDocument;

  StreamSubscription _messageSub;

  /// Controls the text editing widget
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  /// Controls the list.
  final ScrollController _listScrollController = ScrollController();
  ScrollController get listScrollController => _listScrollController;

  /// Initialize the chat provider with desired values to fetch data.
  void init() {
    log('Initiating chat provider init()');
    isDoctorAccount =
        LocatorService.doctorProvider().doctor?.uid != null || false;
    if (isDoctorAccount) {
      id = LocatorService.communicationProvider().doctorId;
      peerId = LocatorService.communicationProvider().userId;
    } else {
      id = LocatorService.communicationProvider().userId;
      peerId = LocatorService.communicationProvider().doctorId;
    }

    _setChatRoomId();
    _fetchMessages();
  }

  void localDispose() {
    log('Calling local dispose', name: 'Chat Provider');
    isDoctorAccount = false;
    _initialStreamSetup = true;
    peerId = null;
    id = null;
    messagesList = [];
    groupChatId = null;
    _imageFile = null;
    _textEditingController.clear();
    _messageSub?.cancel();
  }

  /// Fetch messages and starts a stream to listen to real time updates
  Future<void> _fetchMessages() async {
    isLoading = true;
    _initialStreamSetup = true;
    notifyListeners();
    try {
      final List<DocumentSnapshot> result =
          await FirestoreService.getChatMessages(groupChatId);

      if (result.isEmpty) {
        messagesList = [];
        isLoading = false;

        // No messages therefore the chat stream must start listening immediately
        _initialStreamSetup = false;

        // Start listening to stream
        _createMessageStream();

        notifyListeners();
        return;
      }

      // Set the last document to get more documents
      _lastDocument = result.last;

      final Set<ChatMessage> tempSet = {};
      // result.forEach((element) {
      //   final ChatMessage obj = ChatMessage.fromMap(element.data());
      //   tempSet.add(obj);
      // });
      for (final element in result) {
        final ChatMessage obj = ChatMessage.fromMap(element.data());
        tempSet.add(obj);
      }

      messagesList = tempSet.toList();
      isLoading = false;
      notifyListeners();

      // Now start listening to stream
      _createMessageStream();
    } catch (e) {
      isLoading = false;
      error = e.message.toString();
      notifyListeners();

      // No messages therefore the chat stream must start listening immediately
      _initialStreamSetup = false;

      // Start listening to stream
      _createMessageStream();
    }
  }

  /// Fetch more messages
  Future<void> fetchMoreMessages() async {
    try {
      final List<DocumentSnapshot> result =
          await FirestoreService.getMoreChatMessages(
              groupChatId, _lastDocument);

      if (result.isEmpty && messagesList.isEmpty) {
        messagesList = [];
        return;
      }

      // Set the last document to get more documents
      _lastDocument = result.last;

      final Set<ChatMessage> tempSet = {};
      for (final element in result) {
        final ChatMessage obj = ChatMessage.fromMap(element.data());
        tempSet.add(obj);
      }

      messagesList.addAll(tempSet);
      notifyListeners();
    } catch (e) {
      log('Could not get more messages', name: 'Chat Provider');
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    }
  }

  /// Creates a stream of messages
  void _createMessageStream() {
    _messageSub = FirestoreService.getMessagesStream(groupChatId).listen(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          log(
            'Chat message from stream ${snapshot.docs.last?.data()['content']}',
            name: 'Chat Provider',
          );
          final ChatMessage message =
              ChatMessage.fromMap(snapshot.docs.last.data());
          if (_initialStreamSetup) {
            log('Initial Stream set up changed to false. Now updates will be added');
            _initialStreamSetup = false;
          } else {
            messagesList.insert(0, message);
            notifyListeners();
          }
        }
      },
      onError: (e) {
        log('Stream error: ${e.toString()}', name: 'Chat Provider');
        error = e.toString();
      },
      cancelOnError: false,
    );
  }

  /// Creates the chat room id for the conversation
  /// `Breaking Changes` after version v0.1.2
  /// New version compares the userId and peerId with `compareTo` function
  /// instead of `hashCode`.
  void _setChatRoomId() {
    groupChatId = createConversationId(id, peerId);

    /// `LEGACY CODE`
    // if (id.hashCode <= peerId.hashCode) {
    //   groupChatId = '$id-$peerId';
    // } else {
    //   groupChatId = '$peerId-$id';
    // }
  }

  /// Show a loading indicator on the screen if value is true
  void updateLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// Gets an image from the gallery
  Future<void> getImage() async {
    final PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }

    if (_imageFile != null) {
      updateLoading(true);
      uploadFile();
    }
  }

  /// Upload file to firebase storage
  Future uploadFile() async {
    final String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final Reference reference =
    FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = reference.putFile(_imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      updateLoading(false);
      sendMessage(downloadUrl, 1);
    }, onError: (err) {
      updateLoading(false);
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    });
  }

  Future<void> sendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ChatMessage message = ChatMessage(
        content: content,
        type: type,
        idFrom: id,
        idTo: peerId,
        timestamp: timestamp,
      );
      await FirestoreService.sendMessage(groupChatId, message);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  ///**********************************************************
  //  Helper functions
  //**********************************************************

  /// Creates and returns a conversation id based on the 2 given Id.
  String createConversationId(String userId, String peerId) {
    if (userId.compareTo(peerId) > 0) {
      return '$userId-$peerId';
    } else {
      return '$peerId-$userId';
    }
  }
}
