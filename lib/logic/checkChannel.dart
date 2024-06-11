import 'package:web_socket_channel/web_socket_channel.dart';

class CheckChannel {
  final checkChannel;

  CheckChannel()
      : checkChannel =
            WebSocketChannel.connect(Uri.parse('ws://localhost:8080/check'));

  dynamic broadcastStream() {
    return checkChannel.stream.asBroadcastStream();
  }

  void close() {
    checkChannel.sink.close();
  }

  void add(String str) {
    checkChannel.sink.add(str);
  }

  void drain() {
    checkChannel.stream.drain();
  }
}
