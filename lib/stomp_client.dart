library stomp_client;

import 'dart:collection';

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

/// A Stomp Client.
class StompClient {
  IOWebSocketChannel channel;
  Stream<dynamic> stream;
  HashMap<String, int> _topics;
  int _topicsCount;

  StompClient({@required urlBackend}) {
    channel = IOWebSocketChannel.connect(urlBackend);
    stream = channel.stream;
    _topics = HashMap();
    _topicsCount = 0;
  }

  void connectWithToken({@required String token}) {
    channel.sink.add("CONNECT\n" +
        "Authorization:Bearer " +
        token +
        "\n" +
        "accept-version:1.1,1.0\n" +
        "heart-beat:60000,0\n" +
        "\n" +
        "\x00");
  }

  void disconnect() {
    channel.sink.add("DISCONNECT\n" + 
        "\n" + 
        "\x00");
    channel.sink.close();
  }

  void subscribe({@required String topic}) {
    if (!_topics.containsKey(topic)){
      _topics[topic] = _topicsCount;
      channel.sink.add("SUBSCRIBE\n" +
          "id:" + _topicsCount.toString() + "\n" +
          "destination:" + topic + "\n" +
          "ack:auto\n" +
          "\n" +
          "\x00");
      _topicsCount++;
    }
  }

  void unsubscribe({@required String topic}) {
    if (_topics.containsKey(topic)){
      channel.sink.add("UNSUBSCRIBE\n" +
          "id:" + _topics[topic].toString() + "\n" +
          "\n" +
          "\x00");
      _topics.remove(topic);
    }
  }

  void send({@required String topic, String message}) {
    if (_topics.containsKey(topic)){
      channel.sink.add("SEND\n" +
          "destination:" + topic + "\n" +
          "content-type:text/plain\n" +
          "\n" +
          message + "\n" +
          "\n" +
          "\x00");
    }
  }
}
