import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  late WebSocketChannel _channel;
  late StreamController<String> _messageController;

  Stream<String> get messages => _messageController.stream;

  WebSocketService() {
    _messageController = StreamController<String>.broadcast();
  }

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse("wss://echo.websocket.org/.sse"),
    );

    _channel.stream.listen((message) {
      _messageController.add(message);
    }, onDone: () {
      print('WebSocket connection closed');
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  void sendMessage(String message) {
    _channel.sink.add(message);
  }

  void disconnect() {
    _channel.sink.close(status.goingAway);
  }

  void dispose() {
    _messageController.close();
  }
}
