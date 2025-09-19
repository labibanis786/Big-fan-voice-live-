import 'package:flutter/material.dart';
import '../services/agora_service.dart';
import '../config.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final rooms = List.generate(6, (i) => 'room_${i+1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Rooms')),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final id = rooms[index];
          return ListTile(
            title: Text('Room: $id'),
            trailing: ElevatedButton(
              onPressed: () {
                // Navigator to Agora room page (simple)
                Navigator.push(context, MaterialPageRoute(builder: (_) => AgoraRoomPage(channelName: id)));
              },
              child: const Text('Join'),
            ),
          );
        },
      ),
    );
  }
}

class AgoraRoomPage extends StatefulWidget {
  final String channelName;
  const AgoraRoomPage({required this.channelName, super.key});
  @override
  State<AgoraRoomPage> createState() => _AgoraRoomPageState();
}

class _AgoraRoomPageState extends State<AgoraRoomPage> {
  late final AgoraService _agora;

  @override
  void initState() {
    super.initState();
    _agora = AgoraService();
    _agora.init(AGORA_APP_ID);
    _agora.joinChannel(widget.channelName);
  }

  @override
  void dispose() {
    _agora.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Room: ${widget.channelName}')),
      body: Center(child: Text('Agora voice connected — UI placeholder')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _agora.toggleMute(),
        child: const Icon(Icons.mic),
      ),
    );
  }
}
