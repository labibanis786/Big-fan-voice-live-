import 'package:agora_uikit/agora_uikit.dart';

class AgoraService {
  late AgoraClient client;
  bool joined = false;

  void init(String appId) {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        // token: '', // add temp token if you use one
      ),
    );
  }

  Future<void> joinChannel(String channelName) async {
    try {
      await client.initialize();
      await client.join(channelName);
      joined = true;
    } catch (e) {
      rethrow;
    }
  }

  void leaveChannel() {
    try {
      client.engine.leaveChannel();
    } catch (e) {
      // ignore
    }
  }

  void toggleMute() {
    client.sessionController.localUser?.toggleMute();
  }
}
