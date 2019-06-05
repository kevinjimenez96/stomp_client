import 'package:flutter_test/flutter_test.dart';

import 'package:stomp_client/stomp_client.dart';

void main() {
  test('connect to backend', () {
    final ws = StompClient( urlBackend: "ws://192.168.1.6:8080/ws");
    ws.connectWithToken("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0YXhpc3RhMUB0YXhpc3RhLmNvbSIsIm5vbWJyZSI6IlRheGlzdGEiLCJhcGVsbGlkbzEiOiJhcGVsbGlkbyIsImFwZWxsaWRvMiI6ImFwZWxsaWRvIiwidGVsZWZvbm8iOiIxMTExMTExMSIsImZvdG9VcmwiOiJmb3RvIiwicGVybWlzb3MiOlsiMjAwIl0sInJvbCI6IlRheGlzdGEiLCJlc3RhZG8iOnRydWUsImp1c3RpZmljYWNpb24iOiJqdXN0aWZpY2FjacOzbiIsImlhdCI6MTU1OTcwMTkxMSwiZXhwIjoxNTU5NzA1NTExfQ.ei11v_VEVVPB6NgV8J0z4g-yFeOru3zta90hwSn0WiE");
  });
}
