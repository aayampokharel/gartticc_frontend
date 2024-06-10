import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Channel {
  final WebSocketChannel channel;
  Channel()
      : channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/'));

  void add(dynamic str) {
    channel.sink.add(str);
  }

  Stream broadcastStream() => channel.stream.asBroadcastStream();

  void close() => channel.sink.close();
}
