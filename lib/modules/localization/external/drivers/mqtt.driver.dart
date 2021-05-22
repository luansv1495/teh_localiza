import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class MqttDriver {
  MqttServerClient client;

  Future init({
    String clientUid,
    String brokerUrl,
    int brokerPort,
    String user,
    String password,
    bool debug = false,
    Function(String, String) callback,
  }) async {
    await connect(
      clientUid: clientUid,
      brokerUrl: brokerUrl,
      brokerPort: brokerPort,
      user: user,
      password: password,
      debug: debug,
    );
    messageReceived(callback: callback);
  }

  Future<MqttServerClient> connect({
    String clientUid,
    String brokerUrl,
    int brokerPort,
    String user,
    String password,
    bool debug = false,
  }) async {
    client = MqttServerClient.withPort(
      brokerUrl,
      clientUid,
      brokerPort,
    );

    client.logging(on: debug);
    client.onConnected = () => print('Connected');
    client.onDisconnected = () => print('Disconnected');
    client.onUnsubscribed = (topic) => print('Unsubscribed topic: $topic');
    client.onSubscribed = (topic) => print('Subscribed topic: $topic');
    client.onSubscribeFail = (topic) => print('Failed to subscribe $topic');
    client.autoReconnect = true;

    final connMessage = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientUid)
        .keepAliveFor(60)
        .withWillQos(mqtt.MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect(user, password);
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    return client;
  }

  messageReceived({Function(String, String) callback}) {
    client.updates.listen(
      (
        List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>> c,
      ) async {
        final mqtt.MqttPublishMessage message = c[0].payload;

        final payload = mqtt.MqttPublishPayload.bytesToStringAsString(
          message.payload.message,
        );

        callback(payload, c[0].topic);
      },
    );
  }

  int publish({String message, String topic}) {
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(message);

    int msgId = client.publishMessage(
      topic,
      mqtt.MqttQos.atLeastOnce,
      builder.payload,
    );

    return msgId;
  }
}
