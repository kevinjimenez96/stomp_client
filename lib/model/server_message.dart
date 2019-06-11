 import 'dart:collection';
 
 class ServerMessage{
  HashMap<String,String> data;

  ServerMessage(String message){
    data = HashMap();
    var dataSplitted = message.split("\n");
    dataSplitted.removeAt(0);
    while(dataSplitted[0] != ""){
      var lineSplitted = dataSplitted[0].split(":");
      data[lineSplitted[0]] = lineSplitted[1];
      dataSplitted.removeAt(0);
    }
    dataSplitted.removeAt(0);
    data["content"] = "";
    while(dataSplitted[0] != ""){
      data["content"] += dataSplitted[0] + "\n";
      dataSplitted.removeAt(0);
    }
  }
 }