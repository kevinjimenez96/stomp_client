library stomp_client;

import 'dart:collection';
import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

/// A Stomp Client.
class StompClient {
  IOWebSocketChannel channel;
  Stream<dynamic> stream;
  HashMap<String, int> _topics;
  HashMap<String, StreamController<HashMap>> _streams;
  bool connected;
  int _topicsCount;
  StreamController<String> general;

  StompClient({@required urlBackend}) {
    channel = IOWebSocketChannel.connect(urlBackend);
    stream = channel.stream;
    channel.stream.listen((message) {
      // handling of the incoming messages
      //print(message);
      messageReceieved(message);
    }, onError: (error, StackTrace stackTrace) {
      // error handling
    }, onDone: () {
      // communication has been closed
    });
    general = StreamController();
    _topics = HashMap();
    _streams = HashMap();
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
    channel.sink.add("DISCONNECT\n" + "\n" + "\x00");
    channel.sink.close();
  }

  StreamController<HashMap> subscribe( {@required String topic}) {
    if (!_topics.containsKey(topic)) {
      _topics[topic] = _topicsCount;
      _streams[topic] = new StreamController<HashMap>();
      channel.sink.add("SUBSCRIBE\n" +
          "id:" +
          _topicsCount.toString() +
          "\n" +
          "destination:" +
          topic +
          "\n" +
          "ack:auto\n" +
          "\n" +
          "\x00");
      _topicsCount++;
      return _streams[topic];
    }
    return null;
  }

  void unsubscribe({@required String topic}) {
    if (_topics.containsKey(topic)) {
      channel.sink.add("UNSUBSCRIBE\n" +
          "id:" +
          _topics[topic].toString() +
          "\n" +
          "\n" +
          "\x00");
      _topics.remove(topic);
      _streams.remove(topic);
    }
  }

  void send({@required String topic, String message}) {
    if (_topics.containsKey(topic)) {
      channel.sink.add("SEND\n" +
          "destination:" +
          topic +
          "\n" +
          "content-type:text/plain\n" +
          "\n" +
          message +
          "\n" +
          "\n" +
          "\x00");
    }
  }

  void messageReceieved(String message) {
    //general.add(message);
    if(message.split("\n")[0] == "MESSAGE"){
      HashMap messageHashMap = _messageToHashMap(message);
      _streams[messageHashMap["destination"]].add(messageHashMap);
      
    }else{
        general.add(message);
    }
  }

  HashMap _messageToHashMap(String message){
    HashMap<String,String> data = HashMap();
    var dataSplitted = message.split("\n");
    data["type"] = dataSplitted[0];
    dataSplitted.removeAt(0);
    while(dataSplitted[0] != ""){
      var lineSplitted = dataSplitted[0].split(":");
      data[lineSplitted[0]] = lineSplitted[1];
      dataSplitted.removeAt(0);
    }
    dataSplitted.removeAt(0);
    data["content"] = "";
    while(dataSplitted.length > 0 && dataSplitted[0] != ""){
      data["content"] += dataSplitted[0] + "\n";
      dataSplitted.removeAt(0);
    }
    return data;
  }
}
