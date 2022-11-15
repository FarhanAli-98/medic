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

// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakelock/wakelock.dart';

class Call extends StatefulWidget {
  /// Creates a call page with given channel name.
  const Call({
    Key key,
    this.channelName,
    this.isAudio,
  }) : super(key: key);

  /// non-modifiable channel name of the page
  final String channelName;
  final bool isAudio;

  @override
  CallState createState() => CallState();
}

class CallState extends State<Call> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool showToolBar = true;

  RtcEngine engine;

  int remoteUid;

  @override
  void initState() {
    super.initState();
    // Enable the screen to be on while the call is being made.
    Wakelock.enable();
    initialize();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    engine?.leaveChannel();
    engine?.destroy();

    // Disable the wake lock
    Wakelock.disable();

    super.dispose();
  }

  Future<void> initialize() async {
    if (Config.AGORA_APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'AGORA_APP_ID missing, please provide your AGORA_APP_ID in lib -> constants -> config.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await engine.enableWebSdkInteroperability(true);
    await engine.setParameters(
        '''{\'che.video.lowBitRateStreamParameter\':{\'width\':320,\'height\':180,\'frameRate\':15,\'bitRate\':140}}''');
    await engine.joinChannel(
        '007eJxTYPDQ2d4047Dt1xPvEzL6p4d8SmwqdIh7nPBq+oXI2+89p4oqMBiYpBpZmBkZGadYmpuYpJhbmhsnp6akplmmmCVaphlafMwrTG4IZGRYdyaRgREKQXwWhpLU4hIGBgAALyIp',
        'test',
        null,
        0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    engine = await RtcEngine.create(Config.AGORA_APP_ID);

    if (!widget.isAudio) {
      await engine.enableVideo();
    }
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    engine.setEventHandler(RtcEngineEventHandler(
      error: (dynamic code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (
        String channel,
        int uid,
        int elapsed,
      ) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      userJoined: (int uid, int elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
          remoteUid = uid;
        });
      },
      userOffline: (int uid, UserOfflineReason reason) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
          remoteUid = null;
        });
      },
      firstRemoteVideoFrame: (
        int uid,
        int width,
        int height,
        int elapsed,
      ) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
    ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    // final List<AgoraRenderWidget> list = [
    //   AgoraRenderWidget(0, local: true, preview: true),
    // ];
    // for (final int uid in _users) {
    //   list.add(AgoraRenderWidget(uid));
    // }
    // return list;
    return const [];
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  // ignore: unused_element
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          if (widget.isAudio)
            const SizedBox()
          else
            RawMaterialButton(
              onPressed: _onSwitchCamera,
              child: const Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
        ],
      ),
    );
  }

  // show or hide the toolbar from the view
  void toggleToolBar() {
    setState(() {
      showToolBar = !showToolBar;
    });
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: WillPopScope(
        onWillPop: () {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.white,
                title: const Text(
                  AppStrings.endCallText,
                  textAlign: TextAlign.center,
                ),
                titleTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                actions: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.red,
                    child: const Text(
                      AppStrings.yesUpperCase,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.blue,
                    child: const Text(
                      AppStrings.noUpperCase,
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
          backgroundColor: Colors.black,
          body: widget.isAudio
              ? Container(
                  color: Colors.black,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: SvgPicture.asset(
                            'lib/assets/svg/contact.svg',
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      _toolbar(),
                    ],
                  ),
                )
              : Center(
                  child: Stack(
                    children: <Widget>[
                      _viewRows(),
                      if (remoteUid != null)
                        rtc_remote_view.SurfaceView(
                          uid: remoteUid,
                        ),
                      if (remoteUid == null)
                        rtc_local_view.SurfaceView()
                      //  null
                      else
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: ThemeGuide.padding10,
                            width: 140,
                            height: 210,
                            child: rtc_local_view.SurfaceView(),
                          ),
                        ),
                      // _panel(),
                      if (showToolBar) _toolbar(),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.4,
                          child: InkWell(
                            onTap: () {
                              toggleToolBar();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: ThemeGuide.borderRadius,
                              ),
                              child: const Text(AppStrings.hide),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
