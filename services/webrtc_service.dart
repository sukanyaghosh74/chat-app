import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  RTCPeerConnection? peerConnection;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> createPeerConnection() async {
    peerConnection = await createPeerConnection({
      'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
    });

    peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        database.child('calls/ice_candidate').set(candidate.toMap());
      }
    };

    peerConnection!.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
    };

    var stream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    localRenderer.srcObject = stream;
    peerConnection!.addStream(stream);
  }

  Future<void> makeCall() async {
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    database.child('calls/offer').set({'sdp': offer.sdp, 'type': offer.type});
  }

  Future<void> answerCall() async {
    database.child('calls/offer').onValue.listen((event) async {
      if (event.snapshot.value != null) {
        var offer = event.snapshot.value as Map;
        await peerConnection!.setRemoteDescription(RTCSessionDescription(offer['sdp'], offer['type']));

        RTCSessionDescription answer = await peerConnection!.createAnswer();
        await peerConnection!.setLocalDescription(answer);
        database.child('calls/answer').set({'sdp': answer.sdp, 'type': answer.type});
      }
    });

    database.child('calls/ice_candidate').onValue.listen((event) {
      if (event.snapshot.value != null) {
        var candidate = event.snapshot.value as Map;
        peerConnection!.addCandidate(RTCIceCandidate(candidate['candidate'], candidate['sdpMid'], candidate['sdpMLineIndex']));
      }
    });
  }
}
