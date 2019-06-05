library stomp_client;

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A Calculator.
class StompClient {
  IOWebSocketChannel channel;

  StompClient({@required urlBackend}) {
    channel = IOWebSocketChannel.connect(urlBackend);
    channel.stream.listen((message) {
      // handling of the incoming messages
      print(message);
    }, onError: (error, StackTrace stackTrace) {
      // error handling
      print(error);
    }, onDone: () {
      // communication has been closed
      print("Closed");
    });
  }

  void connectWithToken(String token) {
    channel.sink.add("CONNECT\n" +
        "Authorization:Bearer " + token + "\n" +
        "accept-version:1.1,1.0\n" +
        "heart-beat:60000,0\n" +
        "\n" +
        "\x00");
  }


}
