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

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_consultation/const.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/chatMessageModel.dart';
import 'package:doctor_consultation/providers/chatProvider.dart';
import 'package:doctor_consultation/screens/chat/fullPhoto.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  const Chat({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        FocusScope.of(context).unfocus();
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: ThemeGuide.borderRadius10,
              ),
              backgroundColor: Colors.white,
              title: const Text(
                AppStrings.endChatText,
                textAlign: TextAlign.center,
              ),
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: ThemeGuide.borderRadius10,
                  ),
                  color: Colors.red,
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: ThemeGuide.borderRadius10,
                  ),
                  color: Colors.blue,
                  child: const Text(
                    'No',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.chatTitle),
        ),
        body: ChangeNotifierProvider<ChatProvider>.value(
          value: LocatorService.chatProvider(),
          child: const SafeArea(
            bottom: true,
            child: ChatScreen(),
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ChatProvider _chatProvider = LocatorService.chatProvider();

  @override
  void initState() {
    super.initState();
    _chatProvider.init();
  }

  @override
  void dispose() {
    _chatProvider?.localDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Building chat screen', name: 'Chat Screen');
    return Stack(
      children: <Widget>[
        Column(
          children: const <Widget>[
            // List of messages
            Expanded(
              child: _MessageListContainer(),
            ),

            // Input content
            _BuildInputContainer(),
          ],
        ),
        const _Loading(),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<ChatProvider, bool>(
      selector: (context, d) => d.isLoading,
      builder: (context, isLoading, widget) {
        if (isLoading) {
          return widget;
        } else {
          return const SizedBox();
        }
      },
      child: Positioned(
        child: Container(
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          ),
          color: Colors.white.withAlpha(200),
        ),
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({Key key, @required this.chatMessage}) : super(key: key);
  final ChatMessage chatMessage;
  @override
  Widget build(BuildContext context) {
    if (chatMessage.idFrom == LocatorService.chatProvider().id) {
      // Right (my chatMessage)
      return _LeftMessageItem(chatMessage: chatMessage);
    } else {
      // Left (peer chatMessage)
      return _RightMessageItem(chatMessage: chatMessage);
    }
  }
}

class _LeftMessageItem extends StatelessWidget {
  const _LeftMessageItem({
    Key key,
    @required this.chatMessage,
  }) : super(key: key);

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    log('Left message item', name: 'Left message');
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (chatMessage.type == 0)
          _ChatBubble.left(chatMessage: chatMessage)
        else if (chatMessage.type == 1)
          _MessageImageItem(chatMessage: chatMessage),
      ],
    );
  }
}

class _RightMessageItem extends StatelessWidget {
  const _RightMessageItem({Key key, @required this.chatMessage})
      : super(key: key);

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    log('Right Message Item', name: 'Right Message');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (chatMessage.type == 0)
          _ChatBubble.right(chatMessage: chatMessage)
        else if (chatMessage.type == 1)
          _MessageImageItem(chatMessage: chatMessage)
      ],
    );
  }
}

class _MessageImageItem extends StatelessWidget {
  const _MessageImageItem({
    Key key,
    @required this.chatMessage,
  }) : super(key: key);

  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Material(
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              child: const SpinKitCircle(color: Colors.black),
              width: 200.0,
              height: 200.0,
              padding: const EdgeInsets.all(70.0),
              decoration: const BoxDecoration(
                color: ThemeGuide.lightGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Material(
              child: Image.asset(
                'lib/assets/images/img_not_available.jpeg',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            imageUrl: chatMessage.content,
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          // clipBehavior: Clip.antiAlias,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullPhoto(
                url: chatMessage.content,
              ),
            ),
          );
        },
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0,
        ),
      ),
      margin: const EdgeInsets.only(
        bottom: 10.0,
        right: 10.0,
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key key,
    @required this.chatMessage,
    this.color = const Color(0xFFC8E6C9),
  }) : super(key: key);

  const _ChatBubble.left({
    Key key,
    @required this.chatMessage,
    this.color = const Color(0xFFC8E6C9),
  }) : super(key: key);

  const _ChatBubble.right({
    Key key,
    @required this.chatMessage,
    this.color = const Color(0xFFBBDEFB),
  }) : super(key: key);

  final ChatMessage chatMessage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(chatMessage.timestamp);
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.subtitle1;
    if (chatMessage.content.length > 30) {
      return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: ThemeGuide.padding10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: ThemeGuide.borderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Text(
                chatMessage.content,
                style: textStyle,
              ),
            ),
            const Flexible(child: SizedBox(width: 10)),
            Text(
              DateFormat.jm().format(date).toLowerCase(),
              style: theme.textTheme.bodyText1.copyWith(fontSize: 10),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: ThemeGuide.padding10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: ThemeGuide.borderRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              chatMessage.content,
              style: textStyle,
            ),
            const SizedBox(width: 10),
            Text(
              DateFormat.jm().format(date).toLowerCase(),
              style: theme.textTheme.bodyText1.copyWith(fontSize: 10),
            ),
          ],
        ),
      );
    }
  }
}

///
/// `Description`
///
/// Creates a message list to scroll through
///
class _MessageListContainer extends StatelessWidget {
  const _MessageListContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = LocatorService.chatProvider();
    return chatProvider.groupChatId == ''
        ? const Center(
            child: SpinKitCircle(color: Colors.black),
          )
        : Selector<ChatProvider, List<ChatMessage>>(
            selector: (context, d) => d.messagesList,
            shouldRebuild: (a, b) => true,
            builder: (context, list, widget) {
              log('Building chat message list');
              return ListView.builder(
                // physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) => _MessageItem(
                  chatMessage: list[index],
                ),
                itemCount: list.length,
                reverse: true,
                controller: chatProvider.listScrollController,
              );
            },
          );
  }
}

///
/// `Description`
///
/// Builds the input container to get the text message
///
class _BuildInputContainer extends StatelessWidget {
  const _BuildInputContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider = LocatorService.chatProvider();
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: chatProvider.getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
                controller: chatProvider.textEditingController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: greyColor,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(chatProvider.textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 56.0,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: greyColor2, width: 0.5),
        ),
        color: Colors.white,
      ),
    );
  }

  Future<void> onSendMessage(String content, int type) async {
    final ChatProvider chatProvider = LocatorService.chatProvider();
    try {
      // type: 0 = text, 1 = image, 2 = sticker
      if (content.trim() != '') {
        chatProvider.sendMessage(content, type);
        chatProvider.textEditingController.clear();
        chatProvider.listScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        Fluttertoast.showToast(msg: 'Nothing to send');
      }
    } catch (e) {
      log('Error - $e', name: 'Chat Screen');
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    }
  }
}
