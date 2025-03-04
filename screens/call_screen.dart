import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/webrtc_service.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final WebRTCService webrtcService = WebRTCService();

  @override
  void initState() {
    super.initState();
    webrtcService.initRenderers();
    webrtcService.createPeerConnection();
  }

  @override
  void dispose() {
    webrtcService.localRenderer.dispose();
    webrtcService.remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Call")),
      body: Column(
        children: [
          Expanded(child: RTCVideoView(webrtcService.localRenderer, mirror: true)),
          Expanded(child: RTCVideoView(webrtcService.remoteRenderer)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: webrtcService.makeCall, child: Text("Call")),
              SizedBox(width: 10),
              ElevatedButton(onPressed: webrtcService.answerCall, child: Text("Answer")),
            ],
          ),
        ],
      ),
    );
  }
}
